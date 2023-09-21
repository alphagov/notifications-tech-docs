---
applications:
- name: notify-tech-docs
  memory: 64M
  buildpack: staticfile_buildpack
  health-check-type: http
  health-check-http-endpoint: /index.html
  stack: cflinuxfs4
  routes:
    - route: {{ROUTE}}
