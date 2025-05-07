resource "random_password" "jwt_secret" {
  length  = 32
  special = false
}
resource "random_password" "session_secret" {
  length  = 32
  special = false
}
resource "random_password" "data_encryption_key" {
  length  = 32
  special = false
}
locals {
  environment = {
    #-----------------------Backend Config------------------------------#
    # Prisma Config
    DATABASE_URL = "postgresql://${module.postgres.username}:${nonsensitive(module.postgres.password)}@${module.postgres.service_name}:5432/${module.postgres.database}"

    # (Optional) By default, the AIO container (when in subpath access mode) exposes the endpoint on port 80. Use this setting to specify a different port if needed.
    HOPP_AIO_ALTERNATE_PORT = 80

    # Auth Tokens Config
    JWT_SECRET                = nonsensitive(random_password.jwt_secret.result)
    TOKEN_SALT_COMPLEXITY     = 10
    MAGIC_LINK_TOKEN_VALIDITY = 3
    # Default validity is 7 days (604800000 ms) in ms
    REFRESH_TOKEN_VALIDITY = 604800000
    # Default validity is 1 day (86400000 ms) in ms
    ACCESS_TOKEN_VALIDITY = 86400000
    SESSION_SECRET        = nonsensitive(random_password.session_secret.result)

    # Recommended to be true, set to false if you are using http
    # Note: Some auth providers may not support http requests
    ALLOW_SECURE_COOKIES = true

    # Sensitive Data Encryption Key while storing in Database (32 character)
    DATA_ENCRYPTION_KEY = nonsensitive(random_password.data_encryption_key.result)

    # Hoppscotch App Domain Config
    REDIRECT_URL = "http://${var.domains.frontend}"
    # Whitelisted origins for the Hoppscotch App.
    # This list controls which origins can interact with the app through cross-origin comms.
    # - localhost ports (3170, 3000, 3100): app, backend, development servers and services
    # - app://localhost_3200: Bundle server origin identifier
    #   NOTE: `3200` here refers to the bundle server (port 3200) that provides the bundles,
    #   NOT where the app runs. The app itself uses the `app://` protocol with dynamic
    #   bundle names like `app://{bundle-name}/`

    WHITELISTED_ORIGINS = join(",", [
      "https://${var.domains.frontend}",
      "https://${var.domains.admin}",
      "https://${var.domains.backend}",
      #"http://${local.domain}:3170",
      #"http://${local.domain}:3000",
      #"http://${local.domain}:3100",
      #"app://${local.domain}:3200",
      "app://hoppscotch"
    ])
    #VITE_ALLOWED_AUTH_PROVIDERS = "GOOGLE,GITHUB,MICROSOFT,EMAIL"
    VITE_ALLOWED_AUTH_PROVIDERS = "EMAIL"

    # Google Auth Config
    #GOOGLE_CLIENT_ID=************************************************
    #GOOGLE_CLIENT_SECRET=************************************************
    #GOOGLE_CALLBACK_URL=http://${local.domain}:3170/v1/auth/google/callback
    #GOOGLE_SCOPE=email,profile

    # Github Auth Config
    #GITHUB_CLIENT_ID=************************************************
    #GITHUB_CLIENT_SECRET=************************************************
    #GITHUB_CALLBACK_URL=http://${local.domain}:3170/v1/auth/github/callback
    #GITHUB_SCOPE=user:email

    # Microsoft Auth Config
    #MICROSOFT_CLIENT_ID=************************************************
    #MICROSOFT_CLIENT_SECRET=************************************************
    #MICROSOFT_CALLBACK_URL=http://${local.domain}:3170/v1/auth/microsoft/callback
    #MICROSOFT_SCOPE=user.read
    #MICROSOFT_TENANT=common

    # Mailer config
    MAILER_SMTP_ENABLE        = false
    MAILER_USE_CUSTOM_CONFIGS = false
    MAILER_ADDRESS_FROM       = "<from@example.com>"
    MAILER_SMTP_URL           = "smtps://user@domain.com:pass@smtp.domain.com" # used if custom mailer configs is false

    # The following are used if custom mailer configs is true
    MAILER_SMTP_HOST               = var.smtp.host
    MAILER_SMTP_PORT               = var.smtp.port
    MAILER_SMTP_SECURE             = var.smtp.secure
    MAILER_SMTP_USER               = var.smtp.username
    MAILER_SMTP_PASSWORD           = var.smtp.password
    MAILER_TLS_REJECT_UNAUTHORIZED = true

    # Rate Limit Config
    RATE_LIMIT_TTL = 60  # In seconds
    RATE_LIMIT_MAX = 100 # Max requests per IP

    #-----------------------Frontend Config------------------------------#

    # Base URLs
    VITE_BASE_URL           = "https://${var.domains.frontend}"
    VITE_SHORTCODE_BASE_URL = "https://${var.domains.frontend}"
    VITE_ADMIN_URL          = "https://${var.domains.admin}"

    # Backend URLs
    VITE_BACKEND_GQL_URL = "https://${var.domains.backend}/graphql"
    VITE_BACKEND_WS_URL  = "wss://${var.domains.backend}/graphql"
    VITE_BACKEND_API_URL = "https://${var.domains.backend}/v1"

    # Terms Of Service And Privacy Policy Links (Optional)
    VITE_APP_TOS_LINK            = "https://docs.hoppscotch.io/support/terms"
    VITE_APP_PRIVACY_POLICY_LINK = "https://docs.hoppscotch.io/support/privacy"

    # Set to `true` for subpath based access
    ENABLE_SUBPATH_BASED_ACCESS = false
  }
}