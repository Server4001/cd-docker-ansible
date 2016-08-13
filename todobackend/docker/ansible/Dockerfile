FROM alpine:3.4

MAINTAINER Brice Bentler <me@bricebentler.com>

# Install Ansible.
RUN apk add --update \
    ansible

# Volume for Ansible playbooks.
VOLUME /ansible
WORKDIR /ansible

ENTRYPOINT ["ansible-playbook"]
CMD ["site.yml"]
