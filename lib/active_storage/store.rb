module ActiveStorage
  module Store
    def persisted?
      id.present?
    end

    def save
      persisted? ? remove_old_record : generate_id

      insert
    end

    def remove_old_record
      table = CSV.table(self.class.storage_path, col_sep: config.col_sep, headers: true)
      table.delete_if { |row| row[:id].to_s == id }

      File.open(self.class.storage_path, "w") do |f|
        f.write(table.to_csv)
      end
    end

    private

    def insert
      CSV.open(self.class.storage_path, "ab", col_sep: config.col_sep) do |csv|
        csv << ["id", *@@attributes].map { |attr| public_send(attr) }
      end
    end

    def generate_id
      self.id = Time.current.to_f
    end
  end
end
