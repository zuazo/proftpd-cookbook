default['onddo_proftpd']['conf_included_dirs'] = %w{modules conf.d}

# Configuration directives for the main proftpd.conf configuration file,
# separated by module name for documentation purposes.
# Only the mandatory core module directives are included.

default['onddo_proftpd']['main_config_directives']['core'] = %w{
  AllowFilter
  AllowForeignAddress
  AllowOverride
  AllowRetrieveRestart
  AllowStoreRestart
  Anonymous
  AnonymousGroup
  AuthOrder
  Bind
  CDPath
  Class
  CommandBufferSize
  DebugLevel
  DefaultAddress
  DefaultServer
  DefaultTransferMode
  DeferWelcome
  Define
  DenyFilter
  Directory
  DisplayChdir
  DisplayConnect
  DisplayGoAway
  DisplayLogin
  DisplayQuit
  Global
  Group
  IdentLookups
  IfDefine
  IfModule
  Include
  Limit
  MasqueradeAddress
  MaxConnectionRate
  MaxInstances
  MultilineRFC2228
  PassivePorts
  PathAllowFilter
  PathDenyFilter
  PidFile
  Port
  RLimitCPU
  RLimitMemory
  RLimitOpenFiles
  ScoreboardFile
  ServerAdmin
  ServerIdent
  ServerName
  ServerType
  SetEnv
  SocketBindTight
  SocketOptions
  SyslogFacility
  SyslogLevel
  tcpBackLog
  tcpNoDelay
  TimeoutIdle
  TimeoutLinger
  TimesGMT
  TransferLog
  Umask
  UnsetEnv
  UseIPv6
  User
  UseReverseDNS
  UseUTF8
  VirtualHost
  WtmpLog
}

default['onddo_proftpd']['main_config_directives']['auth'] = %w{
  AccessDenyMsg
  AccessGrantMsg
  AuthAliasOnly
  CreateHome
  DefaultChdir
  DefaultRoot
  GroupPassword
  LoginPasswordPrompt
  MaxClients
  MaxClientsPerClass
  MaxClientsPerHost
  MaxClientsPerUser
  MaxConnectionsPerHost
  MaxHostsPerUser
  MaxLoginAttempts
  RequireValidShell
  RootLogin
  RootRevoke
  TimeoutLogin
  TimeoutSession
  UseFtpUsers
  UserAlias
  UserPassword
  UseLastlog
}

default['onddo_proftpd']['main_config_directives']['auth_file'] = %w{
  AuthGroupFile
  AuthUserFile
}

default['onddo_proftpd']['main_config_directives']['auth_unix'] = %w{
  PersistentPasswd
}

default['onddo_proftpd']['main_config_directives']['cap'] = %w{
  CapabilitiesEngine
  CapabilitiesSet
}

default['onddo_proftpd']['main_config_directives']['log'] = %w{
  AllowLogSymlinks
  ExtendedLog
  LogFormat
  ServerLog
  SystemLog
}

default['onddo_proftpd']['main_config_directives']['ls'] = %w{
  DirFakeGroup
  DirFakeMode
  DirFakeUser
  ListOptions
  ShowSymlinks
  UseGlobbing
}

default['onddo_proftpd']['main_config_directives']['xfer'] = %w{
  AllowOverwrite
  DeleteAbortedStores
  DisplayFileTransfer
  HiddenStores
  MaxRetrieveFileSize
  MaxStoreFileSize
  StoreUniquePrefix
  TimeoutNoTransfer
  TimeoutStalled
  TransferRate
  UseSendfile
}
