APP_NAME = ${name}
APP_SLOGAN = ${slogan}
RUN_MODE = prod
RUN_USER = git
WORK_PATH = /data/gitea

[repository]
ROOT = /data/git/repositories

[repository.local]
LOCAL_COPY_PATH = /data/gitea/tmp/local-repo

[repository.upload]
TEMP_PATH = /data/gitea/uploads

[server]
APP_DATA_PATH = /data/gitea
DOMAIN = ${domain}
SSH_DOMAIN = ${domain}
HTTP_PORT = 3000
ROOT_URL = https://${domain}/
DISABLE_SSH = false
START_SSH_SERVER = true
SSH_PORT = ${ssh_port}
#SSH_LISTEN_PORT = ${ssh_port}
LFS_START_SERVER = true
LFS_JWT_SECRET = 4mO5Yya8SZU7Ux4gkI_0gHknpQXP0qovBgm08KtrVN4
OFFLINE_MODE = false

[database]
PATH = /data/gitea/gitea.db
DB_TYPE = postgres
HOST = ${database_host}:${database_port}
NAME = ${database_database}
USER = ${database_username}
PASSWD = ${database_password}
LOG_SQL = false
SCHEMA =
SSL_MODE = disable

[indexer]
ISSUE_INDEXER_PATH = /data/gitea/indexers/issues.bleve

[session]
PROVIDER_CONFIG = /data/gitea/sessions
PROVIDER = file

[picture]
AVATAR_UPLOAD_PATH = /data/gitea/avatars
REPOSITORY_AVATAR_UPLOAD_PATH = /data/gitea/repo-avatars

[attachment]
PATH = /data/gitea/attachments

[log]
MODE = console
LEVEL = Debug
ROOT_PATH = /data/gitea/log

[security]
INSTALL_LOCK = true
SECRET_KEY =
REVERSE_PROXY_LIMIT = 1
REVERSE_PROXY_TRUSTED_PROXIES = *
INTERNAL_TOKEN = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE3MTc1MTg0Njh9.8aE5mPl4hj4oRhg_C6gywYThjqpNF0WnSfqSG38LnK8
PASSWORD_HASH_ALGO = pbkdf2

[service]
DISABLE_REGISTRATION = true
REQUIRE_SIGNIN_VIEW = false
REGISTER_EMAIL_CONFIRM = false
ENABLE_NOTIFY_MAIL = false
ALLOW_ONLY_EXTERNAL_REGISTRATION = false
ENABLE_CAPTCHA = false
DEFAULT_KEEP_EMAIL_PRIVATE = true
DEFAULT_ALLOW_CREATE_ORGANIZATION = true
DEFAULT_ENABLE_TIMETRACKING = true
NO_REPLY_ADDRESS = ${email}

[lfs]
PATH = /data/git/lfs

[mailer]
ENABLED = false

[openid]
ENABLE_OPENID_SIGNIN = true
ENABLE_OPENID_SIGNUP = true

[cron.update_checker]
ENABLED = false

[repository.pull-request]
DEFAULT_MERGE_STYLE = merge

[repository.signing]
DEFAULT_TRUST_MODEL = committer

[oauth2]
JWT_SECRET = YYPen0kJxu9VjTflmyhwJ65Pm2TFYMbyKYqUhvD0PiA

[actions]
ENABLED = true
DEFAULT_ACTIONS_URL = https://github.com