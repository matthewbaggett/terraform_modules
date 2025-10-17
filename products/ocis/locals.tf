locals {
  env = {
    OCIS_URL : var.domain
    OCIS_LOG_LEVEL : var.log.level
    OCIS_LOG_COLOR : "true"
    OCIS_LOG_PRETTY : "true"
    OCIS_MAX_CONCURRENCY : 100

    PROXY_TLS : "false" # do not use SSL between LB and oCIS
    OCIS_INSECURE : "false"
    # Basic Auth is required for WebDAV clients that don't support OIDC
    PROXY_ENABLE_BASIC_AUTH : "false"
    OCIS_EXCLUDE_RUN_SERVICES : "idm" # Disable the built in LDAP server

    OCIS_LDAP_URI : var.ldap.uri
    OCIS_LDAP_INSECURE : var.ldap.insecure ? "true" : "false"
    OCIS_LDAP_BIND_DN : var.ldap.bind.dn
    OCIS_LDAP_BIND_PASSWORD : var.ldap.bind.password
    OCIS_ADMIN_USER_ID : var.ldap.admin_user_uuid

    GRAPH_LDAP_SERVER_WRITE_ENABLED : "false" # Does your LLDAP bind user have write access?
    GRAPH_LDAP_REFINT_ENABLED : "false"

    // User-related
    LDAP_LOGIN_ATTRIBUTES : "uid,mail"

    GROUPS_DRIVER : "ldap"
    IDP_LDAP_LOGIN_ATTRIBUTE : "uid"
    IDP_LDAP_UUID_ATTRIBUTE : "entryuuid"
    OCIS_LDAP_USER_ENABLED_ATTRIBUTE : "uid"
    OCIS_LDAP_USER_SCHEMA_ID : "entryuuid"
    OCIS_LDAP_USER_SCHEMA_USERNAME : "uid"
    #OCIS_LDAP_USER_SCHEMA_USER_TYPE : ""
    OCIS_LDAP_USER_BASE_DN : var.ldap.user_base_dn
    OCIS_LDAP_USER_OBJECTCLASS : "person"
    OCIS_LDAP_USER_FILTER : var.ldap.user_filter

    // group related
    OCIS_LDAP_GROUP_SCHEMA_ID : "uid"
    OCIS_LDAP_GROUP_SCHEMA_GROUPNAME : "uid"
    OCIS_LDAP_GROUP_BASE_DN : var.ldap.group_base_dn
    OCIS_LDAP_GROUP_OBJECTCLASS : "groupOfUniqueNames"
    OCIS_LDAP_GROUP_FILTER : var.ldap.group_filter

    // Storage bumpf
    STORAGE_USERS_DRIVER : "s3ng"
    STORAGE_USERS_S3NG_ENDPOINT : var.s3.endpoint
    STORAGE_USERS_S3NG_REGION : var.s3.region
    STORAGE_USERS_S3NG_ACCESS_KEY : var.s3.access_key
    STORAGE_USERS_S3NG_SECRET_KEY : var.s3.secret_key
    STORAGE_USERS_S3NG_BUCKET : var.s3.bucket
    STORAGE_USERS_TRANSFER_EXPIRES : 60 * 60 * 6 # How long in seconds to wait for processing, max
    STORAGE_SYSTEM_DRIVER : "ocis"
  }
}
