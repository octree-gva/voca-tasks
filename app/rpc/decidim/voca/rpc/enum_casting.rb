module Decidim
  module Voca
    module Rpc
      class EnumCaster
        attr_reader :decidim_rpc_mapping, :symbolic_mapping
        def initialize(enum_module, decidim_rpc_mapping)
          @decidim_rpc_mapping = decidim_rpc_mapping.deep_symbolize_keys
          @symbolic_mapping =  Hash[enum_module.descriptor.collect { |i| [i, enum_module.resolve(i)] }]
        end

        def decidim_to_rpc(decidim_key)
          matches = decidim_rpc_mapping.find { |k, _v| k === decidim_key.to_sym }
          (matches || []).last
        end

        def rpc_to_decidim(rpc_symbol)
          rpc_value = symbolic_mapping[rpc_symbol]
          matches = decidim_rpc_mapping.find { |_k, v| v === rpc_value }
          (matches || []).first
        end
      end

      module EnumCasting
        include ::VocaDecidim

        def self.machine_translation_display_priority
          EnumCaster.new(SETTINGS_MACHINE_TRANSLATION_PRIORITY_OPTION, {
            "original" => SETTINGS_MACHINE_TRANSLATION_PRIORITY_OPTION::SETTINGS_MACHINE_TRANSLATION_PRIORITY_ORIGINAL,
            "translated" => SETTINGS_MACHINE_TRANSLATION_PRIORITY_OPTION::SETTINGS_MACHINE_TRANSLATION_PRIORITY_TRANSLATED
          })
        end

        def self.users_registration_mode
          EnumCaster.new(SETTINGS_REGISTER_MODE_OPTION, {
              "enabled": SETTINGS_REGISTER_MODE_OPTION::SETTINGS_REGISTER_MODE_REGISTER_AND_LOGIN,
              "existing": SETTINGS_REGISTER_MODE_OPTION::SETTINGS_REGISTER_MODE_LOGIN,
              "disabled": SETTINGS_REGISTER_MODE_OPTION::SETTINGS_REGISTER_MODE_EXTERNAL
            })
        end

        def self.smtp_authentication
          EnumCaster.new(SETTINGS_SMTP_AUTHENTICATION_OPTION, {
            "plain": SETTINGS_SMTP_AUTHENTICATION_OPTION::SETTINGS_SMTP_AUTHENTICATION_PLAIN,
            "login": SETTINGS_SMTP_AUTHENTICATION_OPTION::SETTINGS_SMTP_AUTHENTICATION_LOGIN,
            "cram_md5": SETTINGS_SMTP_AUTHENTICATION_OPTION::SETTINGS_SMTP_AUTHENTICATION_CRAM_MD5,
            "none": SETTINGS_SMTP_AUTHENTICATION_OPTION::SETTINGS_SMTP_AUTHENTICATION_NONE
          })
        end
        def self.smtp_openssl_verify_mode
          EnumCaster.new(SETTINGS_SMTP_OPENSSL_OPTION, {
            "none": SETTINGS_SMTP_OPENSSL_OPTION::SETTINGS_SMTP_OPENSSL_NONE,
            "peer": SETTINGS_SMTP_OPENSSL_OPTION::SETTINGS_SMTP_OPENSSL_PEER,
          })
        end
      end
    end
  end
end
