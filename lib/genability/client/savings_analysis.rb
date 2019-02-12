module Genability
  class Client
    module SavingsAnalysis
      def analysis(options = {})
        post("v1/accounts/analysis", analysis_params(options)).results.first
      end

      private

      def analysis_params(options)
        {
          "accountId" => options[:account_id],
          "providerAccountId" => options[:provider_account_id],
          "fromDateTime" => format_to_ymd(options[:from] || options[:from_date_time]),
          "toDateTime" => format_to_ymd(options[:to] || options[:to_date_time]),
          "tariffEffectiveOn" => format_to_ymd(options[:tariff_effective_on]),
          "autoBaseline" => convert_to_boolean(options[:auto_baseline]),
          "useIntelligentBaselining" => convert_to_boolean(options[:use_intelligent_baselining]),
          "populateCosts" => options[:populate_costs],
          "fields" => options[:fields],
          "propertyInputs" => tariff_inputs_params(options[:property_inputs]),
          "rateInputs" => rate_inputs_params(options[:rate_inputs])
        }.
        delete_if{ |k,v| v.nil? }
      end
    end
  end
end

