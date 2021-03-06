require 'net/https'
require 'uri'
require 'json'
require 'rubygems'
require 'pp'
require 'thor'
require 'pry'
require 'Base64'
require 'rm2jira/logger'
require 'rm2jira/jira'
require 'rm2jira/redmine'
require 'rm2jira/parse_data'
require 'rm2jira/validator'
require 'rm2jira/configuration'


module RM2Jira
  class CLI < Thor
    def initialize(*args)
      super
      @config = RM2Jira::Configuration.new.config
    end

    desc "list_projects", "lists available projects"
    def list_projects
      @config['projects'].each_key { |project| puts project }
    end

    desc "migrate_tickets [project_name] [jira_project] (ticket_id)", "migrates tickets from redmine to jira. if restarting the application use last ticket id"
    def migrate_tickets(project_name, jira_project, ticket_id = 0)
      $jira_project = jira_project
      ticket_ids = RM2Jira::Redmine.get_issue_ids(@config['projects'][project_name], project_name)
      RM2Jira::Redmine.get_issues(ticket_ids, ticket_id)
    end

    desc "upload_single_ticket [ticket_id]", "migrates a single tickets from redmine to jira(mainly used for test purposes)"
    def upload_single_ticket(ticket_id)
      RM2Jira::Redmine.upload_single_ticket(ticket_id)
    end

    desc "download_pdfs [project_name] (ticket_id)", 'downloads pdfs from redmine. if restarting the application use last ticket id'
    def download_pdfs(project_name, ticket_id = 0)
      ticket_ids = RM2Jira::Redmine.get_issue_ids(@config['projects'][project_name])
      RM2Jira::Redmine::PDF.download_pdfs(ticket_ids, ticket_id)
    end
  end
end
