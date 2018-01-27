require 'csv'

class ParsingCsv
  def self.get_hash_from_csv(portfolio_file_name)
    data = CSV.read(portfolio_file_name, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all})
    hashed_data = data.map { |d| d.to_hash }
  end
end