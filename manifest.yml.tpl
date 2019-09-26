---
applications:
- name: notify-tech-docs
  memory: 64M
  buildpack: staticfile_buildpack
  routes:
    - route: {{ROUTE}}
