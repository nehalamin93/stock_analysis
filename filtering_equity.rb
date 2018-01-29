require_relative 'parsing_csv.rb'

class FilteringEquity
  MUTUAL_FUNDS_FOLDER = "mutual_funds_portfolios"
  MUTUAL_FUNDS_PORTFOLIOS = Dir.glob("#{MUTUAL_FUNDS_FOLDER}/*.csv")

  # Mutual funds = List of equities invested on
  def self.get_funds_with_equity_list
    fund_with_equity_hash = {}
    MUTUAL_FUNDS_PORTFOLIOS.each do |individual_portfolio_file|
      fund_with_equity_hash[get_fund_name(individual_portfolio_file)] = get_equity_list_from_array_of_hash(individual_portfolio_file)
    end
    fund_with_equity_hash
  end

  # Get Equities which are common among all mutual funds inside MUTUAL_FUNDS_FOLDER 
  def self.get_common_equity_among_mutual_funds
    common_equity = []

    get_funds_with_equity_list.each_with_index do |(fund_name, equity_list), index|
      if index == 0
        common_equity = equity_list
      else
        common_equity &= equity_list
      end
    end
    common_equity
  end

  # Get hash of equity details { equity1 => details1 , equity2 => details2}
  def self.get_equity_details_among_mutual_funds
    equity_details = {}

    MUTUAL_FUNDS_PORTFOLIOS.each do |individual_portfolio_file|
      hash_equity_array = ParsingCsv.get_hash_from_csv(individual_portfolio_file)
      fund_name = get_fund_name(individual_portfolio_file)
      hash_equity_array = ParsingCsv.get_hash_from_csv(individual_portfolio_file)
      hash_equity_array.each do |equity_hash|
        equity_name = equity_hash[:equity]
        if equity_details[equity_name].nil?
          equity_details[equity_name] = { 
                                          :count => 0,
                                          :sector => "",
                                          :funds_list => []
                                        }
        end
        equity_details[equity_name][:count] += 1
        equity_details[equity_name][:sector] = equity_hash[:sector]
        equity_details[equity_name][:funds_list] << {
                                                      :fund_name => fund_name,
                                                      :quantity => equity_hash[:quantity],
                                                      :value => equity_hash[:value],
                                                      :percentage => equity_hash[:percentage]
                                                    }
      end
    end
    equity_details
  end

  # Get equities list which are repeated among mutual funds 
  def self.get_equity_with_repeatation_more_than_value(count_val)
    equity_hash = {}
    get_equity_details_among_mutual_funds.each do |fund_name, details_of_fund|
      equity_hash[fund_name] = details_of_fund  if details_of_fund[:count] >= count_val
    end
    equity_hash
  end

  private

  def self.get_fund_name(individual_portfolio_file)
    individual_portfolio_file[(MUTUAL_FUNDS_FOLDER.length()+1)...-4]
  end

  def self.get_equity_list_from_array_of_hash(individual_portfolio_file)
    hash_equity_array = ParsingCsv.get_hash_from_csv(individual_portfolio_file)
    equity_list = hash_equity_array.map{ |equity_hash| equity_hash[:equity] }
  end
end

