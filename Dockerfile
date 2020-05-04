FROM ruby:2.7-alpine

LABEL "com.github.actions.name"="Comment JIRA issue number on PR"
LABEL "com.github.actions.description"="Leaves a JIRA issue number(MD-*) as a comment on a PR."
LABEL "com.github.actions.repository"="https://github.com/momentumdash/comment-on-pr"
LABEL "com.github.actions.maintainer"="<Sayam Hussain <sayam@momentumdash.com>"
LABEL "com.github.actions.icon"="message-square"
LABEL "com.github.actions.color"="blue"

RUN gem install octokit

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]