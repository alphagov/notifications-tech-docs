---
applications:
- name: notify-tech-docs
  memory: 64M
  buildpack: staticfile_buildpack
  health-check-type: http
  health-check-http-endpoint: /index.html
  routes:
    - route: {{ROUTE}}
