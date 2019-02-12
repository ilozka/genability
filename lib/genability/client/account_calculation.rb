module Genability
  class Client
    module AccountCalculation
      def account_calculation(account_id, options = {})
        post("v1/accounts/#{account_id}/calculate", calculation_params(options)).results.first
      end

      def provider_account_calculation(provider_account_id, options = {})
        post("v1/accounts/pid/#{provider_account_id}/calculate", calculation_params(options)).results.first
      end

      private

      def calculation_params(options)
        {
          "fromDateTime" => format_to_iso8601(options[:from] || options[:from_date_time]),
          "toDateTime" => format_to_iso8601(options[:to] || options[:to_date_time]),
          "tariffEffectiveOn" => format_to_ymd(options[:tariff_effective_on]),
          "detailLevel" => convert_to_upcase(options[:detail_level]),
          "groupBy" => convert_to_upcase(options[:group_by]),
          "tiers" => convert_to_upcase(options[:tiers]),
          "includeDefaultProfile" => convert_to_boolean(options[:include_default_profile]),
          "profileId" => options[:profile_id],
          "dataFactor" => options[:data_factor],
          "billingPeriod" => convert_to_boolean(options[:billing_period]),
          "minimums" => convert_to_boolean(options[:minimums]),
          "applyUtilityTax" => convert_to_boolean(options[:apply_utility_tax]),
          "calcNetExcessGeneration" => convert_to_boolean(options[:calc_net_excess_generation]),
          "excludeChargeClass" => multi_option_handler(options[:exclude_charge_class]),
          "autoBaseline" => convert_to_boolean(options[:auto_baseline]),
          "useIntelligentBaselining" => convert_to_boolean(options[:use_intelligent_baselining]),
          "masterTariffId" => options[:master_tariff_id],
          "fields" => options[:fields],
          "propertyInputs" => tariff_inputs_params(options[:property_inputs]),
          "rateInputs" => rate_inputs_params(options[:rate_inputs])
        }.
        delete_if{ |k,v| v.nil? }
      end
    end
  end
end

