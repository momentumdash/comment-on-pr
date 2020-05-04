#!/usr/bin/env ruby

require "json"
require "octokit"

json = File.read(ENV.fetch("GITHUB_EVENT_PATH"))
event = JSON.parse(json)

github = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])

if !ENV["GITHUB_TOKEN"]
  puts "Missing GITHUB_TOKEN"
  exit(1)
end

repo = event["repository"]["full_name"]

if ENV.fetch("GITHUB_EVENT_NAME") == "pull_request"
  pr_number = event["number"]
else
  pulls = github.pull_requests(repo, state: "open")

  push_head = event["after"]
  pr = pulls.find { |pr| pr["head"]["sha"] == push_head }

  if !pr
    puts "Couldn't find an open PR for branch with head at #{push_head}."
    exit(1)
  end
  pr_number = pr["number"]
end

pr_title = event["pull_request"]["title"]
branch_name = event["pull_request"]["head"]["ref"]
item_matched = ""

if pr_title.match(/[Mm][Dd][- ][0-9]*/)
  item_matched = pr_title
elsif branch_name.match(/[Mm][Dd][- ][0-9]*/)
  item_matched = branch_name
else
  puts "No JIRA issue found in PR title or Branch name"
  exit(0)
end

message = ""
if item_matched.scan(/[Mm][Dd][- ][0-9]*/).any?
  message = item_matched.scan(/[Mm][Dd][- ][0-9]*/).first.upcase.gsub(/ /, '-')
end

coms = github.issue_comments(repo, pr_number)
duplicate = coms.find { |c| c["user"]["login"] == "github-actions[bot]" && c["body"] == message }
if duplicate
  puts "PR already contains JIRA issue comment"
  exit(0)
end

if !message.empty? 
  github.add_comment(repo, pr_number, message)
else 
  puts "No JIRA issue found in PR title or Branch name"
end
