version: '3.2'
networks:
    webproxy:
        driver: bridge
services:
    prometheus:
        container_name: prometheus
        image: prom/prometheus
        ports: 
        - '9090:9090'
        command:
        - --config.file=/etc/prometheus/prometheus.yml
        volumes: 
        - /opt/docker_tool/prometheus.yml:/etc/prometheus/prometheus.yml
        networks:
        - webproxy
    grafana:
        container_name: grafana
        image: grafana/grafana
        volumes:                                                                                                                              
        - /opt/docker_tool/grafana/data:/var/lib/grafana
        ports: 
        - '3000:3000'
        depends_on: 
        - prometheus
        networks: 
        - webproxy
    node:
        container_name: node-exporter
        image: prom/node-exporter
        volumes:
        - /proc:/host/proc:ro
        - /sys:/host/sys:ro
        - /:/rootfs:ro
        command:
        - --path.procfs=/host/proc
        - --path.rootfs=/rootfs
        - --path.sysfs=/host/sys
        ports:
        - '9100:9100'
        networks: 
        - webproxy


    jenkins:
        container_name: Jenkins
        image: jenkins/jenkins
        user: root
        volumes:
        - /opt/jenkins_home:/opt/jenkins_home
        - /opt/jenkins_home/servers/identity/app:/srv/app
        - /var/run/docker.sock:/var/run/docker.sock
        ports:
        - '8080:8080'
        - '50000:50000'
        networks: 
        - webproxy

