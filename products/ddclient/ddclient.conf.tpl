# General Configuration
daemon=${interval}
syslog=yes

# Router
usev4=${router}

# Dynamic DNS service
protocol=${protocol}
%{ if login != null }login=${login}%{ endif }
%{ if password != null }password=${password}%{ endif }
%{ if apikey != null }apikey=${apikey}%{ endif }
%{ if secretapikey != null }secretapikey=${secretapikey}%{ endif }
%{ if onrootdomain == true }on-root-domain=yes %{ endif }${domain}