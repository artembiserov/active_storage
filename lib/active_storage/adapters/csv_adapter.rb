module ActiveStorage
  module Adapters
    module CsvAdapter
      extend self

      def connect(klass)
        return if File.exist?(klass.storage_path)

        FileUtils.mkdir_p(config.database_path)
        CSV.open(klass.storage_path, "ab", col_sep: config.col_sep) do |csv|
          csv << ["id", *klass.attribute_names]
        end
      end

      def records(klass)
        records = table(klass).entries

        records.map do |record|
          params = Hash[*record.to_a.flatten]
          klass.new(params)
        end
      end

      def save(record)
        persisted?(record) ? remove_old_record(record) : generate_id(record)

        insert(record)
      end

      def persisted?(record)
        record.id.present?
      end

      def where(records, attrs)
        records.select do |record|
          attrs.inject(true) { |result, (key, value)| result && record.public_send(key) == value }
        end
      end

      private

      def remove_old_record(record)
        table = table(record.class)
        table.delete_if { |row| row[:id].to_s == record.id }

        File.open(record.class.storage_path, "w") do |f|
          f.write(table.to_csv)
        end
      end

      def table(klass)
        CSV.read(klass.storage_path, col_sep: config.col_sep, headers: true)
      end

      def generate_id(record)
      record.id = Time.current.to_f
      end

      def insert(record)
        CSV.open(record.class.storage_path, "ab", col_sep: config.col_sep) do |csv|
          csv << ["id", *record.attribute_names].map { |attr| public_send(attr) }
        end
      end

      def config
        ActiveStorage.config
      end
    end
  end
end
