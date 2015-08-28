require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'utils/title_parser'
require 'facter'

module Puppet
  #
  Type.newtype(:wls_jdbc_persistence_store) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::TitleParser

    desc 'This resource allows you to manage a JDBC persistence stores in an WebLogic domain.'

    ensurable

    set_command(:wlst)

    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { 'action' => 'index', 'type' => 'wls_jdbc_persistence_store' }
      wlst template('puppet:///modules/orawls/providers/wls_jdbc_persistence_store/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_jdbc_persistence_store/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_jdbc_persistence_store/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_jdbc_persistence_store/destroy.py.erb', binding)
    end

    parameter :domain
    parameter :name
    parameter :jdbc_persistence_name
    parameter :timeout
    property :datasource
    property :prefix_name
    property :target
    property :targettype

    add_title_attributes(:jdbc_persistence_name) do
      /^((.*\/)?(.*)?)$/
    end

  end
end
