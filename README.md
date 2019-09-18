# C4-Cisco-DNA-C-Web-App
使用Cisco DNA-C API开发的网管系统WebApp

# 运行环境

* python
* Nodejs
* Vuejs

# 使用指南

1.启动后端数据库服务器：
```sh
$ python server.py
```

2.运行Web服务器：
```sh
$ node server.js
```

3.启动客户端：
```sh
$ npm run dev
```

4.客户端运行在http://localhost:8000
  用户名/密码：admin/admin
 
# 开发指南

- 网管系统由Cisco DNA-C服务器提供数据支持，所测试的网络环境参考https://developer.cisco.com/docs/dna-center/#!cisco-dna-center-sandboxes/cisco-dna-center-sandboxes
- 数据库服务器通过API访问Cisco DNA-C服务器获取数据，API信息参考https://developer.cisco.com/site/dna-center-rest-api/?version=1.210

