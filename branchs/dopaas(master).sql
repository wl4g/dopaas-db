/*
 Navicat Premium Data Transfer

 Source Server         : mysql#local
 Source Server Type    : MySQL
 Source Server Version : 50728
 Source Host           : 127.0.0.1:3306
 Source Schema         : dopaas

 Target Server Type    : MySQL
 Target Server Version : 50728
 File Encoding         : 65001

 Date: 21/03/2021 18:46:31
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cmdb_app_cluster
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_app_cluster`;
CREATE TABLE `cmdb_app_cluster` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '应用名称',
  `type` int(11) DEFAULT NULL COMMENT '应用集群的子类类型:(比docker_cluster和k8s_cluster的分类级别低)\n1如springboot app 或vue app,\n2,如umc-agent进程\n\n注:ci发布时,过滤掉type=2(不带端口的进程,如agent)',
  `endpoint` varchar(16) COLLATE utf8_bin NOT NULL COMMENT '端点:像sso这种则使用 port,  像agent则使用addr',
  `ssh_id` bigint(25) DEFAULT NULL,
  `deploy_type` int(2) NOT NULL COMMENT '1:host代表当部署在物理机;2:docker代表部署在docker集群;3:k8s代表部署在k8s集群;4:coss代表上传至coss',
  `enable` int(1) NOT NULL DEFAULT '1' COMMENT '启用状态（0:禁止/1:启用）',
  `remark` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注',
  `create_by` bigint(25) NOT NULL,
  `create_date` datetime NOT NULL,
  `update_by` bigint(25) NOT NULL,
  `update_date` datetime NOT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `update_by` (`update_by`) USING BTREE,
  KEY `create_by` (`create_by`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='应用集群（组）定义表';

-- ----------------------------
-- Table structure for cmdb_app_cluster_env
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_app_cluster_env`;
CREATE TABLE `cmdb_app_cluster_env` (
  `id` bigint(25) NOT NULL,
  `cluster_id` bigint(25) NOT NULL,
  `env_type` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '所属环境类型,取字典value',
  `run_command` text COLLATE utf8_bin COMMENT '启动命令',
  `repository_id` bigint(25) DEFAULT NULL COMMENT '关联docker_repository的id',
  `repository_namespace` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '命名空间',
  `custom_repository_config` text COLLATE utf8_bin COMMENT '自定义docker仓库配置,json',
  `remark` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注',
  `enable` int(1) NOT NULL DEFAULT '1' COMMENT '启用状态（0:禁止/1:启用）',
  `create_by` bigint(25) NOT NULL,
  `create_date` datetime NOT NULL,
  `update_by` bigint(25) NOT NULL,
  `update_date` datetime NOT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  `config_content` text COLLATE utf8_bin COMMENT 'docker和k8s使用的配置',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cluster_id` (`cluster_id`) USING BTREE,
  CONSTRAINT `cmdb_app_cluster_env_ibfk_1` FOREIGN KEY (`cluster_id`) REFERENCES `cmdb_app_cluster` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for cmdb_app_instance
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_app_instance`;
CREATE TABLE `cmdb_app_instance` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `cluster_id` bigint(25) NOT NULL COMMENT '应用分组ID',
  `version_id` bigint(25) DEFAULT NULL COMMENT '当前应用版本ID',
  `host_id` bigint(25) DEFAULT NULL,
  `k8s_id` bigint(25) DEFAULT NULL,
  `docker_id` bigint(25) DEFAULT NULL,
  `coss_ref_bucket` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '{cossProvider:"",bucketName:""}',
  `env_type` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '所属环境类型,1023改成去字典value',
  `enable` int(1) NOT NULL DEFAULT '1' COMMENT '启用状态（0:禁止/1:启用）',
  `remark` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注',
  `create_by` bigint(25) NOT NULL,
  `create_date` datetime NOT NULL,
  `update_by` bigint(25) NOT NULL,
  `update_date` datetime NOT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cluster_id` (`cluster_id`) USING BTREE,
  KEY `version_id` (`version_id`) USING BTREE,
  KEY `update_by` (`update_by`) USING BTREE,
  KEY `create_by` (`create_by`) USING BTREE,
  KEY `host_id` (`host_id`) USING BTREE,
  KEY `k8s_id` (`k8s_id`) USING BTREE,
  KEY `docker_id` (`docker_id`) USING BTREE,
  CONSTRAINT `cmdb_app_instance_ibfk_1` FOREIGN KEY (`cluster_id`) REFERENCES `cmdb_app_cluster` (`id`),
  CONSTRAINT `cmdb_app_instance_ibfk_2` FOREIGN KEY (`version_id`) REFERENCES `ucm_version` (`id`),
  CONSTRAINT `cmdb_app_instance_ibfk_3` FOREIGN KEY (`host_id`) REFERENCES `cmdb_host` (`id`),
  CONSTRAINT `cmdb_app_instance_ibfk_4` FOREIGN KEY (`k8s_id`) REFERENCES `cmdb_k8s_cluster` (`id`),
  CONSTRAINT `cmdb_app_instance_ibfk_5` FOREIGN KEY (`docker_id`) REFERENCES `cmdb_docker_cluster` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='应用分组（集群）的实例（节点）';

-- ----------------------------
-- Table structure for cmdb_dns_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_dns_operation_log`;
CREATE TABLE `cmdb_dns_operation_log` (
  `id` bigint(25) NOT NULL,
  `zone_type` int(2) DEFAULT NULL COMMENT '1PublicZone,2PrivateZone',
  `domain` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT 'e.g: wl4g.com,*.aa.wl4g.com',
  `oper_date` datetime DEFAULT NULL,
  `oper_by` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '张三 添加了解析记录 aa.wl4g.com -> 10.0.0.166',
  `result` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT 'SUCCESS,FAILED',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for cmdb_dns_private_blacklist
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_dns_private_blacklist`;
CREATE TABLE `cmdb_dns_private_blacklist` (
  `id` bigint(25) NOT NULL,
  `expression` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'domain的表达式，e.g: *.example.com; *.myapp.example.com',
  `type` varchar(4) COLLATE utf8_bin DEFAULT NULL COMMENT '黑白名单',
  `enable` int(11) NOT NULL,
  `remark` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `create_date` datetime NOT NULL,
  `create_by` bigint(25) NOT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for cmdb_dns_private_resolution
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_dns_private_resolution`;
CREATE TABLE `cmdb_dns_private_resolution` (
  `id` bigint(25) NOT NULL,
  `domain_id` bigint(25) DEFAULT NULL,
  `host` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `resolve_type` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT 'A,AAAA,CNAME,MX,SRV,TXT,NS,CAA',
  `line_isp` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '解析线路，默认为空',
  `value` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `ttl` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL COMMENT 'MX,SRV有效',
  `status` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '1:启用,0:禁用',
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `domain_id` (`domain_id`) USING BTREE,
  CONSTRAINT `cmdb_dns_private_resolution_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `cmdb_dns_private_zone` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for cmdb_dns_private_zone
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_dns_private_zone`;
CREATE TABLE `cmdb_dns_private_zone` (
  `id` bigint(25) NOT NULL,
  `zone` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'e.g: wl4g.com',
  `dns_server_id` bigint(25) DEFAULT NULL,
  `status` varchar(32) COLLATE utf8_bin NOT NULL COMMENT 'RUNNING,DISABLED,EXPIRED',
  `register_date` datetime DEFAULT NULL,
  `due_date` datetime DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `create_by` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0' COMMENT '删除状态（0：正常，1：删除）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `dns_server_id` (`dns_server_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='私有dns记录表';

-- ----------------------------
-- Table structure for cmdb_dns_public_zone
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_dns_public_zone`;
CREATE TABLE `cmdb_dns_public_zone` (
  `id` bigint(25) NOT NULL,
  `zone` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `dns_kind` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT 'e.g: AliyunDc, AwsDc, Cndns',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='公有dns记录表';

-- ----------------------------
-- Table structure for cmdb_docker_cluster
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_docker_cluster`;
CREATE TABLE `cmdb_docker_cluster` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `master_addr` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for cmdb_docker_instance
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_docker_instance`;
CREATE TABLE `cmdb_docker_instance` (
  `id` bigint(25) NOT NULL,
  `docker_id` bigint(25) NOT NULL,
  `host_id` bigint(25) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `docker_id` (`docker_id`) USING BTREE,
  KEY `host_id` (`host_id`) USING BTREE,
  CONSTRAINT `cmdb_docker_instance_ibfk_1` FOREIGN KEY (`docker_id`) REFERENCES `cmdb_docker_cluster` (`id`),
  CONSTRAINT `cmdb_docker_instance_ibfk_2` FOREIGN KEY (`host_id`) REFERENCES `cmdb_host` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for cmdb_docker_repository
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_docker_repository`;
CREATE TABLE `cmdb_docker_repository` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin NOT NULL,
  `registry_address` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '注册地址',
  `auth_config` text COLLATE utf8_bin COMMENT '任意认证方式的配置,json',
  `remark` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for cmdb_host
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_host`;
CREATE TABLE `cmdb_host` (
  `id` bigint(25) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT '显示名称',
  `hostname` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT '可链通的域名地址（不一定等于真实主机名）',
  `idc_id` bigint(25) NOT NULL COMMENT '机房id',
  `status` int(1) DEFAULT NULL COMMENT '主机状态（如：新建/启动中/运行中/停止中/停止/挂起）',
  `create_date` datetime DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idc_id` (`idc_id`) USING BTREE,
  CONSTRAINT `cmdb_host_ibfk_1` FOREIGN KEY (`idc_id`) REFERENCES `cmdb_idc` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='主机FQDN解析定义表(不一定跟物理机一一对应，仅表示host解析)';

-- ----------------------------
-- Table structure for cmdb_host_netcard
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_host_netcard`;
CREATE TABLE `cmdb_host_netcard` (
  `id` bigint(25) NOT NULL,
  `host_id` bigint(25) NOT NULL,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '网卡名称',
  `status` varchar(16) COLLATE utf8_bin DEFAULT NULL COMMENT '网卡状态，如：UP/DOWN',
  `vpn_tunnel_type` int(2) DEFAULT NULL COMMENT '隧道类型,1host,2openvpn,3pptp....',
  `openvpn_tunnel_id` bigint(25) DEFAULT NULL COMMENT '对应表:erm_host_tunnel_openvpn',
  `pptp_tunnel_id` bigint(25) DEFAULT NULL COMMENT '对应表:erm_host_tunnel_pptp',
  `ipv4` varchar(15) COLLATE utf8_bin DEFAULT NULL,
  `ipv6` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `hwaddr` varchar(17) COLLATE utf8_bin DEFAULT NULL COMMENT '硬件Mac地址',
  `netmask` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '子网掩码',
  `broadcast` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '广播地址',
  `getway` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '网关地址',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT NULL,
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `host_id` (`host_id`) USING BTREE,
  KEY `openvpn_tunnel_id` (`openvpn_tunnel_id`) USING BTREE,
  KEY `pptp_tunnel_id` (`pptp_tunnel_id`) USING BTREE,
  CONSTRAINT `cmdb_host_netcard_ibfk_1` FOREIGN KEY (`host_id`) REFERENCES `cmdb_host` (`id`),
  CONSTRAINT `cmdb_host_netcard_ibfk_2` FOREIGN KEY (`openvpn_tunnel_id`) REFERENCES `cmdb_host_tunnel_openvpn` (`id`),
  CONSTRAINT `cmdb_host_netcard_ibfk_3` FOREIGN KEY (`pptp_tunnel_id`) REFERENCES `cmdb_host_tunnel_pptp` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='(宿)主机网卡信息表';

-- ----------------------------
-- Table structure for cmdb_host_ssh
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_host_ssh`;
CREATE TABLE `cmdb_host_ssh` (
  `id` bigint(25) NOT NULL,
  `host_id` bigint(25) NOT NULL,
  `ssh_id` bigint(25) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `host_id` (`host_id`) USING BTREE,
  KEY `ssh_id` (`ssh_id`) USING BTREE,
  CONSTRAINT `cmdb_host_ssh_ibfk_1` FOREIGN KEY (`host_id`) REFERENCES `cmdb_host` (`id`),
  CONSTRAINT `cmdb_host_ssh_ibfk_2` FOREIGN KEY (`ssh_id`) REFERENCES `cmdb_ssh` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for cmdb_host_tunnel_openvpn
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_host_tunnel_openvpn`;
CREATE TABLE `cmdb_host_tunnel_openvpn` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `addr` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for cmdb_host_tunnel_pptp
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_host_tunnel_pptp`;
CREATE TABLE `cmdb_host_tunnel_pptp` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `addr` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for cmdb_idc
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_idc`;
CREATE TABLE `cmdb_idc` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `area_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '可用区编码（如：aliyun-shenzhen-a1）',
  `provider` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '数据中心云服务商，对应dict（如：aliyun/google/azure）',
  `loc_x` varchar(16) COLLATE utf8_bin DEFAULT NULL COMMENT '地理坐标X',
  `loc_y` varchar(16) COLLATE utf8_bin DEFAULT NULL COMMENT '地理坐标Y',
  `enable` int(11) DEFAULT NULL,
  `adress` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '地址',
  `time_zone` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '时区',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `provider` (`provider`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for cmdb_k8s_cluster
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_k8s_cluster`;
CREATE TABLE `cmdb_k8s_cluster` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `master_addr` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `secondary_master_addr` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for cmdb_k8s_instance
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_k8s_instance`;
CREATE TABLE `cmdb_k8s_instance` (
  `id` bigint(25) NOT NULL,
  `k8s_id` bigint(25) NOT NULL,
  `host_id` bigint(25) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `k8s_id` (`k8s_id`) USING BTREE,
  KEY `host_id` (`host_id`) USING BTREE,
  CONSTRAINT `cmdb_k8s_instance_ibfk_1` FOREIGN KEY (`k8s_id`) REFERENCES `cmdb_k8s_cluster` (`id`),
  CONSTRAINT `cmdb_k8s_instance_ibfk_2` FOREIGN KEY (`host_id`) REFERENCES `cmdb_host` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for cmdb_ssh
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_ssh`;
CREATE TABLE `cmdb_ssh` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '密码',
  `ssh_key` text COLLATE utf8_bin COMMENT '私钥',
  `ssh_key_pub` varchar(512) COLLATE utf8_bin DEFAULT NULL COMMENT '公钥',
  `auth_type` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '认证类型',
  `create_by` bigint(25) NOT NULL,
  `create_date` datetime NOT NULL,
  `update_by` bigint(25) NOT NULL,
  `update_date` datetime NOT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for gw_cluster
-- ----------------------------
DROP TABLE IF EXISTS `gw_cluster`;
CREATE TABLE `gw_cluster` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin NOT NULL,
  `namespace` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '用于区别各个GatewayServer',
  `address` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `address_type` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `idc_id` bigint(25) DEFAULT NULL,
  `status` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='gateway主标—对应多个gateway serve';

-- ----------------------------
-- Table structure for gw_route
-- ----------------------------
DROP TABLE IF EXISTS `gw_route`;
CREATE TABLE `gw_route` (
  `id` bigint(25) NOT NULL,
  `gateway_id` bigint(25) NOT NULL,
  `upstream_group_id` bigint(25) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_bin NOT NULL,
  `order` int(11) DEFAULT NULL,
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `gateway_id` (`gateway_id`) USING BTREE,
  KEY `upstream_group_id` (`upstream_group_id`) USING BTREE,
  CONSTRAINT `gw_route_ibfk_1` FOREIGN KEY (`gateway_id`) REFERENCES `gw_cluster` (`id`),
  CONSTRAINT `gw_route_ibfk_2` FOREIGN KEY (`upstream_group_id`) REFERENCES `gw_upstream_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='gateway的route主表';

-- ----------------------------
-- Table structure for gw_route_filter
-- ----------------------------
DROP TABLE IF EXISTS `gw_route_filter`;
CREATE TABLE `gw_route_filter` (
  `id` bigint(25) NOT NULL,
  `route_id` bigint(25) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `args` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `route_id` (`route_id`) USING BTREE,
  CONSTRAINT `gw_route_filter_ibfk_1` FOREIGN KEY (`route_id`) REFERENCES `gw_route` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='gateway的route过滤器表';

-- ----------------------------
-- Table structure for gw_route_predicate
-- ----------------------------
DROP TABLE IF EXISTS `gw_route_predicate`;
CREATE TABLE `gw_route_predicate` (
  `id` bigint(25) NOT NULL,
  `route_id` bigint(25) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `args` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `route_id` (`route_id`) USING BTREE,
  CONSTRAINT `gw_route_predicate_ibfk_1` FOREIGN KEY (`route_id`) REFERENCES `gw_route` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='gateway的route的条件表';

-- ----------------------------
-- Table structure for gw_upstream
-- ----------------------------
DROP TABLE IF EXISTS `gw_upstream`;
CREATE TABLE `gw_upstream` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `uri` varchar(255) COLLATE utf8_bin NOT NULL,
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='gateway的route转发目标服务';

-- ----------------------------
-- Table structure for gw_upstream_group
-- ----------------------------
DROP TABLE IF EXISTS `gw_upstream_group`;
CREATE TABLE `gw_upstream_group` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin NOT NULL,
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='gateway的upsterm的分组表';

-- ----------------------------
-- Table structure for gw_upstream_group_ref
-- ----------------------------
DROP TABLE IF EXISTS `gw_upstream_group_ref`;
CREATE TABLE `gw_upstream_group_ref` (
  `id` bigint(25) NOT NULL,
  `upstream_id` bigint(25) NOT NULL,
  `upstream_group_id` bigint(25) NOT NULL,
  `weight` int(11) DEFAULT NULL COMMENT '权重',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `upstream_id` (`upstream_id`) USING BTREE,
  KEY `upstream_group_id` (`upstream_group_id`) USING BTREE,
  CONSTRAINT `gw_upstream_group_ref_ibfk_1` FOREIGN KEY (`upstream_id`) REFERENCES `gw_upstream` (`id`),
  CONSTRAINT `gw_upstream_group_ref_ibfk_2` FOREIGN KEY (`upstream_group_id`) REFERENCES `gw_upstream_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='gateway的group与upstream的关联表';

-- ----------------------------
-- Table structure for sys_area
-- ----------------------------
DROP TABLE IF EXISTS `sys_area`;
CREATE TABLE `sys_area` (
  `id` bigint(25) NOT NULL,
  `parent_id` bigint(25) NOT NULL DEFAULT '0' COMMENT '父级ID',
  `name` varchar(50) NOT NULL COMMENT '名称',
  `short_name` varchar(50) NOT NULL COMMENT '简称',
  `longitude` float NOT NULL DEFAULT '0' COMMENT '经度',
  `latitude` float NOT NULL DEFAULT '0' COMMENT '纬度',
  `level` int(1) NOT NULL COMMENT '等级(1省/直辖市,2地级市,3区县,4镇/街道)',
  `sort` int(3) NOT NULL DEFAULT '1' COMMENT '排序',
  `status` int(1) NOT NULL DEFAULT '0' COMMENT '状态(0禁用/1启用)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_area
-- ----------------------------
BEGIN;
INSERT INTO `sys_area` VALUES (0, -1, '中国', '中国', 116.405, 39.905, 0, 1, 1);
INSERT INTO `sys_area` VALUES (1, -1, '美国', '美国', 116.405, 39.905, 0, 1, 1);
INSERT INTO `sys_area` VALUES (2, -1, '俄罗斯', '俄罗斯', 116.405, 39.905, 0, 1, 1);
INSERT INTO `sys_area` VALUES (3, -1, '英国', '英国', 116.405, 39.905, 0, 1, 1);
INSERT INTO `sys_area` VALUES (4, -1, '日本', '日本', 116.405, 39.905, 0, 1, 1);
INSERT INTO `sys_area` VALUES (5, -1, '德国', '德国', 116.405, 39.905, 0, 1, 1);
INSERT INTO `sys_area` VALUES (110000, 0, '北京', '北京', 116.405, 39.905, 1, 1, 1);
INSERT INTO `sys_area` VALUES (110100, 110000, '北京市', '北京', 116.405, 39.905, 2, 1, 1);
INSERT INTO `sys_area` VALUES (120000, 0, '天津', '天津', 117.19, 39.1256, 1, 2, 1);
INSERT INTO `sys_area` VALUES (120100, 120000, '天津市', '天津', 117.19, 39.1256, 2, 1, 1);
INSERT INTO `sys_area` VALUES (130000, 0, '河北省', '河北', 114.502, 38.0455, 1, 3, 1);
INSERT INTO `sys_area` VALUES (130100, 130000, '石家庄市', '石家庄', 114.502, 38.0455, 2, 8, 1);
INSERT INTO `sys_area` VALUES (130200, 130000, '唐山市', '唐山', 118.175, 39.6351, 2, 9, 1);
INSERT INTO `sys_area` VALUES (130300, 130000, '秦皇岛市', '秦皇岛', 119.587, 39.9425, 2, 7, 1);
INSERT INTO `sys_area` VALUES (130400, 130000, '邯郸市', '邯郸', 114.491, 36.6123, 2, 4, 1);
INSERT INTO `sys_area` VALUES (130500, 130000, '邢台市', '邢台', 114.509, 37.0682, 2, 10, 1);
INSERT INTO `sys_area` VALUES (130600, 130000, '保定市', '保定', 115.482, 38.8677, 2, 1, 1);
INSERT INTO `sys_area` VALUES (130700, 130000, '张家口市', '张家口', 114.884, 40.8119, 2, 11, 1);
INSERT INTO `sys_area` VALUES (130800, 130000, '承德市', '承德', 117.939, 40.9762, 2, 3, 1);
INSERT INTO `sys_area` VALUES (130900, 130000, '沧州市', '沧州', 116.857, 38.3106, 2, 2, 1);
INSERT INTO `sys_area` VALUES (131000, 130000, '廊坊市', '廊坊', 116.704, 39.5239, 2, 6, 1);
INSERT INTO `sys_area` VALUES (131100, 130000, '衡水市', '衡水', 115.666, 37.7351, 2, 5, 1);
INSERT INTO `sys_area` VALUES (140000, 0, '山西省', '山西', 112.549, 37.857, 1, 4, 1);
INSERT INTO `sys_area` VALUES (140100, 140000, '太原市', '太原', 112.549, 37.857, 2, 8, 1);
INSERT INTO `sys_area` VALUES (140200, 140000, '大同市', '大同', 113.295, 40.0903, 2, 2, 1);
INSERT INTO `sys_area` VALUES (140300, 140000, '阳泉市', '阳泉', 113.583, 37.8612, 2, 10, 1);
INSERT INTO `sys_area` VALUES (140400, 140000, '长治市', '长治', 113.114, 36.1911, 2, 1, 1);
INSERT INTO `sys_area` VALUES (140500, 140000, '晋城市', '晋城', 112.851, 35.4976, 2, 3, 1);
INSERT INTO `sys_area` VALUES (140600, 140000, '朔州市', '朔州', 112.433, 39.3313, 2, 7, 1);
INSERT INTO `sys_area` VALUES (140700, 140000, '晋中市', '晋中', 112.736, 37.6965, 2, 4, 1);
INSERT INTO `sys_area` VALUES (140800, 140000, '运城市', '运城', 111.004, 35.0228, 2, 11, 1);
INSERT INTO `sys_area` VALUES (140900, 140000, '忻州市', '忻州', 112.734, 38.4177, 2, 9, 1);
INSERT INTO `sys_area` VALUES (141000, 140000, '临汾市', '临汾', 111.518, 36.0841, 2, 5, 1);
INSERT INTO `sys_area` VALUES (141100, 140000, '吕梁市', '吕梁', 111.134, 37.5244, 2, 6, 1);
INSERT INTO `sys_area` VALUES (150000, 0, '内蒙古自治区', '内蒙古', 111.671, 40.8183, 1, 5, 1);
INSERT INTO `sys_area` VALUES (150100, 150000, '呼和浩特市', '呼和浩特', 111.671, 40.8183, 2, 6, 1);
INSERT INTO `sys_area` VALUES (150200, 150000, '包头市', '包头', 109.84, 40.6582, 2, 2, 1);
INSERT INTO `sys_area` VALUES (150300, 150000, '乌海市', '乌海', 106.826, 39.6737, 2, 9, 1);
INSERT INTO `sys_area` VALUES (150400, 150000, '赤峰市', '赤峰', 118.957, 42.2753, 2, 4, 1);
INSERT INTO `sys_area` VALUES (150500, 150000, '通辽市', '通辽', 122.263, 43.6174, 2, 8, 1);
INSERT INTO `sys_area` VALUES (150600, 150000, '鄂尔多斯市', '鄂尔多斯', 109.99, 39.8172, 2, 5, 1);
INSERT INTO `sys_area` VALUES (150700, 150000, '呼伦贝尔市', '呼伦贝尔', 119.758, 49.2153, 2, 7, 1);
INSERT INTO `sys_area` VALUES (150800, 150000, '巴彦淖尔市', '巴彦淖尔', 107.417, 40.7574, 2, 3, 1);
INSERT INTO `sys_area` VALUES (150900, 150000, '乌兰察布市', '乌兰察布', 113.115, 41.0341, 2, 10, 1);
INSERT INTO `sys_area` VALUES (152200, 150000, '兴安盟', '兴安', 122.07, 46.0763, 2, 12, 1);
INSERT INTO `sys_area` VALUES (152500, 150000, '锡林郭勒盟', '锡林郭勒', 116.091, 43.944, 2, 11, 1);
INSERT INTO `sys_area` VALUES (152900, 150000, '阿拉善盟', '阿拉善', 105.706, 38.8448, 2, 1, 1);
INSERT INTO `sys_area` VALUES (210000, 0, '辽宁省', '辽宁', 123.429, 41.7968, 1, 6, 1);
INSERT INTO `sys_area` VALUES (210100, 210000, '沈阳市', '沈阳', 123.429, 41.7968, 2, 12, 1);
INSERT INTO `sys_area` VALUES (210200, 210000, '大连市', '大连', 121.619, 38.9146, 2, 4, 1);
INSERT INTO `sys_area` VALUES (210300, 210000, '鞍山市', '鞍山', 122.996, 41.1106, 2, 1, 1);
INSERT INTO `sys_area` VALUES (210400, 210000, '抚顺市', '抚顺', 123.921, 41.876, 2, 6, 1);
INSERT INTO `sys_area` VALUES (210500, 210000, '本溪市', '本溪', 123.771, 41.2979, 2, 2, 1);
INSERT INTO `sys_area` VALUES (210600, 210000, '丹东市', '丹东', 124.383, 40.1243, 2, 5, 1);
INSERT INTO `sys_area` VALUES (210700, 210000, '锦州市', '锦州', 121.136, 41.1193, 2, 9, 1);
INSERT INTO `sys_area` VALUES (210800, 210000, '营口市', '营口', 122.235, 40.6674, 2, 14, 1);
INSERT INTO `sys_area` VALUES (210900, 210000, '阜新市', '阜新', 121.649, 42.0118, 2, 7, 1);
INSERT INTO `sys_area` VALUES (211000, 210000, '辽阳市', '辽阳', 123.182, 41.2694, 2, 10, 1);
INSERT INTO `sys_area` VALUES (211100, 210000, '盘锦市', '盘锦', 122.07, 41.1245, 2, 11, 1);
INSERT INTO `sys_area` VALUES (211200, 210000, '铁岭市', '铁岭', 123.844, 42.2906, 2, 13, 1);
INSERT INTO `sys_area` VALUES (211300, 210000, '朝阳市', '朝阳', 120.451, 41.5768, 2, 3, 1);
INSERT INTO `sys_area` VALUES (211400, 210000, '葫芦岛市', '葫芦岛', 120.856, 40.7556, 2, 8, 1);
INSERT INTO `sys_area` VALUES (220000, 0, '吉林省', '吉林', 125.325, 43.8868, 1, 7, 1);
INSERT INTO `sys_area` VALUES (220100, 220000, '长春市', '长春', 125.325, 43.8868, 2, 3, 1);
INSERT INTO `sys_area` VALUES (220200, 220000, '吉林市', '吉林', 126.553, 43.8436, 2, 4, 1);
INSERT INTO `sys_area` VALUES (220300, 220000, '四平市', '四平', 124.371, 43.1703, 2, 6, 1);
INSERT INTO `sys_area` VALUES (220400, 220000, '辽源市', '辽源', 125.145, 42.9027, 2, 5, 1);
INSERT INTO `sys_area` VALUES (220500, 220000, '通化市', '通化', 125.937, 41.7212, 2, 8, 1);
INSERT INTO `sys_area` VALUES (220600, 220000, '白山市', '白山', 126.428, 41.9425, 2, 2, 1);
INSERT INTO `sys_area` VALUES (220700, 220000, '松原市', '松原', 124.824, 45.1182, 2, 7, 1);
INSERT INTO `sys_area` VALUES (220800, 220000, '白城市', '白城', 122.841, 45.619, 2, 1, 1);
INSERT INTO `sys_area` VALUES (222400, 220000, '延边朝鲜族自治州', '延边朝鲜族', 129.513, 42.9048, 2, 9, 1);
INSERT INTO `sys_area` VALUES (230000, 0, '黑龙江省', '黑龙江', 126.642, 45.757, 1, 8, 1);
INSERT INTO `sys_area` VALUES (230100, 230000, '哈尔滨市', '哈尔滨', 126.642, 45.757, 2, 3, 1);
INSERT INTO `sys_area` VALUES (230200, 230000, '齐齐哈尔市', '齐齐哈尔', 123.958, 47.3421, 2, 9, 1);
INSERT INTO `sys_area` VALUES (230300, 230000, '鸡西市', '鸡西', 130.976, 45.3, 2, 7, 1);
INSERT INTO `sys_area` VALUES (230400, 230000, '鹤岗市', '鹤岗', 130.277, 47.3321, 2, 4, 1);
INSERT INTO `sys_area` VALUES (230500, 230000, '双鸭山市', '双鸭山', 131.157, 46.6434, 2, 11, 1);
INSERT INTO `sys_area` VALUES (230600, 230000, '大庆市', '大庆', 125.113, 46.5907, 2, 1, 1);
INSERT INTO `sys_area` VALUES (230700, 230000, '伊春市', '伊春', 128.899, 47.7248, 2, 13, 1);
INSERT INTO `sys_area` VALUES (230800, 230000, '佳木斯市', '佳木斯', 130.362, 46.8096, 2, 6, 1);
INSERT INTO `sys_area` VALUES (230900, 230000, '七台河市', '七台河', 131.016, 45.7713, 2, 10, 1);
INSERT INTO `sys_area` VALUES (231000, 230000, '牡丹江市', '牡丹江', 129.619, 44.583, 2, 8, 1);
INSERT INTO `sys_area` VALUES (231100, 230000, '黑河市', '黑河', 127.499, 50.2496, 2, 5, 1);
INSERT INTO `sys_area` VALUES (231200, 230000, '绥化市', '绥化', 126.993, 46.6374, 2, 12, 1);
INSERT INTO `sys_area` VALUES (232700, 230000, '大兴安岭地区', '大兴安岭', 124.712, 52.3353, 2, 2, 1);
INSERT INTO `sys_area` VALUES (310000, 0, '上海', '上海', 121.473, 31.2317, 1, 9, 1);
INSERT INTO `sys_area` VALUES (310100, 310000, '上海市', '上海', 121.473, 31.2317, 2, 1, 1);
INSERT INTO `sys_area` VALUES (320000, 0, '江苏省', '江苏', 118.767, 32.0415, 1, 10, 1);
INSERT INTO `sys_area` VALUES (320100, 320000, '南京市', '南京', 118.767, 32.0415, 2, 4, 1);
INSERT INTO `sys_area` VALUES (320200, 320000, '无锡市', '无锡', 120.302, 31.5747, 2, 9, 1);
INSERT INTO `sys_area` VALUES (320300, 320000, '徐州市', '徐州', 117.185, 34.2618, 2, 10, 1);
INSERT INTO `sys_area` VALUES (320400, 320000, '常州市', '常州', 119.947, 31.7728, 2, 1, 1);
INSERT INTO `sys_area` VALUES (320500, 320000, '苏州市', '苏州', 120.62, 31.2994, 2, 7, 1);
INSERT INTO `sys_area` VALUES (320600, 320000, '南通市', '南通', 120.865, 32.0162, 2, 5, 1);
INSERT INTO `sys_area` VALUES (320700, 320000, '连云港市', '连云港', 119.179, 34.6, 2, 3, 1);
INSERT INTO `sys_area` VALUES (320800, 320000, '淮安市', '淮安', 119.021, 33.5975, 2, 2, 1);
INSERT INTO `sys_area` VALUES (320900, 320000, '盐城市', '盐城', 120.14, 33.3776, 2, 11, 1);
INSERT INTO `sys_area` VALUES (321000, 320000, '扬州市', '扬州', 119.421, 32.3932, 2, 12, 1);
INSERT INTO `sys_area` VALUES (321100, 320000, '镇江市', '镇江', 119.453, 32.2044, 2, 13, 1);
INSERT INTO `sys_area` VALUES (321200, 320000, '泰州市', '泰州', 119.915, 32.4849, 2, 8, 1);
INSERT INTO `sys_area` VALUES (321300, 320000, '宿迁市', '宿迁', 118.275, 33.963, 2, 6, 1);
INSERT INTO `sys_area` VALUES (330000, 0, '浙江省', '浙江', 120.154, 30.2875, 1, 11, 1);
INSERT INTO `sys_area` VALUES (330100, 330000, '杭州市', '杭州', 120.154, 30.2875, 2, 1, 1);
INSERT INTO `sys_area` VALUES (330200, 330000, '宁波市', '宁波', 121.55, 29.8684, 2, 6, 1);
INSERT INTO `sys_area` VALUES (330300, 330000, '温州市', '温州', 120.672, 28.0006, 2, 10, 1);
INSERT INTO `sys_area` VALUES (330400, 330000, '嘉兴市', '嘉兴', 120.751, 30.7627, 2, 3, 1);
INSERT INTO `sys_area` VALUES (330500, 330000, '湖州市', '湖州', 120.102, 30.8672, 2, 2, 1);
INSERT INTO `sys_area` VALUES (330600, 330000, '绍兴市', '绍兴', 120.582, 29.9971, 2, 8, 1);
INSERT INTO `sys_area` VALUES (330700, 330000, '金华市', '金华', 119.65, 29.0895, 2, 4, 1);
INSERT INTO `sys_area` VALUES (330800, 330000, '衢州市', '衢州', 118.873, 28.9417, 2, 7, 1);
INSERT INTO `sys_area` VALUES (330900, 330000, '舟山市', '舟山', 122.107, 30.016, 2, 11, 1);
INSERT INTO `sys_area` VALUES (331000, 330000, '台州市', '台州', 121.429, 28.6614, 2, 9, 1);
INSERT INTO `sys_area` VALUES (331100, 330000, '丽水市', '丽水', 119.922, 28.452, 2, 5, 1);
INSERT INTO `sys_area` VALUES (340000, 0, '安徽省', '安徽', 117.283, 31.8612, 1, 12, 1);
INSERT INTO `sys_area` VALUES (340100, 340000, '合肥市', '合肥', 117.283, 31.8612, 2, 7, 1);
INSERT INTO `sys_area` VALUES (340200, 340000, '芜湖市', '芜湖', 118.376, 31.3263, 2, 15, 1);
INSERT INTO `sys_area` VALUES (340300, 340000, '蚌埠市', '蚌埠', 117.363, 32.9397, 2, 2, 1);
INSERT INTO `sys_area` VALUES (340400, 340000, '淮南市', '淮南', 117.018, 32.6476, 2, 9, 1);
INSERT INTO `sys_area` VALUES (340500, 340000, '马鞍山市', '马鞍山', 118.508, 31.6894, 2, 12, 1);
INSERT INTO `sys_area` VALUES (340600, 340000, '淮北市', '淮北', 116.795, 33.9717, 2, 8, 1);
INSERT INTO `sys_area` VALUES (340700, 340000, '铜陵市', '铜陵', 117.817, 30.9299, 2, 14, 1);
INSERT INTO `sys_area` VALUES (340800, 340000, '安庆市', '安庆', 117.044, 30.5088, 2, 1, 1);
INSERT INTO `sys_area` VALUES (341000, 340000, '黄山市', '黄山', 118.317, 29.7092, 2, 10, 1);
INSERT INTO `sys_area` VALUES (341100, 340000, '滁州市', '滁州', 118.316, 32.3036, 2, 5, 1);
INSERT INTO `sys_area` VALUES (341200, 340000, '阜阳市', '阜阳', 115.82, 32.897, 2, 6, 1);
INSERT INTO `sys_area` VALUES (341300, 340000, '宿州市', '宿州', 116.984, 33.6339, 2, 13, 1);
INSERT INTO `sys_area` VALUES (341500, 340000, '六安市', '六安', 116.508, 31.7529, 2, 11, 1);
INSERT INTO `sys_area` VALUES (341600, 340000, '亳州市', '亳州', 115.783, 33.8693, 2, 3, 1);
INSERT INTO `sys_area` VALUES (341700, 340000, '池州市', '池州', 117.489, 30.656, 2, 4, 1);
INSERT INTO `sys_area` VALUES (341800, 340000, '宣城市', '宣城', 118.758, 30.9457, 2, 16, 1);
INSERT INTO `sys_area` VALUES (350000, 0, '福建省', '福建', 119.306, 26.0753, 1, 13, 1);
INSERT INTO `sys_area` VALUES (350100, 350000, '福州市', '福州', 119.306, 26.0753, 2, 1, 1);
INSERT INTO `sys_area` VALUES (350200, 350000, '厦门市', '厦门', 118.11, 24.4905, 2, 8, 1);
INSERT INTO `sys_area` VALUES (350300, 350000, '莆田市', '莆田', 119.008, 25.431, 2, 5, 1);
INSERT INTO `sys_area` VALUES (350400, 350000, '三明市', '三明', 117.635, 26.2654, 2, 7, 1);
INSERT INTO `sys_area` VALUES (350500, 350000, '泉州市', '泉州', 118.589, 24.9089, 2, 6, 1);
INSERT INTO `sys_area` VALUES (350600, 350000, '漳州市', '漳州', 117.662, 24.5109, 2, 9, 1);
INSERT INTO `sys_area` VALUES (350700, 350000, '南平市', '南平', 118.178, 26.6356, 2, 3, 1);
INSERT INTO `sys_area` VALUES (350800, 350000, '龙岩市', '龙岩', 117.03, 25.0916, 2, 2, 1);
INSERT INTO `sys_area` VALUES (350900, 350000, '宁德市', '宁德', 119.527, 26.6592, 2, 4, 1);
INSERT INTO `sys_area` VALUES (360000, 0, '江西省', '江西', 115.892, 28.6765, 1, 14, 1);
INSERT INTO `sys_area` VALUES (360100, 360000, '南昌市', '南昌', 115.892, 28.6765, 2, 6, 1);
INSERT INTO `sys_area` VALUES (360200, 360000, '景德镇市', '景德镇', 117.215, 29.2926, 2, 4, 1);
INSERT INTO `sys_area` VALUES (360300, 360000, '萍乡市', '萍乡', 113.852, 27.6229, 2, 7, 1);
INSERT INTO `sys_area` VALUES (360400, 360000, '九江市', '九江', 115.993, 29.712, 2, 5, 1);
INSERT INTO `sys_area` VALUES (360500, 360000, '新余市', '新余', 114.931, 27.8108, 2, 9, 1);
INSERT INTO `sys_area` VALUES (360600, 360000, '鹰潭市', '鹰潭', 117.034, 28.2386, 2, 11, 1);
INSERT INTO `sys_area` VALUES (360700, 360000, '赣州市', '赣州', 114.94, 25.851, 2, 2, 1);
INSERT INTO `sys_area` VALUES (360800, 360000, '吉安市', '吉安', 114.986, 27.1117, 2, 3, 1);
INSERT INTO `sys_area` VALUES (360900, 360000, '宜春市', '宜春', 114.391, 27.8043, 2, 10, 1);
INSERT INTO `sys_area` VALUES (361000, 360000, '抚州市', '抚州', 116.358, 27.9839, 2, 1, 1);
INSERT INTO `sys_area` VALUES (361100, 360000, '上饶市', '上饶', 117.971, 28.4444, 2, 8, 1);
INSERT INTO `sys_area` VALUES (370000, 0, '山东省', '山东', 117.001, 36.6758, 1, 15, 1);
INSERT INTO `sys_area` VALUES (370100, 370000, '济南市', '济南', 117.001, 36.6758, 2, 5, 1);
INSERT INTO `sys_area` VALUES (370200, 370000, '青岛市', '青岛', 120.355, 36.083, 2, 10, 1);
INSERT INTO `sys_area` VALUES (370300, 370000, '淄博市', '淄博', 118.048, 36.8149, 2, 17, 1);
INSERT INTO `sys_area` VALUES (370400, 370000, '枣庄市', '枣庄', 117.558, 34.8564, 2, 16, 1);
INSERT INTO `sys_area` VALUES (370500, 370000, '东营市', '东营', 118.665, 37.4346, 2, 3, 1);
INSERT INTO `sys_area` VALUES (370600, 370000, '烟台市', '烟台', 121.391, 37.5393, 2, 15, 1);
INSERT INTO `sys_area` VALUES (370700, 370000, '潍坊市', '潍坊', 119.107, 36.7093, 2, 13, 1);
INSERT INTO `sys_area` VALUES (370800, 370000, '济宁市', '济宁', 116.587, 35.4154, 2, 6, 1);
INSERT INTO `sys_area` VALUES (370900, 370000, '泰安市', '泰安', 117.129, 36.195, 2, 12, 1);
INSERT INTO `sys_area` VALUES (371000, 370000, '威海市', '威海', 122.116, 37.5097, 2, 14, 1);
INSERT INTO `sys_area` VALUES (371100, 370000, '日照市', '日照', 119.461, 35.4286, 2, 11, 1);
INSERT INTO `sys_area` VALUES (371200, 370000, '莱芜市', '莱芜', 117.678, 36.2144, 2, 7, 1);
INSERT INTO `sys_area` VALUES (371300, 370000, '临沂市', '临沂', 118.326, 35.0653, 2, 9, 1);
INSERT INTO `sys_area` VALUES (371400, 370000, '德州市', '德州', 116.307, 37.454, 2, 2, 1);
INSERT INTO `sys_area` VALUES (371500, 370000, '聊城市', '聊城', 115.98, 36.456, 2, 8, 1);
INSERT INTO `sys_area` VALUES (371600, 370000, '滨州市', '滨州', 118.017, 37.3835, 2, 1, 1);
INSERT INTO `sys_area` VALUES (371700, 370000, '菏泽市', '菏泽', 115.469, 35.2465, 2, 4, 1);
INSERT INTO `sys_area` VALUES (410000, 0, '河南省', '河南', 113.665, 34.758, 1, 16, 1);
INSERT INTO `sys_area` VALUES (410100, 410000, '郑州市', '郑州', 113.665, 34.758, 2, 16, 1);
INSERT INTO `sys_area` VALUES (410200, 410000, '开封市', '开封', 114.341, 34.7971, 2, 5, 1);
INSERT INTO `sys_area` VALUES (410300, 410000, '洛阳市', '洛阳', 112.434, 34.663, 2, 7, 1);
INSERT INTO `sys_area` VALUES (410400, 410000, '平顶山市', '平顶山', 113.308, 33.7352, 2, 9, 1);
INSERT INTO `sys_area` VALUES (410500, 410000, '安阳市', '安阳', 114.352, 36.1034, 2, 1, 1);
INSERT INTO `sys_area` VALUES (410600, 410000, '鹤壁市', '鹤壁', 114.295, 35.7482, 2, 2, 1);
INSERT INTO `sys_area` VALUES (410700, 410000, '新乡市', '新乡', 113.884, 35.3026, 2, 14, 1);
INSERT INTO `sys_area` VALUES (410800, 410000, '焦作市', '焦作', 113.238, 35.239, 2, 3, 1);
INSERT INTO `sys_area` VALUES (410881, 410000, '济源市', '济源', 112.59, 35.0904, 2, 4, 1);
INSERT INTO `sys_area` VALUES (410900, 410000, '濮阳市', '濮阳', 115.041, 35.7682, 2, 10, 1);
INSERT INTO `sys_area` VALUES (411000, 410000, '许昌市', '许昌', 113.826, 34.023, 2, 15, 1);
INSERT INTO `sys_area` VALUES (411100, 410000, '漯河市', '漯河', 114.026, 33.5759, 2, 6, 1);
INSERT INTO `sys_area` VALUES (411200, 410000, '三门峡市', '三门峡', 111.194, 34.7773, 2, 11, 1);
INSERT INTO `sys_area` VALUES (411300, 410000, '南阳市', '南阳', 112.541, 32.9991, 2, 8, 1);
INSERT INTO `sys_area` VALUES (411400, 410000, '商丘市', '商丘', 115.65, 34.4371, 2, 12, 1);
INSERT INTO `sys_area` VALUES (411500, 410000, '信阳市', '信阳', 114.075, 32.1233, 2, 13, 1);
INSERT INTO `sys_area` VALUES (411600, 410000, '周口市', '周口', 114.65, 33.6204, 2, 17, 1);
INSERT INTO `sys_area` VALUES (411700, 410000, '驻马店市', '驻马店', 114.025, 32.9802, 2, 18, 1);
INSERT INTO `sys_area` VALUES (420000, 0, '湖北省', '湖北', 114.299, 30.5844, 1, 17, 1);
INSERT INTO `sys_area` VALUES (420100, 420000, '武汉市', '武汉', 114.299, 30.5844, 2, 12, 1);
INSERT INTO `sys_area` VALUES (420200, 420000, '黄石市', '黄石', 115.077, 30.2201, 2, 4, 1);
INSERT INTO `sys_area` VALUES (420300, 420000, '十堰市', '十堰', 110.788, 32.6469, 2, 9, 1);
INSERT INTO `sys_area` VALUES (420500, 420000, '宜昌市', '宜昌', 111.291, 30.7026, 2, 17, 1);
INSERT INTO `sys_area` VALUES (420600, 420000, '襄阳市', '襄阳', 112.144, 32.0424, 2, 13, 1);
INSERT INTO `sys_area` VALUES (420700, 420000, '鄂州市', '鄂州', 114.891, 30.3965, 2, 2, 1);
INSERT INTO `sys_area` VALUES (420800, 420000, '荆门市', '荆门', 112.204, 31.0354, 2, 5, 1);
INSERT INTO `sys_area` VALUES (420900, 420000, '孝感市', '孝感', 113.927, 30.9264, 2, 16, 1);
INSERT INTO `sys_area` VALUES (421000, 420000, '荆州市', '荆州', 112.238, 30.3269, 2, 6, 1);
INSERT INTO `sys_area` VALUES (421100, 420000, '黄冈市', '黄冈', 114.879, 30.4477, 2, 3, 1);
INSERT INTO `sys_area` VALUES (421200, 420000, '咸宁市', '咸宁', 114.329, 29.8328, 2, 14, 1);
INSERT INTO `sys_area` VALUES (421300, 420000, '随州市', '随州', 113.374, 31.7175, 2, 10, 1);
INSERT INTO `sys_area` VALUES (422800, 420000, '恩施土家族苗族自治州', '恩施', 109.487, 30.2831, 2, 1, 1);
INSERT INTO `sys_area` VALUES (429004, 420000, '仙桃市', '仙桃', 113.454, 30.365, 2, 15, 1);
INSERT INTO `sys_area` VALUES (429005, 420000, '潜江市', '潜江', 112.897, 30.4212, 2, 7, 1);
INSERT INTO `sys_area` VALUES (429006, 420000, '天门市', '天门', 113.166, 30.6531, 2, 11, 1);
INSERT INTO `sys_area` VALUES (429021, 420000, '神农架林区', '神农架', 114.299, 30.5844, 2, 8, 1);
INSERT INTO `sys_area` VALUES (430000, 0, '湖南省', '湖南', 112.982, 28.1941, 1, 18, 1);
INSERT INTO `sys_area` VALUES (430100, 430000, '长沙市', '长沙', 112.982, 28.1941, 2, 2, 1);
INSERT INTO `sys_area` VALUES (430200, 430000, '株洲市', '株洲', 113.152, 27.8358, 2, 14, 1);
INSERT INTO `sys_area` VALUES (430300, 430000, '湘潭市', '湘潭', 112.944, 27.8297, 2, 8, 1);
INSERT INTO `sys_area` VALUES (430400, 430000, '衡阳市', '衡阳', 112.608, 26.9004, 2, 4, 1);
INSERT INTO `sys_area` VALUES (430500, 430000, '邵阳市', '邵阳', 111.469, 27.2378, 2, 7, 1);
INSERT INTO `sys_area` VALUES (430600, 430000, '岳阳市', '岳阳', 113.133, 29.3703, 2, 12, 1);
INSERT INTO `sys_area` VALUES (430700, 430000, '常德市', '常德', 111.691, 29.0402, 2, 1, 1);
INSERT INTO `sys_area` VALUES (430800, 430000, '张家界市', '张家界', 110.48, 29.1274, 2, 13, 1);
INSERT INTO `sys_area` VALUES (430900, 430000, '益阳市', '益阳', 112.355, 28.5701, 2, 10, 1);
INSERT INTO `sys_area` VALUES (431000, 430000, '郴州市', '郴州', 113.032, 25.7936, 2, 3, 1);
INSERT INTO `sys_area` VALUES (431100, 430000, '永州市', '永州', 111.608, 26.4345, 2, 11, 1);
INSERT INTO `sys_area` VALUES (431200, 430000, '怀化市', '怀化', 109.978, 27.5501, 2, 5, 1);
INSERT INTO `sys_area` VALUES (431300, 430000, '娄底市', '娄底', 112.008, 27.7281, 2, 6, 1);
INSERT INTO `sys_area` VALUES (433100, 430000, '湘西土家族苗族自治州', '湘西', 109.74, 28.3143, 2, 9, 1);
INSERT INTO `sys_area` VALUES (440000, 0, '广东省', '广东', 113.325, 23.1506, 1, 19, 1);
INSERT INTO `sys_area` VALUES (440100, 440000, '广州市', '广州', 113.281, 23.1252, 2, 2, 1);
INSERT INTO `sys_area` VALUES (440200, 440000, '韶关市', '韶关', 113.592, 24.8013, 2, 15, 1);
INSERT INTO `sys_area` VALUES (440300, 440000, '深圳市', '深圳', 114.086, 22.547, 2, 1, 1);
INSERT INTO `sys_area` VALUES (440400, 440000, '珠海市', '珠海', 113.554, 22.225, 2, 3, 1);
INSERT INTO `sys_area` VALUES (440500, 440000, '汕头市', '汕头', 116.708, 23.371, 2, 13, 1);
INSERT INTO `sys_area` VALUES (440600, 440000, '佛山市', '佛山', 113.123, 23.0288, 2, 5, 1);
INSERT INTO `sys_area` VALUES (440700, 440000, '江门市', '江门', 113.095, 22.5904, 2, 8, 1);
INSERT INTO `sys_area` VALUES (440800, 440000, '湛江市', '湛江', 110.365, 21.2749, 2, 19, 1);
INSERT INTO `sys_area` VALUES (440900, 440000, '茂名市', '茂名', 110.919, 21.6598, 2, 10, 1);
INSERT INTO `sys_area` VALUES (441200, 440000, '肇庆市', '肇庆', 112.473, 23.0515, 2, 20, 1);
INSERT INTO `sys_area` VALUES (441300, 440000, '惠州市', '惠州', 114.413, 23.0794, 2, 7, 1);
INSERT INTO `sys_area` VALUES (441400, 440000, '梅州市', '梅州', 116.118, 24.2991, 2, 11, 1);
INSERT INTO `sys_area` VALUES (441500, 440000, '汕尾市', '汕尾', 115.364, 22.7745, 2, 14, 1);
INSERT INTO `sys_area` VALUES (441600, 440000, '河源市', '河源', 114.698, 23.7463, 2, 6, 1);
INSERT INTO `sys_area` VALUES (441700, 440000, '阳江市', '阳江', 111.975, 21.8592, 2, 17, 1);
INSERT INTO `sys_area` VALUES (441800, 440000, '清远市', '清远', 113.051, 23.685, 2, 12, 1);
INSERT INTO `sys_area` VALUES (441900, 440000, '东莞市', '东莞', 113.746, 23.0462, 2, 4, 1);
INSERT INTO `sys_area` VALUES (442000, 440000, '中山市', '中山', 113.382, 22.5211, 2, 21, 1);
INSERT INTO `sys_area` VALUES (445100, 440000, '潮州市', '潮州', 116.632, 23.6617, 2, 16, 1);
INSERT INTO `sys_area` VALUES (445200, 440000, '揭阳市', '揭阳', 116.356, 23.5438, 2, 9, 1);
INSERT INTO `sys_area` VALUES (445300, 440000, '云浮市', '云浮', 112.044, 22.9298, 2, 18, 1);
INSERT INTO `sys_area` VALUES (450000, 0, '广西壮族自治区', '广西', 108.32, 22.824, 1, 20, 1);
INSERT INTO `sys_area` VALUES (450100, 450000, '南宁市', '南宁', 108.32, 22.824, 2, 11, 1);
INSERT INTO `sys_area` VALUES (450200, 450000, '柳州市', '柳州', 109.412, 24.3146, 2, 10, 1);
INSERT INTO `sys_area` VALUES (450300, 450000, '桂林市', '桂林', 110.299, 25.2742, 2, 6, 1);
INSERT INTO `sys_area` VALUES (450400, 450000, '梧州市', '梧州', 111.298, 23.4748, 2, 13, 1);
INSERT INTO `sys_area` VALUES (450500, 450000, '北海市', '北海', 109.119, 21.4733, 2, 1, 1);
INSERT INTO `sys_area` VALUES (450600, 450000, '防城港市', '防城港', 108.345, 21.6146, 2, 4, 1);
INSERT INTO `sys_area` VALUES (450700, 450000, '钦州市', '钦州', 108.624, 21.9671, 2, 12, 1);
INSERT INTO `sys_area` VALUES (450800, 450000, '贵港市', '贵港', 109.602, 23.0936, 2, 5, 1);
INSERT INTO `sys_area` VALUES (450900, 450000, '玉林市', '玉林', 110.154, 22.6314, 2, 14, 1);
INSERT INTO `sys_area` VALUES (451000, 450000, '百色市', '百色', 106.616, 23.8977, 2, 2, 1);
INSERT INTO `sys_area` VALUES (451100, 450000, '贺州市', '贺州', 111.552, 24.4141, 2, 8, 1);
INSERT INTO `sys_area` VALUES (451200, 450000, '河池市', '河池', 108.062, 24.6959, 2, 7, 1);
INSERT INTO `sys_area` VALUES (451300, 450000, '来宾市', '来宾', 109.23, 23.7338, 2, 9, 1);
INSERT INTO `sys_area` VALUES (451400, 450000, '崇左市', '崇左', 107.354, 22.4041, 2, 3, 1);
INSERT INTO `sys_area` VALUES (460000, 0, '海南省', '海南', 110.331, 20.032, 1, 21, 1);
INSERT INTO `sys_area` VALUES (460100, 460000, '海口市', '海口', 110.331, 20.032, 2, 8, 1);
INSERT INTO `sys_area` VALUES (460200, 460000, '三亚市', '三亚', 109.508, 18.2479, 2, 15, 1);
INSERT INTO `sys_area` VALUES (460300, 460000, '三沙市', '三沙', 112.349, 16.831, 2, 14, 1);
INSERT INTO `sys_area` VALUES (469001, 460000, '五指山市', '五指山', 109.517, 18.7769, 2, 19, 1);
INSERT INTO `sys_area` VALUES (469002, 460000, '琼海市', '琼海', 110.467, 19.246, 2, 12, 1);
INSERT INTO `sys_area` VALUES (469003, 460000, '儋州市', '儋州', 109.577, 19.5175, 2, 5, 1);
INSERT INTO `sys_area` VALUES (469005, 460000, '文昌市', '文昌', 110.754, 19.613, 2, 18, 1);
INSERT INTO `sys_area` VALUES (469006, 460000, '万宁市', '万宁', 110.389, 18.7962, 2, 17, 1);
INSERT INTO `sys_area` VALUES (469007, 460000, '东方市', '东方', 108.654, 19.102, 2, 7, 1);
INSERT INTO `sys_area` VALUES (469025, 460000, '定安县', '定安', 110.349, 19.685, 2, 6, 1);
INSERT INTO `sys_area` VALUES (469026, 460000, '屯昌县', '屯昌', 110.103, 19.3629, 2, 16, 1);
INSERT INTO `sys_area` VALUES (469027, 460000, '澄迈县', '澄迈', 110.007, 19.7371, 2, 4, 1);
INSERT INTO `sys_area` VALUES (469028, 460000, '临高县', '临高', 109.688, 19.9083, 2, 10, 1);
INSERT INTO `sys_area` VALUES (469030, 460000, '白沙黎族自治县', '白沙', 109.453, 19.2246, 2, 1, 1);
INSERT INTO `sys_area` VALUES (469031, 460000, '昌江黎族自治县', '昌江', 109.053, 19.261, 2, 3, 1);
INSERT INTO `sys_area` VALUES (469033, 460000, '乐东黎族自治县', '乐东', 109.175, 18.7476, 2, 9, 1);
INSERT INTO `sys_area` VALUES (469034, 460000, '陵水黎族自治县', '陵水', 110.037, 18.505, 2, 11, 1);
INSERT INTO `sys_area` VALUES (469035, 460000, '保亭黎族苗族自治县', '保亭', 109.702, 18.6364, 2, 2, 1);
INSERT INTO `sys_area` VALUES (469036, 460000, '琼中黎族苗族自治县', '琼中', 109.84, 19.0356, 2, 13, 1);
INSERT INTO `sys_area` VALUES (500000, 0, '重庆', '重庆', 106.505, 29.5332, 1, 22, 1);
INSERT INTO `sys_area` VALUES (500100, 500000, '重庆市', '重庆', 106.505, 29.5332, 2, 1, 1);
INSERT INTO `sys_area` VALUES (510000, 0, '四川省', '四川', 104.066, 30.6595, 1, 23, 1);
INSERT INTO `sys_area` VALUES (510100, 510000, '成都市', '成都', 104.066, 30.6595, 2, 3, 1);
INSERT INTO `sys_area` VALUES (510300, 510000, '自贡市', '自贡', 104.773, 29.3528, 2, 20, 1);
INSERT INTO `sys_area` VALUES (510400, 510000, '攀枝花市', '攀枝花', 101.716, 26.5804, 2, 16, 1);
INSERT INTO `sys_area` VALUES (510500, 510000, '泸州市', '泸州', 105.443, 28.8891, 2, 11, 1);
INSERT INTO `sys_area` VALUES (510600, 510000, '德阳市', '德阳', 104.399, 31.128, 2, 5, 1);
INSERT INTO `sys_area` VALUES (510700, 510000, '绵阳市', '绵阳', 104.742, 31.464, 2, 13, 1);
INSERT INTO `sys_area` VALUES (510800, 510000, '广元市', '广元', 105.83, 32.4337, 2, 8, 1);
INSERT INTO `sys_area` VALUES (510900, 510000, '遂宁市', '遂宁', 105.571, 30.5133, 2, 17, 1);
INSERT INTO `sys_area` VALUES (511000, 510000, '内江市', '内江', 105.066, 29.5871, 2, 15, 1);
INSERT INTO `sys_area` VALUES (511100, 510000, '乐山市', '乐山', 103.761, 29.582, 2, 9, 1);
INSERT INTO `sys_area` VALUES (511300, 510000, '南充市', '南充', 106.083, 30.7953, 2, 14, 1);
INSERT INTO `sys_area` VALUES (511400, 510000, '眉山市', '眉山', 103.832, 30.0483, 2, 12, 1);
INSERT INTO `sys_area` VALUES (511500, 510000, '宜宾市', '宜宾', 104.631, 28.7602, 2, 19, 1);
INSERT INTO `sys_area` VALUES (511600, 510000, '广安市', '广安', 106.633, 30.4564, 2, 7, 1);
INSERT INTO `sys_area` VALUES (511700, 510000, '达州市', '达州', 107.502, 31.2095, 2, 4, 1);
INSERT INTO `sys_area` VALUES (511800, 510000, '雅安市', '雅安', 103.001, 29.9877, 2, 18, 1);
INSERT INTO `sys_area` VALUES (511900, 510000, '巴中市', '巴中', 106.754, 31.8588, 2, 2, 1);
INSERT INTO `sys_area` VALUES (512000, 510000, '资阳市', '资阳', 104.642, 30.1222, 2, 21, 1);
INSERT INTO `sys_area` VALUES (513200, 510000, '阿坝藏族羌族自治州', '阿坝', 102.221, 31.8998, 2, 1, 1);
INSERT INTO `sys_area` VALUES (513300, 510000, '甘孜藏族自治州', '甘孜', 101.964, 30.0507, 2, 6, 1);
INSERT INTO `sys_area` VALUES (513400, 510000, '凉山彝族自治州', '凉山', 102.259, 27.8868, 2, 10, 1);
INSERT INTO `sys_area` VALUES (520000, 0, '贵州省', '贵州', 106.713, 26.5783, 1, 24, 1);
INSERT INTO `sys_area` VALUES (520100, 520000, '贵阳市', '贵阳', 106.713, 26.5783, 2, 3, 1);
INSERT INTO `sys_area` VALUES (520200, 520000, '六盘水市', '六盘水', 104.847, 26.5846, 2, 4, 1);
INSERT INTO `sys_area` VALUES (520300, 520000, '遵义市', '遵义', 106.937, 27.7066, 2, 9, 1);
INSERT INTO `sys_area` VALUES (520400, 520000, '安顺市', '安顺', 105.932, 26.2455, 2, 1, 1);
INSERT INTO `sys_area` VALUES (522200, 520000, '铜仁市', '铜仁', 109.192, 27.7183, 2, 8, 1);
INSERT INTO `sys_area` VALUES (522300, 520000, '黔西南布依族苗族自治州', '黔西南', 104.898, 25.0881, 2, 7, 1);
INSERT INTO `sys_area` VALUES (522400, 520000, '毕节市', '毕节', 105.285, 27.3017, 2, 2, 1);
INSERT INTO `sys_area` VALUES (522600, 520000, '黔东南苗族侗族自治州', '黔东南', 107.977, 26.5834, 2, 5, 1);
INSERT INTO `sys_area` VALUES (522700, 520000, '黔南布依族苗族自治州', '黔南', 107.517, 26.2582, 2, 6, 1);
INSERT INTO `sys_area` VALUES (530000, 0, '云南省', '云南', 102.712, 25.0406, 1, 25, 1);
INSERT INTO `sys_area` VALUES (530100, 530000, '昆明市', '昆明', 102.712, 25.0406, 2, 7, 1);
INSERT INTO `sys_area` VALUES (530300, 530000, '曲靖市', '曲靖', 103.798, 25.5016, 2, 12, 1);
INSERT INTO `sys_area` VALUES (530400, 530000, '玉溪市', '玉溪', 102.544, 24.3505, 2, 15, 1);
INSERT INTO `sys_area` VALUES (530500, 530000, '保山市', '保山', 99.1671, 25.1118, 2, 1, 1);
INSERT INTO `sys_area` VALUES (530600, 530000, '昭通市', '昭通', 103.717, 27.337, 2, 16, 1);
INSERT INTO `sys_area` VALUES (530700, 530000, '丽江市', '丽江', 100.233, 26.8721, 2, 8, 1);
INSERT INTO `sys_area` VALUES (530800, 530000, '普洱市', '普洱', 100.972, 22.7773, 2, 11, 1);
INSERT INTO `sys_area` VALUES (530900, 530000, '临沧市', '临沧', 100.087, 23.8866, 2, 9, 1);
INSERT INTO `sys_area` VALUES (532300, 530000, '楚雄彝族自治州', '楚雄', 101.546, 25.042, 2, 2, 1);
INSERT INTO `sys_area` VALUES (532500, 530000, '红河哈尼族彝族自治州', '红河', 103.384, 23.3668, 2, 6, 1);
INSERT INTO `sys_area` VALUES (532600, 530000, '文山壮族苗族自治州', '文山', 104.244, 23.3695, 2, 13, 1);
INSERT INTO `sys_area` VALUES (532800, 530000, '西双版纳傣族自治州', '西双版纳', 100.798, 22.0017, 2, 14, 1);
INSERT INTO `sys_area` VALUES (532900, 530000, '大理白族自治州', '大理', 100.226, 25.5894, 2, 3, 1);
INSERT INTO `sys_area` VALUES (533100, 530000, '德宏傣族景颇族自治州', '德宏', 98.5784, 24.4367, 2, 4, 1);
INSERT INTO `sys_area` VALUES (533300, 530000, '怒江傈僳族自治州', '怒江', 98.8543, 25.8509, 2, 10, 1);
INSERT INTO `sys_area` VALUES (533400, 530000, '迪庆藏族自治州', '迪庆', 99.7065, 27.8269, 2, 5, 1);
INSERT INTO `sys_area` VALUES (540000, 0, '西藏自治区', '西藏', 91.1322, 29.6604, 1, 26, 1);
INSERT INTO `sys_area` VALUES (540100, 540000, '拉萨市', '拉萨', 91.1322, 29.6604, 2, 3, 1);
INSERT INTO `sys_area` VALUES (542100, 540000, '昌都地区', '昌都', 97.1785, 31.1369, 2, 2, 1);
INSERT INTO `sys_area` VALUES (542200, 540000, '山南地区', '山南', 91.7665, 29.236, 2, 7, 1);
INSERT INTO `sys_area` VALUES (542300, 540000, '日喀则地区', '日喀则', 88.8851, 29.2675, 2, 6, 1);
INSERT INTO `sys_area` VALUES (542400, 540000, '那曲地区', '那曲', 92.0602, 31.476, 2, 5, 1);
INSERT INTO `sys_area` VALUES (542500, 540000, '阿里地区', '阿里', 80.1055, 32.5032, 2, 1, 1);
INSERT INTO `sys_area` VALUES (542600, 540000, '林芝地区', '林芝', 94.3624, 29.6547, 2, 4, 1);
INSERT INTO `sys_area` VALUES (610000, 0, '陕西省', '陕西', 108.948, 34.2632, 1, 27, 1);
INSERT INTO `sys_area` VALUES (610100, 610000, '西安市', '西安', 108.948, 34.2632, 2, 7, 1);
INSERT INTO `sys_area` VALUES (610200, 610000, '铜川市', '铜川', 108.98, 34.9166, 2, 5, 1);
INSERT INTO `sys_area` VALUES (610300, 610000, '宝鸡市', '宝鸡', 107.145, 34.3693, 2, 2, 1);
INSERT INTO `sys_area` VALUES (610400, 610000, '咸阳市', '咸阳', 108.705, 34.3334, 2, 8, 1);
INSERT INTO `sys_area` VALUES (610500, 610000, '渭南市', '渭南', 109.503, 34.4994, 2, 6, 1);
INSERT INTO `sys_area` VALUES (610600, 610000, '延安市', '延安', 109.491, 36.5965, 2, 9, 1);
INSERT INTO `sys_area` VALUES (610700, 610000, '汉中市', '汉中', 107.029, 33.0777, 2, 3, 1);
INSERT INTO `sys_area` VALUES (610800, 610000, '榆林市', '榆林', 109.741, 38.2902, 2, 10, 1);
INSERT INTO `sys_area` VALUES (610900, 610000, '安康市', '安康', 109.029, 32.6903, 2, 1, 1);
INSERT INTO `sys_area` VALUES (611000, 610000, '商洛市', '商洛', 109.94, 33.8683, 2, 4, 1);
INSERT INTO `sys_area` VALUES (620000, 0, '甘肃省', '甘肃', 103.824, 36.058, 1, 28, 1);
INSERT INTO `sys_area` VALUES (620100, 620000, '兰州市', '兰州', 103.824, 36.058, 2, 7, 1);
INSERT INTO `sys_area` VALUES (620200, 620000, '嘉峪关市', '嘉峪关', 98.2773, 39.7865, 2, 4, 1);
INSERT INTO `sys_area` VALUES (620300, 620000, '金昌市', '金昌', 102.188, 38.5142, 2, 5, 1);
INSERT INTO `sys_area` VALUES (620400, 620000, '白银市', '白银', 104.174, 36.5457, 2, 1, 1);
INSERT INTO `sys_area` VALUES (620500, 620000, '天水市', '天水', 105.725, 34.5785, 2, 12, 1);
INSERT INTO `sys_area` VALUES (620600, 620000, '武威市', '武威', 102.635, 37.93, 2, 13, 1);
INSERT INTO `sys_area` VALUES (620700, 620000, '张掖市', '张掖', 100.455, 38.9329, 2, 14, 1);
INSERT INTO `sys_area` VALUES (620800, 620000, '平凉市', '平凉', 106.685, 35.5428, 2, 10, 1);
INSERT INTO `sys_area` VALUES (620900, 620000, '酒泉市', '酒泉', 98.5108, 39.744, 2, 6, 1);
INSERT INTO `sys_area` VALUES (621000, 620000, '庆阳市', '庆阳', 107.638, 35.7342, 2, 11, 1);
INSERT INTO `sys_area` VALUES (621100, 620000, '定西市', '定西', 104.626, 35.5796, 2, 2, 1);
INSERT INTO `sys_area` VALUES (621200, 620000, '陇南市', '陇南', 104.929, 33.3886, 2, 9, 1);
INSERT INTO `sys_area` VALUES (622900, 620000, '临夏回族自治州', '临夏', 103.212, 35.5994, 2, 8, 1);
INSERT INTO `sys_area` VALUES (623000, 620000, '甘南藏族自治州', '甘南', 102.911, 34.9864, 2, 3, 1);
INSERT INTO `sys_area` VALUES (630000, 0, '青海省', '青海', 101.779, 36.6232, 1, 29, 1);
INSERT INTO `sys_area` VALUES (630100, 630000, '西宁市', '西宁', 101.779, 36.6232, 2, 7, 1);
INSERT INTO `sys_area` VALUES (632100, 630000, '海东市', '海东', 102.103, 36.5029, 2, 3, 1);
INSERT INTO `sys_area` VALUES (632200, 630000, '海北藏族自治州', '海北', 100.901, 36.9594, 2, 2, 1);
INSERT INTO `sys_area` VALUES (632300, 630000, '黄南藏族自治州', '黄南', 102.02, 35.5177, 2, 6, 1);
INSERT INTO `sys_area` VALUES (632500, 630000, '海南藏族自治州', '海南藏族', 100.62, 36.2804, 2, 4, 1);
INSERT INTO `sys_area` VALUES (632600, 630000, '果洛藏族自治州', '果洛', 100.242, 34.4736, 2, 1, 1);
INSERT INTO `sys_area` VALUES (632700, 630000, '玉树藏族自治州', '玉树', 97.0085, 33.004, 2, 8, 1);
INSERT INTO `sys_area` VALUES (632800, 630000, '海西蒙古族藏族自治州', '海西', 97.3708, 37.3747, 2, 5, 1);
INSERT INTO `sys_area` VALUES (640000, 0, '宁夏回族自治区', '宁夏', 106.278, 38.4664, 1, 30, 1);
INSERT INTO `sys_area` VALUES (640100, 640000, '银川市', '银川', 106.278, 38.4664, 2, 4, 1);
INSERT INTO `sys_area` VALUES (640200, 640000, '石嘴山市', '石嘴山', 106.376, 39.0133, 2, 2, 1);
INSERT INTO `sys_area` VALUES (640300, 640000, '吴忠市', '吴忠', 106.199, 37.9862, 2, 3, 1);
INSERT INTO `sys_area` VALUES (640400, 640000, '固原市', '固原', 106.285, 36.0046, 2, 1, 1);
INSERT INTO `sys_area` VALUES (640500, 640000, '中卫市', '中卫', 105.19, 37.5149, 2, 5, 1);
INSERT INTO `sys_area` VALUES (650000, 0, '新疆维吾尔自治区', '新疆', 87.6177, 43.7928, 1, 31, 1);
INSERT INTO `sys_area` VALUES (650100, 650000, '乌鲁木齐市', '乌鲁木齐', 87.6177, 43.7928, 2, 17, 1);
INSERT INTO `sys_area` VALUES (650200, 650000, '克拉玛依市', '克拉玛依', 84.8739, 45.5959, 2, 10, 1);
INSERT INTO `sys_area` VALUES (652100, 650000, '吐鲁番地区', '吐鲁番', 89.1841, 42.9476, 2, 14, 1);
INSERT INTO `sys_area` VALUES (652200, 650000, '哈密地区', '哈密', 93.5132, 42.8332, 2, 7, 1);
INSERT INTO `sys_area` VALUES (652300, 650000, '昌吉回族自治州', '昌吉', 87.304, 44.0146, 2, 6, 1);
INSERT INTO `sys_area` VALUES (652700, 650000, '博尔塔拉蒙古自治州', '博尔塔拉', 82.0748, 44.9033, 2, 5, 1);
INSERT INTO `sys_area` VALUES (652800, 650000, '巴音郭楞蒙古自治州', '巴音郭楞', 86.151, 41.7686, 2, 4, 1);
INSERT INTO `sys_area` VALUES (652900, 650000, '阿克苏地区', '阿克苏', 80.2651, 41.1707, 2, 1, 1);
INSERT INTO `sys_area` VALUES (653000, 650000, '克孜勒苏柯尔克孜自治州', '克孜勒苏柯尔克孜', 76.1728, 39.7134, 2, 11, 1);
INSERT INTO `sys_area` VALUES (653100, 650000, '喀什地区', '喀什', 75.9891, 39.4677, 2, 9, 1);
INSERT INTO `sys_area` VALUES (653200, 650000, '和田地区', '和田', 79.9253, 37.1107, 2, 8, 1);
INSERT INTO `sys_area` VALUES (654000, 650000, '伊犁哈萨克自治州', '伊犁', 81.3179, 43.9219, 2, 18, 1);
INSERT INTO `sys_area` VALUES (654200, 650000, '塔城地区', '塔城', 82.9857, 46.7463, 2, 13, 1);
INSERT INTO `sys_area` VALUES (654300, 650000, '阿勒泰地区', '阿勒泰', 88.1396, 47.8484, 2, 3, 1);
INSERT INTO `sys_area` VALUES (659001, 650000, '石河子市', '石河子', 86.0411, 44.3059, 2, 12, 1);
INSERT INTO `sys_area` VALUES (659002, 650000, '阿拉尔市', '阿拉尔', 81.2859, 40.5419, 2, 2, 1);
INSERT INTO `sys_area` VALUES (659003, 650000, '图木舒克市', '图木舒克', 79.078, 39.8673, 2, 15, 1);
INSERT INTO `sys_area` VALUES (659004, 650000, '五家渠市', '五家渠', 87.5269, 44.1674, 2, 16, 1);
INSERT INTO `sys_area` VALUES (710000, 0, '台湾', '台湾', 121.509, 25.0443, 1, 34, 1);
INSERT INTO `sys_area` VALUES (710100, 710000, '台北市', '台北', 121.509, 25.0443, 2, 12, 1);
INSERT INTO `sys_area` VALUES (710200, 710000, '高雄市', '高雄', 121.509, 25.0443, 2, 1, 1);
INSERT INTO `sys_area` VALUES (710300, 710000, '台南市', '台南', 121.509, 25.0443, 2, 14, 1);
INSERT INTO `sys_area` VALUES (710400, 710000, '台中市', '台中', 121.509, 25.0443, 2, 15, 1);
INSERT INTO `sys_area` VALUES (710500, 710000, '金门县', '金门', 121.509, 25.0443, 2, 6, 1);
INSERT INTO `sys_area` VALUES (710600, 710000, '南投县', '南投', 121.509, 25.0443, 2, 9, 1);
INSERT INTO `sys_area` VALUES (710700, 710000, '基隆市', '基隆', 121.509, 25.0443, 2, 5, 1);
INSERT INTO `sys_area` VALUES (710800, 710000, '新竹市', '新竹', 121.509, 25.0443, 2, 18, 1);
INSERT INTO `sys_area` VALUES (710900, 710000, '嘉义市', '嘉义', 121.509, 25.0443, 2, 3, 1);
INSERT INTO `sys_area` VALUES (711100, 710000, '新北市', '新北', 121.509, 25.0443, 2, 17, 1);
INSERT INTO `sys_area` VALUES (711200, 710000, '宜兰县', '宜兰', 121.509, 25.0443, 2, 20, 1);
INSERT INTO `sys_area` VALUES (711300, 710000, '新竹县', '新竹', 121.509, 25.0443, 2, 19, 1);
INSERT INTO `sys_area` VALUES (711400, 710000, '桃园县', '桃园', 121.509, 25.0443, 2, 16, 1);
INSERT INTO `sys_area` VALUES (711500, 710000, '苗栗县', '苗栗', 121.509, 25.0443, 2, 8, 1);
INSERT INTO `sys_area` VALUES (711700, 710000, '彰化县', '彰化', 121.509, 25.0443, 2, 22, 1);
INSERT INTO `sys_area` VALUES (711900, 710000, '嘉义县', '嘉义', 121.509, 25.0443, 2, 4, 1);
INSERT INTO `sys_area` VALUES (712100, 710000, '云林县', '云林', 121.509, 25.0443, 2, 21, 1);
INSERT INTO `sys_area` VALUES (712400, 710000, '屏东县', '屏东', 121.509, 25.0443, 2, 11, 1);
INSERT INTO `sys_area` VALUES (712500, 710000, '台东县', '台东', 121.509, 25.0443, 2, 13, 1);
INSERT INTO `sys_area` VALUES (712600, 710000, '花莲县', '花莲', 121.509, 25.0443, 2, 2, 1);
INSERT INTO `sys_area` VALUES (712700, 710000, '澎湖县', '澎湖', 121.509, 25.0443, 2, 10, 1);
INSERT INTO `sys_area` VALUES (712800, 710000, '连江县', '连江', 121.509, 25.0443, 2, 7, 1);
INSERT INTO `sys_area` VALUES (810000, 0, '香港特别行政区', '香港', 114.173, 22.32, 1, 32, 1);
INSERT INTO `sys_area` VALUES (810100, 810000, '香港岛', '香港岛', 114.173, 22.32, 2, 2, 1);
INSERT INTO `sys_area` VALUES (810200, 810000, '九龙', '九龙', 114.173, 22.32, 2, 1, 1);
INSERT INTO `sys_area` VALUES (810300, 810000, '新界', '新界', 114.173, 22.32, 2, 3, 1);
INSERT INTO `sys_area` VALUES (820000, 0, '澳门特别行政区', '澳门', 113.549, 22.199, 1, 33, 1);
INSERT INTO `sys_area` VALUES (820100, 820000, '澳门半岛', '澳门半岛', 113.549, 22.1988, 2, 1, 1);
INSERT INTO `sys_area` VALUES (820200, 820000, '离岛', '离岛', 113.549, 22.199, 2, 2, 1);
INSERT INTO `sys_area` VALUES (900000100, 0, '越南胡志明市', '越南胡志明市', 108.827, 12.1846, 1, 100, 1);
INSERT INTO `sys_area` VALUES (900000101, 900000100, '大叻', '大叻', 108.827, 12.1846, 2, 1, 1);
COMMIT;

-- ----------------------------
-- Table structure for sys_cluster_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_cluster_config`;
CREATE TABLE `sys_cluster_config` (
  `id` bigint(25) NOT NULL,
  `app_name` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT '应用名称',
  `type` int(1) DEFAULT '1' COMMENT '应用集群类型（1:iam/sso，2:其他）',
  `env_type` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '环境类型,字典value',
  `view_extranet_base_uri` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '前端视图页面外网BaseURI',
  `extranet_base_uri` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '外网BaseURI',
  `intranet_base_uri` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '内网BaseURI',
  `remark` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `create_by` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0' COMMENT '删除状态（0：正常，1：删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='分布式集群配置表（主要记录对外暴露的门户服务(即web层, 但不包括如facade层)）';

-- ----------------------------
-- Records of sys_cluster_config
-- ----------------------------
BEGIN;
INSERT INTO `sys_cluster_config` VALUES (1, 'uci-server', 2, 'dev', 'http://dopaas.wl4g.debug', 'http://wl4g.debug:17020/uci-server', 'http://localhost:17020/uci-server', 'UCI Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (2, 'iam-web', 1, 'dev', 'http://dopaas.wl4g.debug', 'http://wl4g.debug:18080/iam-web', 'http://localhost:18080/iam-web', 'IAM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (3, 'ucm-server', 2, 'dev', 'http://dopaas.wl4g.debug', 'http://wl4g.debug:17030/ucm-server', 'http://localhost:17030/ucm-server', 'UCM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (4, 'cmdb-manager', 2, 'dev', 'http://dopaas.wl4g.debug', 'http://wl4g.debug:17010/cmdb-manager', 'http://localhost:17010/cmdb-manager', 'CMDB Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (6, 'umc-manager', 2, 'dev', 'http://dopaas.wl4g.debug', 'http://wl4g.debug:17060/umc-manager', 'http://localhost:17060/umc-manager', 'UMC Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (7, 'uci-server', 2, 'fat', 'http://dopaas.wl4g.fat', 'http://uci.wl4g.fat/uci-server', 'http://localhost:17020/uci-server', 'UCI Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (8, 'iam-web', 1, 'fat', 'http://dopaas.wl4g.fat', 'http://iam.wl4g.fat/iam-web', 'http://localhost:18080/iam-web', 'IAM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (9, 'ucm-server', 2, 'fat', 'http://dopaas.wl4g.fat', 'http://ucm.wl4g.fat/ucm-server', 'http://localhost:17030/ucm-server', 'UCM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (10, 'cmdb-manager', 2, 'fat', 'http://dopaas.wl4g.fat', 'http://cmdb.wl4g.fat/cmdb-manager', 'http://localhost:17010/cmdb-manager', 'CMDB Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (12, 'umc-manager', 2, 'fat', 'http://dopaas.wl4g.fat', 'http://umc.wl4g.fat/umc-manager', 'http://localhost:17060/umc-manager', 'UMC Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (13, 'uci-server', 2, 'pro', 'http://dopaas.wl4g.com', 'https://uci.wl4g.com/uci-server', 'http://localhost:17020/uci-server', 'UCI Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (14, 'iam-web', 1, 'pro', 'http://dopaas.wl4g.com', 'https://iam.wl4g.com/iam-web', 'http://localhost:18080/iam-web', 'IAM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (15, 'ucm-server', 2, 'pro', 'http://dopaas.wl4g.com', 'https://ucm.wl4g.com/ucm-server', 'http://localhost:17030/ucm-server', 'UCM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (16, 'cmdb-manager', 2, 'pro', 'http://dopaas.wl4g.com', 'https://cmdb.wl4g.com/cmdb-manager', 'http://localhost:17010/cmdb-manager', 'CMDB Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (17, 'umc-manager', 2, 'pro', 'http://dopaas.wl4g.com', 'https://umc.wl4g.com/umc-manager', 'http://localhost:17060/umc-manager', 'UMC Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (18, 'udm-manager', 2, 'dev', 'http://dopaas.wl4g.debug', 'http://wl4g.debug:17050/udm-manager', 'http://localhost:17050/udm-manager', 'UDM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (19, 'udm-manager', 2, 'fat', 'http://dopaas.wl4g.fat', 'http://udm.wl4g.fat/udm-manager', 'http://localhost:17050/udm-manager', 'UDM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (20, 'udm-manager', 2, 'pro', 'http://dopaas.wl4g.com', 'https://udm.wl4g.com/udm-manager', 'http://localhost:17050/udm-manager', 'UDM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (21, 'uos-manager', 2, 'dev', 'http://dopaas.wl4g.debug', 'http://wl4g.debug:17090/uos-manager', 'http://localhost:17090/uos-manager', 'UOS Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (22, 'uos-manager', 2, 'fat', 'http://dopaas.wl4g.fat', 'http://uos.wl4g.fat/uos-manager', 'http://localhost:17090/uos-manager', 'UOS Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (23, 'uos-manager', 2, 'pro', 'http://dopaas.wl4g.com', 'https://uos.wl4g.com/uos-manager', 'http://localhost:17090/uos-manager', 'UOS Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (24, 'urm-manager', 2, 'dev', 'http://dopaas.wl4g.debug', 'http://wl4g.debug:17070/urm-manager', 'http://localhost:17070/urm-manager', 'URM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (25, 'urm-manager', 2, 'fat', 'http://dopaas.wl4g.fat', 'http://urm.wl4g.fat/urm-manager', 'http://localhost:17070/urm-manager', 'URM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (26, 'urm-manager', 2, 'pro', 'http://dopaas.wl4g.com', 'https://urm.wl4g.com/urm-manager', 'http://localhost:17070/urm-manager', 'URM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (27, 'uci-server', 2, 'uat', 'http://dopaas.wl4g.uat', 'http://uci.wl4g.uat/uci-server', 'http://localhost:17020/uci-server', 'UCI Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (28, 'iam-web', 1, 'uat', 'http://dopaas.wl4g.uat', 'http://iam.wl4g.uat/iam-web', 'http://localhost:18080/iam-web', 'IAM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (29, 'ucm-server', 2, 'uat', 'http://dopaas.wl4g.uat', 'http://ucm.wl4g.uat/ucm-server', 'http://localhost:17030/ucm-server', 'UCM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (30, 'cmdb-manager', 2, 'uat', 'http://dopaas.wl4g.uat', 'http://cmdb.wl4g.uat/cmdb-manager', 'http://localhost:17010/cmdb-manager', 'CMDB Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (31, 'umc-manager', 2, 'uat', 'http://dopaas.wl4g.uat', 'http://umc.wl4g.uat/umc-manager', 'http://localhost:17060/umc-manager', 'UMC Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (32, 'urm-manager', 2, 'uat', 'http://dopaas.wl4g.uat', 'http://urm.wl4g.uat/urm-manager', 'http://localhost:17070/urm-manager', 'URM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (33, 'uos-manager', 2, 'uat', 'http://dopaas.wl4g.uat', 'http://uos.wl4g.uat/uos-manager', 'http://localhost:17090/uos-manager', 'UOS Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (34, 'udm-manager', 2, 'uat', 'http://dopaas.wl4g.uat', 'http://udm.wl4g.uat/udm-manager', 'http://localhost:17050/udm-manager', 'UDM Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (35, 'lcdp-manager', 2, 'dev', 'http://dopaas.wl4g.debug', 'http://wl4g.debug:17040/lcdp-manager', 'http://localhost:17040/lcdp-manager', 'LCDP Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (36, 'lcdp-manager', 2, 'fat', 'http://dopaas.wl4g.fat', 'http://udc.wl4g.fat/lcdp-manager', 'http://localhost:17040/lcdp-manager', 'LCDP Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (37, 'lcdp-manager', 2, 'uat', 'http://dopaas.wl4g.uat', 'http://udc.wl4g.uat/lcdp-manager', 'http://localhost:17040/lcdp-manager', 'LCDP Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (38, 'lcdp-manager', 2, 'pro', 'http://dopaas.wl4g.com', 'https://udc.wl4g.com/lcdp-manager', 'http://localhost:17040/lcdp-manager', 'LCDP Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (43, 'dopaas-server', 2, 'dev', 'http://dopaas.wl4g.debug', 'http://wl4g.debug:20000/dopaas-server', 'http://localhost:20000/dopaas-server', 'DoPaaS Web(Standalone Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (44, 'dopaas-server', 2, 'fat', 'http://dopaas.wl4g.fat', 'http://dopaas-services.wl4g.fat/dopaas-server', 'http://localhost:20000/dopaas-server', 'DoPaaS Web(Standalone Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (45, 'dopaas-server', 2, 'uat', 'http://dopaas.wl4g.uat', 'http://dopaas-services.wl4g.uat/dopaas-server', 'http://localhost:20000/dopaas-server', 'DoPaaS Web(Standalone Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (46, 'dopaas-server', 2, 'pro', 'http://dopaas.wl4g.com', 'http://dopaas-services.wl4g.com/dopaas-server', 'http://localhost:20000/dopaas-server', 'DoPaaS Web(Standalone Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (48, 'uds-manager', 2, 'fat', 'http://dopaas.wl4g.fat', 'http://uds.wl4g.fat/uds-manager', 'http://localhost:17080/uds-manager', 'UDS Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (50, 'uds-manager', 2, 'pro', 'http://dopaas.wl4g.com', 'https://uds.wl4g.com/uds-manager', 'http://localhost:17080/uds-manager', 'UDS Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (51, 'uds-manager', 2, 'dev', 'http://dopaas.wl4g.debug', 'http://wl4g.debug:17080/uds-manager', 'http://localhost:17080/uds-manager', 'UDS Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
INSERT INTO `sys_cluster_config` VALUES (53, 'uds-manager', 2, 'uat', 'http://dopaas.wl4g.uat', 'http://uds.wl4g.uat/uds-manager', 'http://localhost:17080/uds-manager', 'UDS Web(Cluster Portal) Services', NULL, NULL, NULL, NULL, 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_contact
-- ----------------------------
DROP TABLE IF EXISTS `sys_contact`;
CREATE TABLE `sys_contact` (
  `id` bigint(25) NOT NULL,
  `name` varchar(30) CHARACTER SET utf8 NOT NULL COMMENT '通知分组名称',
  `create_by` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='告警联系人表';

-- ----------------------------
-- Table structure for sys_contact_channel
-- ----------------------------
DROP TABLE IF EXISTS `sys_contact_channel`;
CREATE TABLE `sys_contact_channel` (
  `id` bigint(25) NOT NULL,
  `kind` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT 'email,phone,wechat,dingtalk,twitter,facebook---对应com.wl4g.devops.support.notification.NotifierKind',
  `contact_id` bigint(25) DEFAULT NULL COMMENT '联系人id',
  `primary_address` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '具体的联系地址:可能是email,phone,wechat的open_id等',
  `time_of_freq` int(11) DEFAULT NULL COMMENT '频率时间',
  `num_of_freq` int(11) DEFAULT NULL COMMENT '频率次数',
  `enable` int(11) DEFAULT NULL COMMENT '是否启用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for sys_contact_group
-- ----------------------------
DROP TABLE IF EXISTS `sys_contact_group`;
CREATE TABLE `sys_contact_group` (
  `id` bigint(25) NOT NULL,
  `name` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '告警分组名称',
  `create_date` datetime DEFAULT NULL,
  `create_by` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='告警联系人分组表';

-- ----------------------------
-- Table structure for sys_contact_group_ref
-- ----------------------------
DROP TABLE IF EXISTS `sys_contact_group_ref`;
CREATE TABLE `sys_contact_group_ref` (
  `id` bigint(25) NOT NULL,
  `contact_group_id` bigint(25) NOT NULL,
  `contact_id` bigint(25) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `contact_group_id` (`contact_group_id`) USING BTREE,
  KEY `contact_id` (`contact_id`) USING BTREE,
  CONSTRAINT `sys_contact_group_ref_ibfk_1` FOREIGN KEY (`contact_group_id`) REFERENCES `sys_contact_group` (`id`),
  CONSTRAINT `sys_contact_group_ref_ibfk_2` FOREIGN KEY (`contact_id`) REFERENCES `sys_contact` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict` (
  `key` varchar(128) COLLATE utf8_bin NOT NULL COMMENT 'key,唯一',
  `value` varchar(128) COLLATE utf8_bin NOT NULL COMMENT '数据值',
  `label` varchar(128) COLLATE utf8_bin NOT NULL COMMENT '标签名',
  `label_en` varchar(128) COLLATE utf8_bin NOT NULL COMMENT '标签名(EN)',
  `type` varchar(100) COLLATE utf8_bin NOT NULL COMMENT '类型',
  `themes` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '主题/样式',
  `icon` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '图标',
  `sort` decimal(10,0) NOT NULL DEFAULT '50' COMMENT '排序（升序）',
  `status` int(1) NOT NULL DEFAULT '1' COMMENT '字典状态（1:均使用 | 2:仅后台使用 | 3:仅前端使用）释：如状态为`2`的字典的值不会返回给前端（登录后返回字典列表给前端缓存）',
  `enable` int(11) DEFAULT NULL,
  `create_by` bigint(25) NOT NULL COMMENT '创建者',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_by` bigint(25) NOT NULL COMMENT '更新者',
  `update_date` datetime NOT NULL COMMENT '更新时间',
  `remark` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
  `del_flag` int(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`key`) USING BTREE,
  KEY `sys_dict_value` (`value`) USING BTREE,
  KEY `sys_dict_label` (`label`) USING BTREE,
  KEY `sys_dict_del_flag` (`del_flag`) USING BTREE,
  KEY `key` (`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='字典表\r\ndict系统管理（界面）： key、type不可变（只能开发人员修改数据库，因key、type会在代码硬编码)\r\n只可修改 value、themes、icon、lable、sort、status、description';

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
BEGIN;
INSERT INTO `sys_dict` VALUES ('aggre_oper_type@avg', 'avg', '平均值', 'avg', 'agg_oper_type', '', '', 50, 1, 1, 1, '2019-07-16 13:17:22', 1, '2020-10-04 22:53:14', '聚合运算符（平均值） ', 0);
INSERT INTO `sys_dict` VALUES ('aggre_oper_type@latest', 'latest', '最新值', 'latest', 'agg_oper_type', '', '', 50, 1, 1, 1, '2019-07-16 13:17:22', 1, '2020-10-21 10:26:48', '聚合运算符（最新值）', 0);
INSERT INTO `sys_dict` VALUES ('aggre_oper_type@max', 'max', '最大值', 'max', 'agg_oper_type', NULL, NULL, 50, 1, 1, 1, '2019-07-16 13:17:22', 1, '2019-09-15 13:55:21', '聚合运算符（最大值）', 0);
INSERT INTO `sys_dict` VALUES ('aggre_oper_type@min', 'min', '最小值', 'min', 'agg_oper_type', NULL, NULL, 50, 1, 1, 1, '2019-07-16 13:17:22', 1, '2019-07-16 13:17:22', '聚合运算符（最小值）', 0);
INSERT INTO `sys_dict` VALUES ('app_ns_type@dev', 'dev', '开发环境', 'Development Environment', 'app_ns_type', '', '', 10, 1, 1, 1, '2019-06-12 08:00:00', 1, '2020-06-03 15:07:15', '开发环境，用于开发者调试使用（Development environment）', 0);
INSERT INTO `sys_dict` VALUES ('app_ns_type@fat', 'fat', '测试环境', 'Testing Environment', 'app_ns_type', '', '', 20, 1, 1, 1, '2019-06-12 08:00:00', 1, '2020-06-03 15:08:43', '功能验收测试环境，用于软件测试使用（Feature Acceptance Test environment）', 0);
INSERT INTO `sys_dict` VALUES ('app_ns_type@pro', 'pro', '生产环境', 'Production Environment', 'app_ns_type', '', '', 40, 1, 1, 1, '2019-06-12 08:00:00', 1, '2020-06-03 15:14:10', '线上生产环境（Production environment）', 0);
INSERT INTO `sys_dict` VALUES ('app_ns_type@uat', 'uat', '验收环境', 'User Verify Environment', 'app_ns_type', '', '', 30, 1, 1, 1, '2019-06-12 08:00:00', 1, '2020-06-03 15:12:17', '用户验收测试环境，用于生产环境下的软件灰度测试使用（User Acceptance Test environment）', 0);
INSERT INTO `sys_dict` VALUES ('arith_oper_type@add', 'add', '加', 'add', 'arith_oper_type', NULL, NULL, 50, 1, 1, 1, '2019-07-16 13:17:22', 1, '2019-08-16 08:56:19', '算术运算符（加）', 0);
INSERT INTO `sys_dict` VALUES ('arith_oper_type@div', 'div', '除', 'div', 'arith_oper_type', NULL, NULL, 50, 1, 1, 1, '2019-07-16 13:17:22', 1, '2019-08-16 08:56:06', '算术运算符（除）', 0);
INSERT INTO `sys_dict` VALUES ('arith_oper_type@mul', 'mul', '乘', 'mul', 'arith_oper_type', NULL, NULL, 50, 1, 1, 1, '2019-07-16 13:17:22', 1, '2019-08-16 08:56:18', '算术运算符（乘）', 0);
INSERT INTO `sys_dict` VALUES ('arith_oper_type@subtr', 'subtr', '减', 'subtr', 'arith_oper_type', NULL, NULL, 50, 1, 1, 1, '2019-07-16 13:17:22', 1, '2019-08-16 08:56:20', '算术运算符（减）', 0);
INSERT INTO `sys_dict` VALUES ('ci_analysis_state@analyzing', '4', 'Analyzing', 'Analyzing', 'ci_analysis_state', NULL, NULL, 50, 1, NULL, 1, '2019-12-16 17:32:57', 1, '2019-12-16 17:32:57', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_analysis_state@done', '5', 'Done', 'Done', 'ci_analysis_state', NULL, NULL, 50, 1, NULL, 1, '2019-12-16 17:32:57', 1, '2019-12-16 17:32:57', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_analysis_state@new', '1', 'New', 'New', 'ci_analysis_state', NULL, NULL, 50, 1, NULL, 1, '2019-12-16 17:28:55', 1, '2019-12-16 17:28:57', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_analysis_state@scan', '3', 'Scan', 'Scan', 'ci_analysis_state', NULL, NULL, 50, 1, NULL, 1, '2019-12-16 17:32:57', 1, '2019-12-16 17:32:57', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_analysis_state@waiting', '2', 'Waiting', 'Waiting', 'ci_analysis_state', NULL, NULL, 50, 1, NULL, 1, '2019-12-16 17:32:57', 1, '2019-12-16 17:32:57', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_orchestration_type@k8s', '2', 'K8s编排', 'K8s layout', 'ci_orchestration_type', NULL, NULL, 50, 1, 1, 1, '2019-11-13 09:30:46', 1, '2019-11-13 09:30:48', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_orchestration_type@native', '1', '原生编排', 'Native layout', 'ci_orchestration_type', NULL, NULL, 49, 1, 1, 1, '2019-11-13 09:30:46', 1, '2019-11-13 09:30:48', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_provider_kind@DockerNative', 'DockerNative', 'DockerNative', 'DockerNative', 'ci_provider_kind', 'primary', NULL, 50, 1, 0, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_provider_kind@Golang', 'Golang', 'Golang', 'Golang', 'ci_provider_kind', 'primary', NULL, 50, 1, 0, 1, '2019-08-13 15:10:32', 1, '2019-11-22 11:22:03', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_provider_kind@MvnAssTar', 'MvnAssTar', 'MvnAssTar', 'MvnAssTar', 'ci_provider_kind', 'primary', NULL, 1, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_provider_kind@NpmTar', 'NpmTar', 'NpmTar', 'NpmTar', 'ci_provider_kind', 'primary', NULL, 2, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_provider_kind@Python3', 'Python3', 'Python3', 'Python3', 'ci_provider_kind', 'primary', NULL, 50, 1, 0, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_provider_kind@RktNative', 'RktNative', 'RktNative', 'RktNative', 'ci_provider_kind', 'primary', NULL, 50, 1, 0, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_provider_kind@SpringExecJar', 'SpringExecJar', 'SpringExecJar', 'SpringExecJar', 'ci_provider_kind', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_provider_kind@ViewNative', 'ViewNative', 'ViewNative', 'ViewNative', 'ci_provider_kind', 'primary', NULL, 2, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_task_type@failed', '3', '失败', 'Failed', 'ci_task_type', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_task_type@new', '0', '新建', 'New', 'ci_task_type', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_task_type@part_success', '6', '部分成功', 'Part Success', 'ci_task_type', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_task_type@running', '1', '运行中', 'Running', 'ci_task_type', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_task_type@stoping', '7', '停止中', 'Stoping', 'ci_task_type', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_task_type@stopped', '5', '停止', 'Stopped', 'ci_task_type', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_task_type@success', '2', '成功', 'Success', 'ci_task_type', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_task_type@timeout', '4', '超时', 'Timeout', 'ci_task_type', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_track_type@bug', '2', '漏洞', 'Bug', 'ci_track_type', NULL, NULL, 2, 1, 1, 1, '2019-11-13 09:30:46', 1, '2019-11-13 09:30:48', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_track_type@feedback', '4', '反馈', 'Feedback', 'ci_track_type', NULL, NULL, 4, 1, 1, 1, '2019-11-13 09:30:46', 1, '2019-11-13 09:30:48', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_track_type@iteration', '3', '迭代', 'Iteration', 'ci_track_type', NULL, NULL, 3, 1, 1, 1, '2019-11-13 09:30:46', 1, '2019-11-13 09:30:48', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_track_type@new', '1', '新建', 'New', 'ci_track_type', NULL, NULL, 1, 1, 1, 1, '2019-11-13 09:30:46', 1, '2019-11-13 09:30:48', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_vcs_type@VcsWithGithub', 'VcsWithGithub', 'VcsWithGithub', 'VcsWithGithub', 'ci_vcs_type', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('ci_vcs_type@VcsWithGitlab', 'VcsWithGitlab', 'VcsWithGitlab', 'VcsWithGitlab', 'ci_vcs_type', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('codegen_extra_type@basedon.adminui', 'basedon.adminui', 'basedon.adminui', 'basedon.adminui', 'codegen_extra_type', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2020-10-11 17:39:59', '是否基于elementui(adminui)框架生成Vue项目', 0);
INSERT INTO `sys_dict` VALUES ('codegen_extra_type@build.assets-type', 'build.assets-type', 'build.assets-type', 'build.assets-type', 'codegen_extra_type', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2020-10-11 18:01:27', '生成的后端项目构建包的类型，如：使用maven-assemble插件或springboot-plugin插件', 0);
INSERT INTO `sys_dict` VALUES ('codegen_extra_type@compression', 'compression', 'compression', 'compression', 'codegen_extra_type', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2020-10-11 17:43:34', '生成的前端项目的配置是否开启压缩', 0);
INSERT INTO `sys_dict` VALUES ('codegen_extra_type@iam.mode', 'iam.mode', 'iam.mode', 'iam.mode', 'codegen_extra_type', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2020-10-11 18:01:27', '生成的后端项目依赖IAM的部署模式，如：cluster微服务集群模式；gateway微服务网关模式；local单体应用模式', 0);
INSERT INTO `sys_dict` VALUES ('codegen_extra_type@swagger.ui', 'swagger.ui', 'swagger.ui', 'swagger.ui', 'codegen_extra_type', 'primary', '', 50, 1, 1, 1, '2020-10-11 18:00:41', 1, '2020-10-11 18:06:57', '生成后端项目swaggerui配置，如：officialOas(官方默认UI), bootstrapSwagger2(第三方), none(禁用生成)', 0);
INSERT INTO `sys_dict` VALUES ('codegen_providerset_type@DubboWebMvcVueJS', 'DubboWebMvcVueJS', 'DubboWebMvcVueJS', 'DubboWebMvcVueJS', 'codegen_providerset_type', 'primary', '', 50, 1, 1, 1, '2020-10-11 17:38:53', 1, '2020-10-11 17:46:49', '基于Dubbo + Spring Cloud Web架构体系的生成器模版', 0);
INSERT INTO `sys_dict` VALUES ('codegen_providerset_type@GonicWebMVC', 'GonicWebMVC', 'GonicWebMVC', 'GonicWebMVC', 'codegen_providerset_type', 'primary', '', 50, 1, 1, 1, '2020-10-11 17:38:18', 1, '2020-10-11 17:45:55', '基于Goinc的golang Web项目生成器模版', 0);
INSERT INTO `sys_dict` VALUES ('codegen_providerset_type@IamWebMvc', 'IamWebMvc', 'IamWebMvc', 'IamWebMvc', 'codegen_providerset_type', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2020-10-11 17:46:36', '基于IAM + Spring Cloud Web架构体系的生成器模版', 0);
INSERT INTO `sys_dict` VALUES ('codegen_providerset_type@IamWebMvcVueJS', 'IamWebMvcVueJS', 'IamWebMvcVueJS', 'IamWebMvcVueJS', 'codegen_providerset_type', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2020-10-11 17:47:26', '基于IAM + Spring Cloud Web + VueJS架构的生成器模版', 0);
INSERT INTO `sys_dict` VALUES ('codegen_providerset_type@JustNgJS', 'JustNgJS', 'JustNgJS', 'JustNgJS', 'codegen_providerset_type', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2020-10-11 17:48:28', '基于生成AngluraJS架构的项目生成器模版', 0);
INSERT INTO `sys_dict` VALUES ('codegen_providerset_type@JustVueJS', 'JustVueJS', 'JustVueJS', 'JustVueJS', 'codegen_providerset_type', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2020-10-11 17:48:36', '基于生成VueJS架构的项目生成器模版', 0);
INSERT INTO `sys_dict` VALUES ('codegen_tab_extra_type@tab.del-type', 'tab.del-type', 'tab.del-type', 'tab.del-type', 'codegen_tab_extra_type', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2020-10-11 17:39:59', '列表删除类型', 0);
INSERT INTO `sys_dict` VALUES ('codegen_tab_extra_type@tab.edit-type', 'tab.edit-type', 'tab.edit-type', 'tab.edit-type', 'codegen_tab_extra_type', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2020-10-11 17:39:59', '功能编辑类型', 0);
INSERT INTO `sys_dict` VALUES ('codegen_tab_extra_type@tab.export-excel', 'tab.export-excel', 'tab.export-excel', 'tab.export-excel', 'codegen_tab_extra_type', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2020-10-11 17:39:59', '是否配置Excel导出', 0);
INSERT INTO `sys_dict` VALUES ('common_enable_status@disable', '0', '停用', 'Disable', 'common_enable_status', 'danger', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:20', 'common_enable_status', 0);
INSERT INTO `sys_dict` VALUES ('common_enable_status@enable', '1', '启用', 'Enable', 'common_enable_status', '', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:20', 'common_enable_status', 0);
INSERT INTO `sys_dict` VALUES ('coss_provider@aliyunoss', 'aliyunoss', 'aliyunoss', 'aliyunoss', 'coss_provider', '', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('coss_provider@awss3', 'awss3', 'awss3', 'awss3', 'coss_provider', '', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('coss_provider@glusterfs', 'glusterfs', 'glusterfs', 'glusterfs', 'coss_provider', '', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('coss_provider@hdfs', 'hdfs', 'hdfs', 'hdfs', 'coss_provider', '', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('coss_provider@nativefs', 'nativefs', 'nativefs', 'nativefs', 'coss_provider', '', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('ctl_switch_type@off', 'off', '关', 'off', 'switch_type', 'gray', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:20', '控制开关（关）', 0);
INSERT INTO `sys_dict` VALUES ('ctl_switch_type@on', 'on', '开', 'on', 'switch_type', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:20', '控制开关（开）', 0);
INSERT INTO `sys_dict` VALUES ('doc_file_type@md', 'md', 'Md', 'Md', 'doc_file_type', NULL, NULL, 50, 1, 1, 1, '2020-01-14 14:51:04', 1, '2020-01-14 14:51:05', NULL, 0);
INSERT INTO `sys_dict` VALUES ('doc_file_type@txt', 'Txt', 'Txt', 'Txt', 'doc_file_type', NULL, NULL, 50, 1, 1, 1, '2020-01-14 14:51:04', 1, '2020-01-14 14:51:05', NULL, 0);
INSERT INTO `sys_dict` VALUES ('doc_lang_type@en_US', 'en_US', 'US English Edition', 'US English Edition', 'doc_lang_type', NULL, NULL, 50, 1, 1, 1, '2020-01-14 14:51:04', 1, '2020-01-14 14:51:05', NULL, 0);
INSERT INTO `sys_dict` VALUES ('doc_lang_type@ja_JP', 'ja_JP', '日陰勢', '日陰勢', 'doc_lang_type', NULL, NULL, 50, 1, 1, 1, '2020-01-14 14:51:04', 1, '2020-01-14 14:51:05', NULL, 0);
INSERT INTO `sys_dict` VALUES ('doc_lang_type@zh_CN', 'zh_CN', '简体中文版', '简体中文版', 'doc_lang_type', NULL, NULL, 50, 1, 1, 1, '2020-01-14 14:51:04', 1, '2020-01-14 14:51:05', NULL, 0);
INSERT INTO `sys_dict` VALUES ('doc_lang_type@zh_HK', 'zh_HK', '繁體中文版', '繁體中文版', 'doc_lang_type', NULL, NULL, 50, 1, 1, 1, '2020-01-14 14:51:04', 1, '2020-01-14 14:51:05', NULL, 0);
INSERT INTO `sys_dict` VALUES ('erm_dns_blacklist_type@blacklist', '1', '黑名单', 'BlackList', 'erm_dns_blacklist_type', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', NULL, 0);
INSERT INTO `sys_dict` VALUES ('erm_dns_blacklist_type@whitelist', '2', '白名单', 'WhiteList', 'erm_dns_blacklist_type', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', NULL, 0);
INSERT INTO `sys_dict` VALUES ('erm_dns_kind@AliyunDc', 'AliyunDc', 'AliyunDc', 'AliyunDc', 'erm_dns_kind', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('erm_dns_kind@AwsDc', 'AwsDc', 'AwsDc', 'AwsDc', 'erm_dns_kind', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('erm_dns_kind@Cndns', 'Cndns', 'Cndns', 'Cndns', 'erm_dns_kind', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('erm_dns_resolve_type@cname', 'cname', 'CNAME', 'CNAME', 'erm_dns_resolve_type', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('erm_dns_resolve_type@mx', 'mx', 'MX', 'MX', 'erm_dns_resolve_type', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('erm_dns_resolve_type@ns', 'ns', 'NS', 'NS', 'erm_dns_resolve_type', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('erm_dns_resolve_type@soa', 'soa', 'SOA', 'SOA', 'erm_dns_resolve_type', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('erm_dns_resolve_type@srv', 'srv', 'SRV', 'SRV', 'erm_dns_resolve_type', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('erm_dns_resolve_type@txt', 'txt', 'TXT', 'TXT', 'erm_dns_resolve_type', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('erm_server_type@coss', '4', 'Coss', 'Coss', 'erm_server_type', NULL, NULL, 52, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('erm_server_type@docker', '2', 'Docker', 'Docker', 'erm_server_type', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('erm_server_type@host', '1', 'Host', 'Host', 'erm_server_type', NULL, NULL, 49, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('erm_server_type@k8s', '3', 'K8s', 'K8s', 'erm_server_type', NULL, NULL, 51, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('erm_ssh_auth_type@password', '1', '账号密码', 'Password', 'erm_ssh_auth_type', '', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', NULL, 0);
INSERT INTO `sys_dict` VALUES ('erm_ssh_auth_type@ssh', '2', '私钥', 'Ssh', 'erm_ssh_auth_type', '', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('erm_vpn_tunnel_type@host', '1', 'Host', 'Host', 'erm_vpn_tunnel_type', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('erm_vpn_tunnel_type@openvpn', '2', 'Openvpn', 'Openvpn', 'erm_vpn_tunnel_type', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('erm_vpn_tunnel_type@pptp', '3', 'Pptp', 'Pptp', 'erm_vpn_tunnel_type', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('idc_provider@aliyun', '1', '阿里云', 'Aliyun Cloud', 'idc_provider', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('idc_provider@aws', '2', '亚马逊云', 'Aws Cloud', 'idc_provider', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('idc_provider@azure', '3', '微软云', 'Azure Cloud', 'idc_provider', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('idc_provider@baidu', '4', '百度云', 'Baidu Cloud', 'idc_provider', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('idc_provider@ctyun', '5', '天翼云', 'Ctyun Cloud', 'idc_provider', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('idc_provider@google', '6', 'Google云', 'Google Cloud', 'idc_provider', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('idc_provider@qingcloud', '7', '青云', 'Qing Cloud', 'idc_provider', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', NULL, 0);
INSERT INTO `sys_dict` VALUES ('idc_provider@tencent', '8', '腾讯云', 'Tencent Cloud', 'idc_provider', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('logical_oper_type@and', 'and', '与', 'and', 'logical_oper_type', NULL, NULL, 50, 1, 1, 1, '2019-07-16 13:17:22', 1, '2019-08-16 08:56:21', '逻辑运算符（与）', 0);
INSERT INTO `sys_dict` VALUES ('logical_oper_type@not', 'not', '非', 'not', 'logical_oper_type', NULL, NULL, 50, 1, 1, 1, '2019-07-16 13:17:22', 1, '2019-08-16 08:56:21', '逻辑运算符（非）', 0);
INSERT INTO `sys_dict` VALUES ('logical_oper_type@or', 'or', '或', 'or', 'logical_oper_type', NULL, NULL, 50, 1, 1, 1, '2019-07-16 13:17:22', 1, '2019-08-16 08:56:21', '逻辑运算符（或）', 0);
INSERT INTO `sys_dict` VALUES ('menu_classify_type@classifyA', 'classifyA', '构建', 'CI/CD', 'menu_classify_type', NULL, NULL, 50, 1, 1, 1, '2020-07-23 14:52:07', 1, '2020-07-24 12:06:25', '', 0);
INSERT INTO `sys_dict` VALUES ('menu_classify_type@classifyB', 'classifyB', '监控', 'Monitors', 'menu_classify_type', NULL, NULL, 50, 1, 1, 1, '2020-07-23 14:52:07', 1, '2020-07-24 12:06:00', '', 0);
INSERT INTO `sys_dict` VALUES ('menu_classify_type@classifyC', 'classifyC', '网络', 'Networks', 'menu_classify_type', NULL, NULL, 50, 1, 1, 1, '2020-07-23 14:52:07', 1, '2020-07-24 12:05:35', '', 0);
INSERT INTO `sys_dict` VALUES ('menu_classify_type@classifyD', 'classifyD', '安全', 'Securitys', 'menu_classify_type', NULL, NULL, 50, 1, 1, 1, '2020-07-24 12:08:49', 1, '2020-07-24 12:08:49', '', 0);
INSERT INTO `sys_dict` VALUES ('menu_classify_type@classifyE', 'classifyE', '基础', 'Foundations', 'menu_classify_type', NULL, NULL, 50, 1, 1, 1, '2020-07-23 14:52:07', 1, '2020-07-24 12:06:25', '', 0);
INSERT INTO `sys_dict` VALUES ('menu_classify_type@classifyF', 'classifyF', '存储', 'Storages', 'menu_classify_type', NULL, NULL, 50, 1, 1, 1, '2020-07-23 14:52:07', 1, '2020-07-24 12:06:25', '', 0);
INSERT INTO `sys_dict` VALUES ('menu_classify_type@classifyG', 'classifyG', '配置', 'Configurations', 'menu_classify_type', '', '', 50, 1, 1, 1, '2020-07-23 14:52:07', 1, '2020-07-24 12:06:25', '', 0);
INSERT INTO `sys_dict` VALUES ('menu_classify_type@classifyH', 'classifyH', '文档', 'Docs', 'menu_classify_type', '', '', 50, 1, 1, 1, '2020-07-23 14:52:07', 1, '2020-07-24 12:06:25', '', 0);
INSERT INTO `sys_dict` VALUES ('menu_classify_type@classifyI', 'classifyI', '开发', 'Developer', 'menu_classify_type', '', '', 50, 1, 1, 1, '2020-07-23 14:52:07', 1, '2020-07-24 12:06:25', '', 0);
INSERT INTO `sys_dict` VALUES ('menu_classify_type@classifyJ', 'classifyJ', '系统', 'System', 'menu_classify_type', '', '', 50, 1, 1, 1, '2020-07-23 14:52:07', 1, '2020-07-24 12:06:25', '', 0);
INSERT INTO `sys_dict` VALUES ('menu_type@button', '3', '按钮', 'Button', 'menu_type', NULL, NULL, 50, 1, 1, 1, '2019-12-17 14:21:38', 1, '2019-12-17 14:21:42', '', 0);
INSERT INTO `sys_dict` VALUES ('menu_type@dynamic', '2', '动态菜单', 'Dynamic Menu', 'menu_type', NULL, NULL, 50, 1, NULL, 1, '2019-12-17 14:21:38', 1, '2019-12-17 14:21:42', NULL, 0);
INSERT INTO `sys_dict` VALUES ('menu_type@static', '1', '静态菜单', 'Static Menu', 'menu_type', NULL, NULL, 50, 1, 1, 1, '2019-12-17 14:21:38', 1, '2019-12-17 14:21:42', '', 0);
INSERT INTO `sys_dict` VALUES ('metric_classify@basic', 'basic', 'basic', 'basic', 'metric_classify', 'primary', '', 50, 1, 1, 1, '2019-08-23 16:55:57', 1, '2019-08-23 16:55:57', NULL, 0);
INSERT INTO `sys_dict` VALUES ('metric_classify@docker', 'docker', 'docker', 'docker', 'metric_classify', 'primary', '', 50, 1, 1, 1, '2019-08-23 16:58:11', 1, '2019-08-23 16:58:11', NULL, 0);
INSERT INTO `sys_dict` VALUES ('metric_classify@kafka', 'kafka', 'kafka', 'kafka', 'metric_classify', 'primary', '', 50, 1, 1, 1, '2019-08-23 17:01:14', 1, '2019-08-23 17:01:14', NULL, 0);
INSERT INTO `sys_dict` VALUES ('metric_classify@redis', 'redis', 'redis', 'redis', 'metric_classify', 'primary', '', 50, 1, 1, 1, '2019-08-23 16:58:47', 1, '2019-08-23 16:58:47', NULL, 0);
INSERT INTO `sys_dict` VALUES ('metric_classify@zookeeper', 'zookeeper', 'zookeeper', 'zookeeper', 'metric_classify', 'primary', '', 50, 1, 1, 1, '2019-08-23 17:02:01', 1, '2019-08-23 17:02:01', NULL, 0);
INSERT INTO `sys_dict` VALUES ('pcm_auth_type@key', '2', 'key', 'key', 'pcm_auth_type', '', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('pcm_auth_type@password', '1', 'password', 'password', 'pcm_auth_type', '', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', NULL, 0);
INSERT INTO `sys_dict` VALUES ('pcm_provider@jira', 'jira', 'Jira', 'Jira', 'pcm_provider', 'primary', NULL, 50, 1, 0, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('pcm_provider@redmine', 'redmine', 'Redmine', 'Redmine', 'pcm_provider', 'primary', NULL, 49, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('relate_oper_type@gt', 'gt', '大于', 'gt', 'relate_oper_type', NULL, NULL, 50, 1, 1, 1, '2019-07-16 13:17:22', 1, '2019-08-16 08:56:22', '关系运算符（大于）', 0);
INSERT INTO `sys_dict` VALUES ('relate_oper_type@gte', 'gte', '大于等于', 'gte', 'relate_oper_type', NULL, NULL, 50, 1, 1, 1, '2019-07-16 13:17:22', 1, '2019-08-16 08:56:22', '关系运算符（大于等于）', 0);
INSERT INTO `sys_dict` VALUES ('relate_oper_type@lt', 'lt', '小于', 'lt', 'relate_oper_type', NULL, NULL, 50, 1, 1, 1, '2019-07-16 13:17:22', 1, '2019-08-16 08:56:22', '关系运算符（小于）', 0);
INSERT INTO `sys_dict` VALUES ('relate_oper_type@lte', 'lte', '小于等于', 'lte', 'relate_oper_type', NULL, NULL, 50, 1, 1, 1, '2019-07-16 13:17:22', 1, '2019-07-16 13:17:22', '关系运算符（小于等于）', 0);
INSERT INTO `sys_dict` VALUES ('sys_contact_type@AliyunSms', 'AliyunSms', 'Aliyun短信', 'AliyunSms', 'sys_contact_type', NULL, NULL, 50, 1, 1, 1, '2019-11-19 14:32:26', 1, '2019-11-19 14:32:27', NULL, 0);
INSERT INTO `sys_dict` VALUES ('sys_contact_type@AliyunVms', 'AliyunVms', 'Aliyun电话', 'AliyunVms', 'sys_contact_type', NULL, NULL, 50, 1, 1, 1, '2019-11-19 14:32:26', 1, '2019-11-19 14:32:27', NULL, 0);
INSERT INTO `sys_dict` VALUES ('sys_contact_type@dingtalk', 'Dingtalk', '钉钉', 'Dingtalk', 'sys_contact_type', NULL, NULL, 50, 1, 1, 1, '2019-11-19 14:32:26', 1, '2019-11-19 14:32:27', NULL, 0);
INSERT INTO `sys_dict` VALUES ('sys_contact_type@email', 'Mail', '邮件', 'Email', 'sys_contact_type', NULL, NULL, 50, 1, 1, 1, '2019-11-19 14:32:26', 1, '2019-11-19 14:32:27', NULL, 0);
INSERT INTO `sys_dict` VALUES ('sys_contact_type@facebook', 'Facebook', '脸书', 'Facebook', 'sys_contact_type', NULL, NULL, 50, 1, 1, 1, '2019-11-19 14:32:26', 1, '2019-11-19 14:32:27', NULL, 0);
INSERT INTO `sys_dict` VALUES ('sys_contact_type@twitter', 'Twitter', '推特', 'Twitter', 'sys_contact_type', NULL, NULL, 50, 1, 1, 1, '2019-11-19 14:32:26', 1, '2019-11-19 14:32:27', NULL, 0);
INSERT INTO `sys_dict` VALUES ('sys_contact_type@wechat', 'WechatMp', '微信', 'Wechat', 'sys_contact_type', NULL, NULL, 50, 1, 1, 1, '2019-11-19 14:32:26', 1, '2019-11-19 14:32:27', NULL, 0);
INSERT INTO `sys_dict` VALUES ('sys_group_type@company', '2', 'Company', 'Company', 'sys_group_type', NULL, NULL, 50, 1, 1, 1, '2019-11-19 14:32:26', 1, '2019-11-19 14:32:27', NULL, 0);
INSERT INTO `sys_dict` VALUES ('sys_group_type@department', '3', 'Department', 'Department', 'sys_group_type', NULL, NULL, 50, 1, 1, 1, '2019-11-19 14:32:26', 1, '2019-11-19 14:32:27', NULL, 0);
INSERT INTO `sys_dict` VALUES ('sys_group_type@park', '1', 'Park', 'Park', 'sys_group_type', NULL, NULL, 50, 1, 1, 1, '2019-11-19 14:32:26', 1, '2019-11-19 14:32:27', NULL, 0);
INSERT INTO `sys_dict` VALUES ('sys_menu_type@dynamic', '2', '动态菜单', 'DynamicMenu', 'sys_menu_type', '', '', 50, 1, 1, 1, '2019-12-11 14:49:36', 1, '2019-12-11 14:49:40', '动态菜单类型（sys_menu表）', 0);
INSERT INTO `sys_dict` VALUES ('sys_menu_type@static', '1', '静态菜单', 'StaticMenu', 'sys_menu_type', NULL, NULL, 50, 1, 1, 1, '2019-12-11 14:49:36', 1, '2019-12-11 14:49:40', '静态菜单类型（sys_menu表）', 0);
INSERT INTO `sys_dict` VALUES ('theme_type@danger', 'danger', '严重', 'danger', 'theme_type', 'danger', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:20', '皮肤主题（严重）', 0);
INSERT INTO `sys_dict` VALUES ('theme_type@gray', 'gray', '灰色', 'gray', 'theme_type', 'gray', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '皮肤主题（灰色）', 0);
INSERT INTO `sys_dict` VALUES ('theme_type@primary', 'primary', '主要', 'primary', 'theme_type', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '皮肤主题（主要）', 0);
INSERT INTO `sys_dict` VALUES ('theme_type@success', 'success', '成功', 'success', 'theme_type', 'success', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '皮肤主题（成功）', 0);
INSERT INTO `sys_dict` VALUES ('theme_type@warning', 'warning', '警告', 'warning', 'theme_type', 'warning', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '皮肤主题（警告）', 0);
INSERT INTO `sys_dict` VALUES ('umc_engine_status@running', '2', '运行中', 'Running', 'umc_engine_status', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('umc_engine_status@stop', '0', '停止', 'Stop', 'umc_engine_status', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('umc_engine_status@wait', '1', '等待', 'Wait', 'umc_engine_status', NULL, NULL, 50, 1, 1, 1, '2019-11-07 15:47:27', 1, '2019-11-07 15:47:30', NULL, 0);
INSERT INTO `sys_dict` VALUES ('vcs_auth_type@password', '1', 'Password', 'Password', 'vcs_auth_type', '', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', NULL, 0);
INSERT INTO `sys_dict` VALUES ('vcs_auth_type@ssh', '2', 'Ssh', 'Ssh', 'vcs_auth_type', '', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('vcs_provider@alicode', 'alicode', 'Alicode', 'Alicode', 'vcs_provider', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('vcs_provider@bitbucket', 'bitbucket', 'Bitbucket', 'Bitbucket', 'vcs_provider', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', NULL, 0);
INSERT INTO `sys_dict` VALUES ('vcs_provider@coding', 'coding', 'Coding', 'Coding', 'vcs_provider', 'primary', '', 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('vcs_provider@gitee', 'gitee', 'Gitee', 'Gitee', 'vcs_provider', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('vcs_provider@github', 'github', 'Github', 'Github', 'vcs_provider', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
INSERT INTO `sys_dict` VALUES ('vcs_provider@gitlab', 'gitlab', 'Gitlab', 'Gitlab', 'vcs_provider', 'primary', NULL, 50, 1, 1, 1, '2019-08-13 15:10:32', 1, '2019-08-16 08:56:21', '', 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` bigint(25) NOT NULL,
  `name_en` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '用户角色名，与displayName灵活应用',
  `name_zh` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '用户角色展示名',
  `type` int(1) DEFAULT NULL COMMENT '菜单类型, (e.g 1静态菜单,2动态菜单,3按钮...参考字典)',
  `classify` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '分类类型',
  `level` int(1) NOT NULL DEFAULT '1' COMMENT '级别,顶级=1 , 菜单为0级',
  `status` int(1) NOT NULL DEFAULT '0' COMMENT '菜单状态(e.g 启用,禁用)',
  `parent_id` bigint(25) NOT NULL COMMENT '父级菜单ID ,顶级的父级id为0',
  `permission` varchar(500) COLLATE utf8_bin NOT NULL COMMENT '权限标识（如：sys:user:edit,sys:user:view），用于如shiro-aop方法及权限校验',
  `page_location` varchar(500) COLLATE utf8_bin DEFAULT NULL COMMENT '页面地址,(例如静态菜单:/ci/task/xx.vue文件路径(不包含.vue后缀),动态菜单www.baidu.com)',
  `route_namespace` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '路由path(#后面的部分)，类似springmvc的RequestMapping("/list")，注：规定任意层级的菜单的此字段值只有一级，如：/iam或/user或/list',
  `render_target` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '渲染目标 （_self, _blank），注：当type=2动态菜单时有值',
  `icon` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '图标',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `create_by` bigint(25) NOT NULL,
  `create_date` datetime NOT NULL,
  `update_by` bigint(25) NOT NULL,
  `update_date` datetime NOT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0' COMMENT '删除状态（0:正常/1:删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='通用系统菜单（权限）表';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
BEGIN;
INSERT INTO `sys_menu` VALUES (1, 'CI/CD Deliverys', '集成交付', 1, 'classifyA', 1, 0, 0, 'uci', '/ci', '/ci', NULL, 'icon-ziyuanguanli', 30, 1, '2019-10-31 10:01:57', -1, '2020-10-26 11:05:04', 0);
INSERT INTO `sys_menu` VALUES (2, 'Monitoring Services', '监控中心', 1, 'classifyB', 1, 0, 0, 'umc', '/umc', '/umc', NULL, 'icon-jiankong', 20, 1, '2019-10-31 10:01:57', -1, '2020-10-26 11:05:02', 0);
INSERT INTO `sys_menu` VALUES (4, 'Distributed Configuration', '配置中心', 1, 'classifyG', 1, 0, 0, 'ucm', '/scm', '/scm', NULL, 'icon-peizhizhongxin', 40, 1, '2019-10-31 17:25:49', -1, '2020-11-12 13:47:14', 0);
INSERT INTO `sys_menu` VALUES (5, 'System Settings', '系统设置', 1, NULL, 1, 0, 0, 'iam', '/iam', '/iam', NULL, 'icon-xitongshezhi', 100, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:08:59', 0);
INSERT INTO `sys_menu` VALUES (6, 'CMDB Management', '资产管理', 1, 'classifyE', 1, 0, 0, 'cmdb', '/erm', '/erm', NULL, 'icon-zichanguanli', 90, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:08:54', 0);
INSERT INTO `sys_menu` VALUES (7, 'Pipelines', '任务流水线', 1, 'classifyA', 2, 0, 1, 'uci:pipeline', '/ci/pipeline/Pipeline', '/pipeline', NULL, 'icon-liushuixian', 10, 1, '2019-10-31 10:01:57', -1, '2020-10-26 11:04:50', 0);
INSERT INTO `sys_menu` VALUES (8, 'Building Scheduler', '构建计划', 1, 'classifyA', 2, 0, 1, 'uci:trigger', '/ci/trigger/Trigger', '/trigger', NULL, 'icon-zhixingjihua', 40, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:06:19', 0);
INSERT INTO `sys_menu` VALUES (9, 'Run Records', '运行记录', 1, 'classifyA', 2, 0, 1, 'uci:pipehisdir', '', '/pipehisdir', NULL, 'icon-yunxingrizhi', 30, 1, '2019-11-01 15:54:37', -1, '2020-10-28 10:58:00', 0);
INSERT INTO `sys_menu` VALUES (10, 'Project Configuration', '项目配置', 1, 'classifyA', 2, 0, 1, 'uci:projectconfig', '', '/projectconfig', NULL, 'icon-chakanyilaiguanxishu', 50, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:06:30', 0);
INSERT INTO `sys_menu` VALUES (11, 'Online Users', '在线用户', 1, 'classifyJ', 2, 0, 5, 'iam:online', '/iam/online/Online', '/online', NULL, 'icon-zaixianyonghu', 20, 1, '2019-10-31 10:01:57', -1, '2020-10-26 11:12:56', 0);
INSERT INTO `sys_menu` VALUES (12, 'Users', '用户管理', 1, 'classifyJ', 2, 0, 5, 'iam:user', '/iam/user/User', '/user', NULL, 'icon-yonghuguanli', 30, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:12:59', 0);
INSERT INTO `sys_menu` VALUES (13, 'Menus', '菜单配置', 1, 'classifyJ', 2, 0, 5, 'iam:menu', '/iam/menu/Menu', '/menu', NULL, 'icon-caidan', 60, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:13:38', 0);
INSERT INTO `sys_menu` VALUES (14, 'Organizations', '组织机构', 1, 'classifyJ', 2, 0, 5, 'iam:organization', '/iam/organization/Organization', '/organization', NULL, 'icon-organization', 50, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:13:07', 0);
INSERT INTO `sys_menu` VALUES (15, 'Roles', '角色管理', 1, 'classifyJ', 2, 0, 5, 'iam:role', '/iam/role/Role', '/role', NULL, 'icon-jiaoseguanli', 40, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:13:03', 0);
INSERT INTO `sys_menu` VALUES (16, 'Configure', '配置列表', 1, 'classifyG', 2, 0, 4, 'ucm:configuration', '/scm/configuration/Configuration', '/configuration', NULL, 'icon-yonghupeizhi', 801, 1, '2019-11-01 15:54:37', 1, '2020-08-26 12:40:27', 0);
INSERT INTO `sys_menu` VALUES (17, 'Historical Versions', '发布版本', 1, 'classifyG', 2, 0, 4, 'ucm:historic', '/scm/historic/Historic', '/historic', NULL, 'icon-fabu', 802, 1, '2019-11-01 15:54:37', 1, '2020-08-26 12:40:34', 0);
INSERT INTO `sys_menu` VALUES (18, 'Push Tracks', '推送轨迹', 1, 'classifyG', 2, 0, 4, 'ucm:track', '/scm/track/Track', '/track', NULL, 'icon-bianpaixin', 803, 1, '2019-11-01 15:54:37', 1, '2020-08-26 12:40:40', 0);
INSERT INTO `sys_menu` VALUES (19, 'APP Cluster', '集群管理', 1, 'classifyE', 3, 0, 52752528, 'cmdb:cluster', '/erm/cluster/Cluster', '/cluster', NULL, 'icon-jiqun', 10, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:09:47', 0);
INSERT INTO `sys_menu` VALUES (20, 'Dictionaries', '字典配置', 1, 'classifyJ', 2, 0, 5, 'iam:dict', '/iam/dict/Dict', '/dict', NULL, 'icon-zidianguanli', 70, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:13:34', 0);
INSERT INTO `sys_menu` VALUES (21, 'Notifications', '通知设置', 1, 'classifyJ', 2, 0, 5, 'iam:contact', '/iam/contact/Contact', '/contact', NULL, 'icon-lianxiren', 10, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:12:51', 0);
INSERT INTO `sys_menu` VALUES (22, 'Log Console', '日志控制台', 1, 'classifyE', 3, 0, 18148396, 'cmdb:console', '/erm/console/Console', '/console', NULL, 'icon-yunxingrizhi', 10, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:09:30', 0);
INSERT INTO `sys_menu` VALUES (23, 'SBA Monitor', 'SBA监控', 2, 'classifyB', 2, 0, 2, 'umc:sbamonitor', 'http://10.0.0.160:17062/umc-collector/', '/sbamonitor', NULL, 'icon-jiankong', 30, 1, '2019-11-01 15:54:37', 1, '2021-03-14 00:31:54', 0);
INSERT INTO `sys_menu` VALUES (24, 'Biz Traffic', '业务流量', 1, 'classifyB', 2, 0, 2, 'umc:biztraffic', '/umc/biztraffic/Biztraffic', '/biztraffic', NULL, 'icon-liuliang', 10, 1, '2019-11-01 15:54:37', 1, '2021-03-13 19:31:03', 0);
INSERT INTO `sys_menu` VALUES (25, 'Alarm Logs', '告警事件', 1, 'classifyB', 2, 0, 61481, 'umc:record', '/umc/record/Record', '/record', NULL, 'icon-alarm', 10, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:04:15', 0);
INSERT INTO `sys_menu` VALUES (26, 'Rules Config', '规则配置', 1, 'classifyB', 2, 0, 61481, 'umc:config', '/umc/config/Config', '/config', NULL, 'icon-gaojingshezhi', 20, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:04:19', 0);
INSERT INTO `sys_menu` VALUES (27, 'Alarm Template', '规则模板', 1, 'classifyB', 2, 0, 61481, 'umc:templat', '/umc/templat/Templat', '/templat', NULL, 'icon-moban', 30, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:04:31', 0);
INSERT INTO `sys_menu` VALUES (28, 'Metric Template', '度量字典', 1, 'classifyB', 2, 0, 61481, 'umc:metrictemplate', '/umc/metrictemplate/MetricTemplate', '/metrictemplate', NULL, 'icon-duliang', 40, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:04:36', 0);
INSERT INTO `sys_menu` VALUES (32, 'Repositorys', '源码仓库', 1, 'classifyE', 2, 0, 54, 'urm:repository', '/vcs/repository/Repository', '/repository', NULL, 'icon-cangku', 10, 1, '2019-10-31 10:01:57', -1, '2020-10-28 10:28:10', 0);
INSERT INTO `sys_menu` VALUES (33, 'Home', '主页', 1, 'classifyE', 1, 0, 0, 'home', '', '/home', NULL, 'icon-zhuye', 10, 1, '2019-11-26 10:42:01', -1, '2020-10-26 11:04:58', 0);
INSERT INTO `sys_menu` VALUES (34, 'Overview', '概览', 1, 'classifyE', 2, 0, 33, 'home:overview', '/home/overview/Overview', '/overview', NULL, 'icon-gailan', 10, 1, '2019-11-26 10:42:33', -1, '2020-10-26 17:00:23', 0);
INSERT INTO `sys_menu` VALUES (35, 'Hosts', '主机管理', 1, 'classifyE', 3, 0, 18148395, 'cmdb:host', '/erm/host/Host', '/host', NULL, 'icon-host', 10, 1, '2019-11-26 18:10:09', -1, '2020-10-26 11:11:17', 0);
INSERT INTO `sys_menu` VALUES (36, 'Safety Quality', '安全与质量', 1, 'classifyD', 2, 0, 1, 'uci:analysis', '', '/analysis', NULL, 'icon-zhiliang', 70, 1, '2019-12-04 11:21:38', -1, '2020-10-26 11:06:57', 0);
INSERT INTO `sys_menu` VALUES (40, 'PackageAnalyzer', '安装包分析', 2, 'classifyD', 3, 0, 36, 'uci:analysis:package', 'https://www.baidu.com/', '/package', NULL, '', 10, 1, '2019-12-17 10:00:05', -1, '2020-10-26 11:07:01', 0);
INSERT INTO `sys_menu` VALUES (41, 'CodeAnalyzer', '源码分析', 2, 'classifyD', 3, 0, 36, 'uci:analysis:code', 'https://fanyi.baidu.com/', '/code', NULL, '', 20, 1, '2019-12-17 10:00:32', -1, '2020-10-26 11:07:06', 0);
INSERT INTO `sys_menu` VALUES (46, 'Project Coordinations', '项目协作', 1, 'classifyA', 2, 0, 1, 'uci:pcm', '/ci/pcm/Pcm', '/pcm', NULL, 'icon-pcm', 60, 1, '2019-10-31 10:01:57', -1, '2020-10-26 11:06:51', 0);
INSERT INTO `sys_menu` VALUES (47, 'Docs Management', '文档管理', 1, 'classifyH', 1, 0, 0, 'doc', '/doc', '/doc', NULL, 'icon-wendangguanli-xiangmuleiwendang', 60, 1, '2019-11-01 15:54:37', 1, '2021-03-13 19:22:51', 0);
INSERT INTO `sys_menu` VALUES (48, 'Files', '文件管理', 1, 'classifyH', 2, 0, 47, 'udm:file', '/doc/file/File', '/file', NULL, 'icon-gongju4', 601, 1, '2019-11-01 15:54:37', 1, '2021-03-13 20:30:12', 0);
INSERT INTO `sys_menu` VALUES (49, 'Shares', '分享管理', 1, 'classifyH', 2, 0, 47, 'udm:share', '/doc/share/Share', '/share', NULL, 'icon-fenxiang3', 602, 1, '2019-11-01 15:54:37', 1, '2020-08-26 12:39:03', 0);
INSERT INTO `sys_menu` VALUES (50, 'Labels', '标签管理', 1, 'classifyH', 2, 0, 47, 'udm:label', '/doc/label/Label', '/label', NULL, 'icon-clip', 603, 1, '2019-11-01 15:54:37', 1, '2020-08-26 12:39:07', 0);
INSERT INTO `sys_menu` VALUES (51, 'Orchestrations', '任务编排', 1, 'classifyA', 2, 0, 1, 'uci:orchestration', '/ci/orchestration/Orchestration', '/orchestration', NULL, 'icon-yonghupeizhi', 20, 1, '2019-10-31 10:01:57', -1, '2020-10-26 11:05:21', 0);
INSERT INTO `sys_menu` VALUES (52, 'Object Storage Services', '对象存储', 1, 'classifyE', 1, 0, 0, 'coss', '/coss', '/coss', NULL, 'icon-duixiangcunchuOSS', 70, 1, '2019-11-01 15:54:37', 1, '2021-03-11 22:04:05', 0);
INSERT INTO `sys_menu` VALUES (53, 'Buckets', 'Bucket管理', 1, 'classifyF', 2, 0, 52, 'coss:bucket', '/coss/bucket/BucketWrapper', '/bucket', NULL, 'icon-Bucket', 10, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:07:49', 0);
INSERT INTO `sys_menu` VALUES (54, 'Repo Manangement', '仓库管理', 1, 'classifyE', 1, 0, 0, 'vcs', '/vcs', '/vcs', NULL, 'icon-gailan', 80, 1, '2019-10-31 10:01:57', 1, '2021-03-13 20:39:02', 0);
INSERT INTO `sys_menu` VALUES (101, 'Project Dependencies', '依赖关系', 1, 'classifyA', 3, 0, 10, 'uci:project', '/ci/project/Project', '/project', NULL, 'icon-chakanyilaiguanxishu', 20, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:06:43', 0);
INSERT INTO `sys_menu` VALUES (102, 'ClusterExtension', '集群配置', 1, 'classifyA', 3, 0, 10, 'uci:clusterextension', '/ci/clusterextension/ClusterExtension', '/clusterextension', NULL, 'icon-jiqun', 10, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:06:39', 0);
INSERT INTO `sys_menu` VALUES (103, 'Developer Center', '开发中心', 1, NULL, 1, 0, 0, 'udc', '/dts', '/dts', NULL, 'icon-ziyuanguanli', 50, 1, '2019-10-31 10:01:57', 1, '2021-03-13 19:22:41', 0);
INSERT INTO `sys_menu` VALUES (13582, 'Rule Engine', '规则引擎', 1, 'classifyB', 3, 0, 85782, 'umc:custom:engine', '/umc/engine/Engine', '/engine', '_self', 'icon-wenjian', 10, 1, '2020-03-27 12:59:53', -1, '2020-10-26 11:01:06', 0);
INSERT INTO `sys_menu` VALUES (36327, 'DataSource', '数据源配置', 1, 'classifyB', 3, 0, 85782, 'umc:custom:datasource', '/umc/datasource/DataSource', '/datasource', '_self', 'icon-lishiguiji', 40, 1, '2020-03-27 12:54:38', -1, '2020-10-26 11:01:38', 0);
INSERT INTO `sys_menu` VALUES (36328, 'Event', '触发事件', 1, 'classifyB', 3, 0, 85782, 'umc:alarm:event', '/umc/alarmevent/AlarmEvent', '/event', '_self', 'icon-lishiguiji', 30, 1, '2020-03-27 12:54:38', -1, '2020-10-26 11:01:32', 0);
INSERT INTO `sys_menu` VALUES (36329, 'History', '监控记录', 1, 'classifyB', 3, 0, 85782, 'umc:custom:history', '/umc/history/History', '/history', '_self', 'icon-lishiguiji', 20, 1, '2020-03-27 12:54:38', -1, '2020-10-26 11:01:23', 0);
INSERT INTO `sys_menu` VALUES (61481, 'Service Monitoring', '服务监控', 1, 'classifyB', 2, 0, 2, 'umc:service', '', '/service', '_self', 'icon-host', 50, 1, '2020-03-27 13:01:40', 1, '2021-03-13 19:30:45', 0);
INSERT INTO `sys_menu` VALUES (85782, 'Custom Monitoring', '自定义监控', 1, 'classifyB', 2, 0, 2, 'umc:custom', '', '/custom', '_self', 'icon-zidianguanli', 40, 1, '2020-03-27 12:50:42', 1, '2021-03-13 19:30:51', 0);
INSERT INTO `sys_menu` VALUES (85783, 'Netcards', '网卡管理', 1, 'classifyE', 3, 0, 18148395, 'cmdb:netcard', '/erm/hostnetcard/HostNetcard', '/hostnetcard', NULL, 'icon-yunxingrizhi', 20, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:11:20', 0);
INSERT INTO `sys_menu` VALUES (85784, 'IDC', 'IDC管理', 1, 'classifyE', 3, 0, 18148395, 'cmdb:idc', '/erm/idc/Idc', '/idc', NULL, 'icon-IDCjifang', 40, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:11:28', 0);
INSERT INTO `sys_menu` VALUES (85785, 'SSH Keys', 'SSH密钥', 1, 'classifyE', 3, 0, 18148395, 'cmdb:ssh', '/erm/ssh/Ssh', '/ssh', NULL, 'icon-miyao42', 30, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:11:24', 0);
INSERT INTO `sys_menu` VALUES (85786, 'Docker Clusters', 'Docker集群', 1, 'classifyE', 2, 0, 9425589, 'cmdb:dockercluster', '/erm/dockercluster/DockerCluster', '/dockercluster', NULL, 'icon-docker', 10, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:10:45', 0);
INSERT INTO `sys_menu` VALUES (85787, 'K8s Clusters', 'K8s集群', 1, 'classifyE', 2, 0, 9425589, 'cmdb:k8scluster', '/erm/k8scluster/K8sCluster', '/k8scluster', NULL, 'icon-application', 30, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:10:52', 0);
INSERT INTO `sys_menu` VALUES (85788, 'APP Instances', '实例配置', 1, 'classifyB', 3, 0, 52752528, 'cmdb:instance', '/erm/instance/Instance', '/instance', NULL, 'icon-yunxingrizhi', 20, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:09:57', 0);
INSERT INTO `sys_menu` VALUES (185786, 'Image Repositorys', '镜像仓库', 1, 'classifyE', 2, 0, 9425589, 'cmdb:dockerrepository', '/erm/dockerrepository/DockerRepository', '/dockerrepository', NULL, 'icon-docker', 20, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:10:48', 0);
INSERT INTO `sys_menu` VALUES (1857861, 'PriivateZone', '私有域名', 1, 'classifyC', 2, 0, 18148397, 'cmdb:dnsprivatedomain', '/erm/dnsprivatedomain/DnsPrivateDomain', '/dnsprivatedomain', NULL, 'icon-docker', 10, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:11:44', 0);
INSERT INTO `sys_menu` VALUES (1857862, 'Cluster', '网关集群', 1, 'classifyC', 2, 0, 18148398, 'gw:gateway', '/gw/gateway/Gateway', '/gateway', NULL, 'icon-docker', 10, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:12:23', 0);
INSERT INTO `sys_menu` VALUES (1857863, 'Upsterm', '上游', 2, 'classifyC', 2, 0, 1857864, 'gw:upstream', '/gw/upstream/Upstream', '/upstream', NULL, 'icon-docker', 10, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:12:40', 0);
INSERT INTO `sys_menu` VALUES (1857864, 'Upsterm Servers', '服务器分组', 1, 'classifyC', 2, 0, 18148398, 'gw:upstreamgroup', '/gw/upstreamgroup/UpstreamGroup', '/upstreamgroup', NULL, 'icon-docker', 20, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:12:35', 0);
INSERT INTO `sys_menu` VALUES (9425555, 'Orchestration History', 'Flow运行记录', 1, 'classifyA', 3, 0, 9, 'uci:orchestrationhistory', '/ci/orchestrationhistory/OrchestrationHistory', '/orchestrationhistory', NULL, 'icon-yunxingrizhi', 20, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:06:02', 0);
INSERT INTO `sys_menu` VALUES (9425556, 'Run Records', '运行记录', 1, 'classifyA', 3, 0, 9, 'uci:pipehis', '/ci/pipehis/PipeHistory', '/pipehis', NULL, 'icon-yunxingrizhi', 10, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:05:43', 0);
INSERT INTO `sys_menu` VALUES (9425589, 'Services Cluster', '中间件服务', 1, 'classifyE', 2, 0, 6, 'cmdb:servercluster', '', '/servercluster', '_self', 'icon-ziyuan', 30, 1, '2020-06-05 15:44:28', -1, '2020-10-26 11:10:28', 0);
INSERT INTO `sys_menu` VALUES (18148395, 'Host', '主机资产', 1, 'classifyE', 2, 0, 6, 'cmdb:cmdb', '', '/cmdb', '_self', 'icon-wenjian', 40, 1, '2020-05-13 11:57:45', -1, '2020-10-26 11:10:58', 0);
INSERT INTO `sys_menu` VALUES (18148396, 'Logging', '日志服务', 1, 'classifyE', 2, 0, 6, 'cmdb:log', '', '/log', '_self', 'icon-log', 10, 1, '2020-05-13 11:57:45', -1, '2020-10-26 11:09:14', 0);
INSERT INTO `sys_menu` VALUES (18148397, 'Cloud DNS', '云解析DNS', 1, 'classifyE', 2, 0, 6, 'cmdb:domain', '', '/domain', '_self', 'icon-log', 50, 1, '2020-05-13 11:57:45', -1, '2020-10-26 11:11:40', 0);
INSERT INTO `sys_menu` VALUES (18148398, 'Gateway', '网关', 1, 'classifyE', 2, 0, 6, 'gw', '', '/gw', '_self', 'icon-log', 60, 1, '2020-05-13 11:57:45', -1, '2020-10-26 11:12:18', 0);
INSERT INTO `sys_menu` VALUES (18578611, 'PublicZone', '公有域名', 1, 'classifyC', 2, 0, 18148397, 'cmdb:dnspublicdomain', '/erm/dnspublicdomain/DnsPublicDomain', '/dnspublicdomain', NULL, 'icon-docker', 20, 1, '2019-11-01 15:54:37', -1, '2020-10-26 11:12:00', 0);
INSERT INTO `sys_menu` VALUES (52752528, 'Application Cluster', '应用集群', 1, 'classifyE', 2, 0, 6, 'cmdb:app', '', '/app', '_self', 'icon-Bucket', 20, 1, '2020-05-13 11:49:07', -1, '2020-10-26 11:09:43', 0);
INSERT INTO `sys_menu` VALUES (323144704, 'Database', '数据源', 1, 'classifyI', 3, 0, 1046376448, 'udc:codegen:database', '/dts/database/Database', '/database', '_self', 'icon-shujuyuan', 302, 1, '2020-09-08 14:50:41', 1, '2020-09-21 19:58:09', 0);
INSERT INTO `sys_menu` VALUES (323144705, 'Projects', '项目配置', 1, 'classifyI', 3, 0, 1046376448, 'udc:codegen:project', '/dts/project/Project', '/project', '_self', 'icon-wendangguanli-xiangmuleiwendang', 301, 1, '2020-09-08 14:50:41', -1, '2020-11-12 13:47:10', 0);
INSERT INTO `sys_menu` VALUES (1046376448, 'Auto Generators', '自动生成', 1, 'classifyI', 2, 0, 103, 'udc:codegen', '', '/codegen', '_self', 'icon-codeoptimizatio', 300, 1, '2020-09-08 14:45:51', -1, '2020-10-26 10:52:29', 0);
INSERT INTO `sys_menu` VALUES (1046376449, 'Code Studio', '在线开发', 2, 'classifyI', 2, 0, 103, 'udc:ide', 'https://www.baidu.com', '/ide', '_self', 'icon-weibiaoti46', 400, 1, '2020-09-08 14:45:51', -1, '2020-10-26 10:51:37', 0);
INSERT INTO `sys_menu` VALUES (1046376450, 'Online Tools', '在线工具', 2, 'classifyI', 2, 0, 103, 'udc:onlinetool', 'https://www.baidu.com', '/onlinetool', '_self', 'icon-gongju3', 500, 1, '2020-09-08 14:45:51', 1, '2020-09-21 19:59:37', 0);
INSERT INTO `sys_menu` VALUES (5148539313668096, 'Cluster Edit', '集群编辑', 3, NULL, 4, 0, 19, 'cmdb:cluster:edit', '/erm/clusteredit/ClusterEdit', '/edit', '_self', 'icon-gongju', 10, 1, '2020-10-19 11:07:56', -1, '2020-10-29 11:04:22', 0);
INSERT INTO `sys_menu` VALUES (5148843513675776, 'Pipeline Edit', '流水线编辑', 3, NULL, 0, 0, 7, 'uci:pipeline:edit', '/ci/pipelineedit/PipelineEdit', '/edit', '_self', 'icon-gongju4', 10, 1, '2020-10-19 16:17:23', -1, '2020-10-26 11:05:15', 0);
INSERT INTO `sys_menu` VALUES (5148845583302656, 'Record Detail', '记录详情', 3, NULL, 0, 0, 9425556, 'uci:pipehis:detail', '/ci/pipehisdetail/PipeHisDetail', '/detail', '_self', 'icon-gongju4', 10, 1, '2020-10-19 16:19:29', -1, '2020-10-26 11:05:49', 0);
INSERT INTO `sys_menu` VALUES (5148847007825920, 'Doc Different', '文档比较', 3, NULL, 0, 0, 48, 'udm:file:diff', '/doc/diff/Diff', '/diff', '_self', 'icon-shengchengdaima', 100, 1, '2020-10-19 16:20:56', 1, '2020-10-19 16:20:56', 0);
INSERT INTO `sys_menu` VALUES (5148847840182272, 'Doc Edit', '文档编辑', 3, NULL, 0, 0, 48, 'udm:file:edit', '/doc/mdedit/MdEdit', '/edit', '_self', 'icon-shengchengdaima', 200, 1, '2020-10-19 16:21:47', 1, '2020-10-19 16:21:47', 0);
INSERT INTO `sys_menu` VALUES (5148851468500992, 'DnsPrivateResolution', '私有域名管理', 3, NULL, 0, 0, 1857861, 'cmdb:dns:resolution', '/erm/dnsprivateresolution/DnsPrivateResolution', '/resolution', '_self', 'icon--peizhishujuyuan', 10, 1, '2020-10-19 16:25:28', -1, '2020-10-26 11:11:49', 0);
INSERT INTO `sys_menu` VALUES (5148852587610112, 'Dns Blacklist', 'DNS黑名单', 3, NULL, 0, 0, 1857861, 'cmdb:dns:blacklist', '/erm/dnsprivateblacklist/DnsPrivateBlacklist', '/blacklist', '_self', 'icon--peizhishujuyuan', 20, 1, '2020-10-19 16:26:36', -1, '2020-10-26 11:11:53', 0);
INSERT INTO `sys_menu` VALUES (5148857019875328, 'Gateway Detal', '网关详情', 3, NULL, 0, 0, 1857862, 'gw:detail', '/gw/gatewaydetail/GatewayDetail', '/detail', '_self', 'icon-gongju1', 10, 1, '2020-10-19 16:31:07', -1, '2020-10-26 11:12:28', 0);
INSERT INTO `sys_menu` VALUES (5148860410068992, 'Bucket Detail', '桶详情', 3, NULL, 0, 0, 53, 'coss:bucket:detail', '/coss/bucketdetail/BucketDetail', '/detail', '_self', '', 10, 1, '2020-10-19 16:34:34', -1, '2020-10-26 11:07:55', 0);
INSERT INTO `sys_menu` VALUES (5148861473357824, 'File Manager', '文件管理', 3, NULL, 0, 0, 53, 'coss:bucket:fs', '/coss/fs/Fs', '/fs', '_self', 'icon-biaoqianA01_gongju-269', 20, 1, '2020-10-19 16:35:39', -1, '2020-10-26 11:08:00', 0);
INSERT INTO `sys_menu` VALUES (5148863627837440, 'Engine Edit', '规则编辑', 3, NULL, 0, 0, 13582, 'umc:custom:engine:edit', '/umc/engineedit/EngineEdit', '/edit', '_self', '', 10, 1, '2020-10-19 16:37:50', -1, '2020-10-26 11:01:11', 0);
INSERT INTO `sys_menu` VALUES (5148864738459648, 'Mysql Data Source', '数据源编辑', 3, NULL, 0, 0, 36327, 'umc:custom:datasource:edit', '/umc/mysqldatasource/MysqlDataSource', '/edit', '_self', '', 10, 1, '2020-10-19 16:38:58', -1, '2020-10-26 11:01:43', 0);
INSERT INTO `sys_menu` VALUES (5148866576711680, 'Repo Project', '仓库项目', 3, NULL, 0, 0, 32, 'uci:project', '/vcs/project/Project', '/project', '_self', '', 20, 1, '2020-10-19 16:40:50', 1, '2021-03-13 20:39:46', 0);
INSERT INTO `sys_menu` VALUES (5148867512385536, 'Project Detail', '项目详情', 3, NULL, 0, 0, 5148866576711680, 'uci:project:detail', '/vcs/projectdetail/ProjectDetail', '/detail', '_self', '', 100, 1, '2020-10-19 16:41:47', 1, '2020-10-19 16:41:47', 0);
INSERT INTO `sys_menu` VALUES (5148870100566016, 'Table', '表管理', 3, NULL, 0, 0, 323144705, 'udc:table', '/dts/table/Table', '/table', '_self', '', 100, 1, '2020-10-19 16:44:25', 1, '2020-10-19 16:44:25', 0);
INSERT INTO `sys_menu` VALUES (5148871032979456, 'Table Edit', '表编辑', 3, NULL, 0, 0, 5148870100566016, 'udc:table:edit', '/dts/tableedit/TableEdit', '/edit', '_self', '', 100, 1, '2020-10-19 16:45:22', 1, '2020-10-19 16:45:22', 0);
INSERT INTO `sys_menu` VALUES (5148871832862720, 'ProjectEdit', '项目编辑', 3, NULL, 0, 0, 323144705, 'udc:project:edit', '/dts/projectedit/ProjectEdit', '/edit', '_self', '', 200, 1, '2020-10-19 16:46:11', 1, '2020-10-19 16:46:11', 0);
INSERT INTO `sys_menu` VALUES (5161231568797696, 'Orchestration Edit', '任务编排编辑', 3, NULL, 0, 0, 51, 'uci:orchestration:edit', '', '/edit', '_self', '', 100, 1, '2020-10-28 10:19:09', 1, '2020-10-28 10:19:09', 0);
INSERT INTO `sys_menu` VALUES (5161232886300672, 'Cluster Extension Edit', '集群配置编辑', 3, NULL, 0, 0, 102, 'uci:clusterextension:edit', '', '/edit', '_self', '', 100, 1, '2020-10-28 10:20:30', -1, '2020-10-28 10:21:45', 0);
INSERT INTO `sys_menu` VALUES (5161233843519488, 'Project Dependencies Edit', '依赖关系编辑', 3, NULL, 0, 0, 101, 'uci:project:edit', '', '/edit', '_self', '', 100, 1, '2020-10-28 10:21:28', 1, '2020-10-28 10:21:28', 0);
INSERT INTO `sys_menu` VALUES (5161235071549440, 'Project Coordinations Edit', '项目协作编辑', 3, NULL, 0, 0, 46, 'uci:pcm:edit', '', '/edit', '_self', '', 100, 1, '2020-10-28 10:22:43', 1, '2020-10-28 10:22:43', 0);
INSERT INTO `sys_menu` VALUES (5161677719732224, 'APP Instances Edit', '实例配置编辑', 3, NULL, 0, 0, 85788, 'cmdb:instance:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 09:53:01', -1, '2020-10-28 09:53:01', 0);
INSERT INTO `sys_menu` VALUES (5161679286878208, 'Docker Clusters Edit', 'Docker集群编辑', 3, NULL, 0, 0, 85786, 'cmdb:dockercluster:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 09:54:36', -1, '2020-10-28 09:54:36', 0);
INSERT INTO `sys_menu` VALUES (5161680018456576, 'Image Repositorys Edit', '镜像仓库编辑', 3, NULL, 0, 0, 185786, 'cmdb:dockerrepository:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 09:55:21', -1, '2020-10-28 09:55:21', 0);
INSERT INTO `sys_menu` VALUES (5161680616341504, 'K8s Clusters Edit', 'K8s集群编辑', 3, NULL, 0, 0, 85787, 'cmdb:k8scluster:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 09:55:58', -1, '2020-10-28 09:55:58', 0);
INSERT INTO `sys_menu` VALUES (5161682052612096, 'Hosts Edit', '主机管理编辑', 3, NULL, 0, 0, 35, 'cmdb:host:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 09:57:25', -1, '2020-10-28 09:57:25', 0);
INSERT INTO `sys_menu` VALUES (5161682705629184, 'Netcards Edit', '网卡管理编辑', 3, NULL, 0, 0, 85783, 'cmdb:netcard:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 09:58:05', -1, '2020-10-28 09:58:05', 0);
INSERT INTO `sys_menu` VALUES (5161683609911296, 'SSH Keys Edit', 'SSH密钥 编辑', 3, NULL, 0, 0, 85785, 'cmdb:ssh:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 09:59:00', -1, '2020-10-28 09:59:00', 0);
INSERT INTO `sys_menu` VALUES (5161684988624896, 'IDC Edit', 'IDC管理编辑', 3, NULL, 0, 0, 85784, 'cmdb:idc:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 10:00:24', -1, '2020-10-28 10:00:24', 0);
INSERT INTO `sys_menu` VALUES (5161690114539520, 'PriivateZone Edit', '私有域名编辑', 3, NULL, 0, 0, 1857861, 'cmdb:dnsprivatedomain:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 10:05:37', -1, '2020-10-28 10:05:37', 0);
INSERT INTO `sys_menu` VALUES (5161690773356544, 'PublicZone Edit', '公有域名编辑', 3, NULL, 0, 0, 18578611, 'cmdb:dnspublicdomain:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 10:06:18', -1, '2020-10-28 10:06:18', 0);
INSERT INTO `sys_menu` VALUES (5161711326986240, 'Notifications Edit', '通知设置编辑', 3, NULL, 0, 0, 21, 'iam:contact:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 10:27:12', -1, '2020-10-28 10:27:12', 0);
INSERT INTO `sys_menu` VALUES (5161717677293568, 'Users Edit', '用户管理编辑', 3, NULL, 0, 0, 12, 'iam:user:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 10:33:40', -1, '2020-10-28 10:33:40', 0);
INSERT INTO `sys_menu` VALUES (5161718880927744, 'Roles Edit', '角色管理编辑', 3, NULL, 0, 0, 15, 'iam:role:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 10:34:53', -1, '2020-10-28 10:34:53', 0);
INSERT INTO `sys_menu` VALUES (5161719690903552, 'Organizations Edit', '组织机构编辑', 3, NULL, 0, 0, 14, 'iam:organization:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 10:35:43', -1, '2020-10-28 10:35:43', 0);
INSERT INTO `sys_menu` VALUES (5161720512741376, 'Menus Edit', '菜单配置编辑', 3, NULL, 0, 0, 13, 'iam:menu:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 10:36:33', -1, '2020-10-28 10:36:33', 0);
INSERT INTO `sys_menu` VALUES (5161721178718208, 'Dictionaries Edit', '字典配置编辑', 3, NULL, 0, 0, 20, 'iam:dict:edit', '', '/edit', '_self', '', 100, -1, '2020-10-28 10:37:13', -1, '2020-10-28 10:37:13', 0);
INSERT INTO `sys_menu` VALUES (5201256340520960, 'EnterpriseApi', '接口配置', 3, 'classifyH', 2, 0, 5201256340520966, 'udm:enterpriseapi', '/doc/enterpriseapi/EnterpriseApi', '/enterpriseapi', 'NULL', 'icon-gongju3', 100, 1, '2020-09-08 14:45:51', 1, '2020-09-21 19:59:37', 0);
INSERT INTO `sys_menu` VALUES (5201256340520961, 'Documents', '文档管理', 1, 'classifyH', 2, 0, 5354342182584320, 'udm:enterprisemd', '/doc/enterprisemd/EnterpriseMd', '/enterprisemd', 'NULL', 'icon-wenjian', 20, 1, '2020-09-08 14:45:51', 1, '2021-03-13 20:29:32', 0);
INSERT INTO `sys_menu` VALUES (5201256340520966, 'APIs Docs', '接口管理', 1, 'classifyH', 2, 0, 5354342182584320, 'udm:enterpriseprojectpanel', '/doc/enterpriseprojectpanel/EnterpriseProjectPanel', '/enterpriseprojectpanel', 'NULL', 'icon-codeoptimizatio', 10, 1, '2020-09-08 14:45:51', 1, '2021-03-13 20:32:26', 0);
INSERT INTO `sys_menu` VALUES (5201256340520967, 'Doc Template', '文档模版', 1, 'classifyH', 2, 0, 5354342182584320, 'udm:enterprisetemplate', '/doc/enterprisetemplate/EnterpriseTemplate', '/enterprisetemplate', 'NULL', 'icon-gongju3', 50, 1, '2020-09-08 14:45:51', 1, '2021-03-13 20:27:11', 0);
INSERT INTO `sys_menu` VALUES (5354288238624768, 'Request Tracking', '链路追踪', 2, 'classifyB', 2, 0, 2, 'umc:trace:list', 'http://10.0.0.160:9411/zipkin/', '/tracking', '_self', 'icon-daima-fenzhi', 20, 1, '2021-03-13 19:26:34', 1, '2021-03-13 20:54:51', 0);
INSERT INTO `sys_menu` VALUES (5354342182584320, 'Application Docs', '应用文档', 1, NULL, 2, 0, 47, 'udm', '/doc/enterpriseprojectpanel/EnterpriseProjectPanel', '/udm', '_self', 'icon-zichanguanli', 5, 1, '2021-03-13 20:21:26', 1, '2021-03-13 20:25:47', 0);
INSERT INTO `sys_menu` VALUES (5354373700272128, 'Eureka Dashboard', 'Eureka仪表盘', 2, NULL, 2, 0, 2, 'umc:eureka', 'http://10.0.0.160:9001/', '/eureka', '_self', 'icon-codeoptimizatio', 25, 1, '2021-03-13 20:53:30', 1, '2021-03-14 00:36:47', 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_notification_contact
-- ----------------------------
DROP TABLE IF EXISTS `sys_notification_contact`;
CREATE TABLE `sys_notification_contact` (
  `id` bigint(25) NOT NULL,
  `record_id` bigint(25) DEFAULT NULL COMMENT '信息id',
  `contact_id` bigint(25) DEFAULT NULL COMMENT '联系人',
  `status` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT 'send , unsend , accepted , unaccepted ',
  `remark` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `notification_id` (`record_id`) USING BTREE,
  KEY `contact_id` (`contact_id`) USING BTREE,
  CONSTRAINT `sys_notification_contact_ibfk_1` FOREIGN KEY (`contact_id`) REFERENCES `sys_contact` (`id`),
  CONSTRAINT `sys_notification_contact_ibfk_2` FOREIGN KEY (`record_id`) REFERENCES `umc_alarm_record` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for sys_organization
-- ----------------------------
DROP TABLE IF EXISTS `sys_organization`;
CREATE TABLE `sys_organization` (
  `id` bigint(25) NOT NULL,
  `name_en` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '用户分租(customer）名，与displayName灵活应用',
  `name_zh` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '用户分租(customer）展示名',
  `organization_code` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '唯一标识',
  `type` int(1) NOT NULL DEFAULT '0' COMMENT '用户分组类型（预留）1park,2company,3department',
  `parent_id` bigint(25) DEFAULT NULL COMMENT '父级id',
  `parent_ids` varchar(512) COLLATE utf8_bin DEFAULT NULL COMMENT '父级路径id列表, 为减少使用时计算量提高性能(逗号分隔)',
  `area_id` bigint(25) NOT NULL COMMENT '区域id',
  `enable` int(1) NOT NULL DEFAULT '1' COMMENT '用户组启用状态（0:禁用/1:启用）',
  `status` int(1) NOT NULL DEFAULT '0' COMMENT '用户组状态（预留）',
  `create_by` bigint(25) NOT NULL,
  `create_date` datetime NOT NULL,
  `update_by` bigint(25) NOT NULL,
  `update_date` datetime NOT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0' COMMENT '删除状态（0:正常/1:删除）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `parent_id` (`parent_id`) USING BTREE,
  KEY `area_id` (`area_id`),
  FULLTEXT KEY `parent_ids` (`parent_ids`),
  CONSTRAINT `sys_organization_ibfk_1` FOREIGN KEY (`area_id`) REFERENCES `sys_area` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='通用系统用户组表';

-- ----------------------------
-- Records of sys_organization
-- ----------------------------
BEGIN;
INSERT INTO `sys_organization` VALUES (1, 'XCloudOfChina', 'XCLOUD集团(中国)有限公司', 'XCompanyOfChinaCode', 1, 6, NULL, 440100, 1, 0, 1, '2019-10-29 14:52:29', 1, '2019-11-26 14:04:16', 0);
INSERT INTO `sys_organization` VALUES (2, 'XCloudOfGz', 'GZ分公司', 'XCompanyOfGzCode', 1, 1, '1', 440100, 1, 0, 1, '2019-10-29 14:52:29', 1, '2019-11-26 14:05:05', 0);
INSERT INTO `sys_organization` VALUES (3, 'BigdataResearchDept', '大数据研发部', 'BigdataResearchDeptCode', 2, 2, '2,1', 440100, 1, 0, 1, '2019-10-29 14:52:29', 1, '2019-11-26 14:09:55', 0);
INSERT INTO `sys_organization` VALUES (4, 'BizDevDept', '应用开发部', 'BizDevDeptCode', 2, 2, '2,1', 440100, 1, 0, 1, '2019-10-29 14:52:29', 1, '2019-11-26 14:06:18', 0);
INSERT INTO `sys_organization` VALUES (5, 'DevSecOpsArch', 'DevSecOps+系统架构部', 'DevSecOpsArchCode', 2, 2, '2,1', 440100, 1, 0, 1, '2019-10-31 15:46:29', 1, '2019-11-26 14:10:19', 0);
INSERT INTO `sys_organization` VALUES (6, 'XCloud Head Office', 'XCLOUD总部', 'XCP', 0, NULL, NULL, 440100, 1, 0, 1, '2020-10-26 09:48:25', 1, '2020-10-26 09:48:47', 0);
INSERT INTO `sys_organization` VALUES (7, 'XCloud Head Office2', 'XCLOUD2总部', 'XCP2', 0, NULL, NULL, 440100, 1, 0, 1, '2020-10-26 09:48:25', 1, '2020-10-26 09:48:47', 0);
INSERT INTO `sys_organization` VALUES (8, 'XCloudOfChina2', 'XCLOUD2集团(中国)有限公司', 'XCompanyOfChinaCode2', 1, 7, NULL, 440100, 1, 0, 1, '2019-10-29 14:52:29', 1, '2019-11-26 14:04:16', 0);
INSERT INTO `sys_organization` VALUES (5154539957780480, 'ProductTestDept', '产品测试部', 'ProductTestDeptCode', 3, 2, '2,1', 440100, 1, 0, 1, '2020-10-23 16:52:06', 1, '2020-10-23 16:56:52', 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_organization_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_organization_role`;
CREATE TABLE `sys_organization_role` (
  `id` bigint(25) NOT NULL,
  `organization_id` bigint(25) NOT NULL,
  `role_id` bigint(25) NOT NULL,
  `create_by` bigint(25) NOT NULL,
  `create_date` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `group_id` (`organization_id`) USING BTREE,
  KEY `role_id` (`role_id`) USING BTREE,
  CONSTRAINT `sys_organization_role_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `sys_organization` (`id`),
  CONSTRAINT `sys_organization_role_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='通用系统group-role中间表';

-- ----------------------------
-- Records of sys_organization_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_organization_role` VALUES (5154545809080320, 5154539957780480, 2, 1, '2020-10-23 16:58:03');
INSERT INTO `sys_organization_role` VALUES (5158426906181632, 4, 1, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_organization_role` VALUES (5160261962334208, 5154539957780480, 5160261958959104, 1, '2020-10-27 17:52:49');
COMMIT;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` bigint(25) NOT NULL,
  `role_code` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '用户角色名，与displayName灵活应用',
  `name_zh` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '用户角色展示名',
  `type` int(1) DEFAULT NULL COMMENT '用户角色类型（预留）',
  `enable` int(1) NOT NULL DEFAULT '1' COMMENT '用户角色启用状态（0:禁用/1:启用）',
  `status` int(1) NOT NULL DEFAULT '0' COMMENT '用户角色状态（预留）',
  `create_by` bigint(25) NOT NULL,
  `create_date` datetime NOT NULL,
  `update_by` bigint(25) NOT NULL,
  `update_date` datetime NOT NULL,
  `del_flag` int(1) NOT NULL COMMENT '删除状态（0:正常/1:删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='通用系统角色表';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_role` VALUES (1, 'coder', '普通开发角色', 1, 1, 0, 1, '2019-10-29 11:28:03', 1, '2020-10-26 10:46:06', 0);
INSERT INTO `sys_role` VALUES (2, 'test', '普通测试角色', 1, 1, 0, 1, '2019-10-29 11:28:03', 1, '2020-10-23 16:58:03', 0);
INSERT INTO `sys_role` VALUES (3, 'devops', '系统运维研发', 1, 1, 0, 1, '2019-10-29 11:28:03', 1, '2019-11-26 14:12:27', 0);
INSERT INTO `sys_role` VALUES (5160261958959104, 'hwjtest1', 'hwjtest1', NULL, 1, 0, 1, '2020-10-27 17:52:49', 1, '2020-10-27 17:52:49', 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `id` bigint(25) NOT NULL,
  `role_id` bigint(25) DEFAULT NULL,
  `menu_id` bigint(25) DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `role_id` (`role_id`) USING BTREE,
  KEY `menu_id` (`menu_id`) USING BTREE,
  CONSTRAINT `sys_role_menu_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`),
  CONSTRAINT `sys_role_menu_ibfk_2` FOREIGN KEY (`menu_id`) REFERENCES `sys_menu` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='通用系统role-menu中间表';

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
BEGIN;
INSERT INTO `sys_role_menu` VALUES (5154545808146432, 2, NULL, 1, '2020-10-23 16:58:03');
INSERT INTO `sys_role_menu` VALUES (5154545808146433, 2, 33, 1, '2020-10-23 16:58:03');
INSERT INTO `sys_role_menu` VALUES (5154545808146434, 2, 1, 1, '2020-10-23 16:58:03');
INSERT INTO `sys_role_menu` VALUES (5154545808146435, 2, 34, 1, '2020-10-23 16:58:03');
INSERT INTO `sys_role_menu` VALUES (5154545808146436, 2, 5148845583302656, 1, '2020-10-23 16:58:03');
INSERT INTO `sys_role_menu` VALUES (5154545808146437, 2, 7, 1, '2020-10-23 16:58:03');
INSERT INTO `sys_role_menu` VALUES (5154545808146438, 2, 9, 1, '2020-10-23 16:58:03');
INSERT INTO `sys_role_menu` VALUES (5154545808146439, 2, 9425556, 1, '2020-10-23 16:58:03');
INSERT INTO `sys_role_menu` VALUES (5158426905231360, 1, 33, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905247744, 1, 1, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905264128, 1, 34, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905280512, 1, 4, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905280513, 1, 7, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905296896, 1, 8, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905313280, 1, 9, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905313281, 1, 5148847007825920, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905329664, 1, 47, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905329665, 1, 5148847840182272, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905346048, 1, 16, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905346049, 1, 48, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905346050, 1, 17, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905362432, 1, 49, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905362433, 1, 18, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905378816, 1, 50, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905378817, 1, 51, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905378818, 1, 5148845583302656, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5158426905444352, 1, 9425556, 1, '2020-10-26 10:46:06');
INSERT INTO `sys_role_menu` VALUES (5160261961711616, 5160261958959104, 33, 1, '2020-10-27 17:52:49');
INSERT INTO `sys_role_menu` VALUES (5160261961859072, 5160261958959104, 34, 1, '2020-10-27 17:52:49');
COMMIT;

-- ----------------------------
-- Table structure for sys_role_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_user`;
CREATE TABLE `sys_role_user` (
  `id` bigint(25) NOT NULL,
  `user_id` bigint(25) DEFAULT NULL,
  `role_id` bigint(25) DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `role_id` (`role_id`) USING BTREE,
  CONSTRAINT `sys_role_user_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`),
  CONSTRAINT `sys_role_user_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='通用系统user-role中间表';

-- ----------------------------
-- Records of sys_role_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_role_user` VALUES (5158359717969920, 7, 1, 1, '2020-10-26 09:37:46');
INSERT INTO `sys_role_user` VALUES (5168604758425600, 5, 2, -1, '2020-11-02 01:19:34');
COMMIT;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` bigint(25) NOT NULL,
  `user_name` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '登录账号名(唯一）',
  `name_en` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `name_zh` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '显示名称',
  `password` varchar(768) COLLATE utf8_bin NOT NULL COMMENT '密文密码',
  `pub_salt` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '认证加密盐',
  `user_type` int(1) NOT NULL DEFAULT '0' COMMENT '用户类型（保留字段）',
  `enable` int(1) NOT NULL DEFAULT '1' COMMENT '启用状态（0:禁止/1:启用）',
  `status` int(1) NOT NULL DEFAULT '0' COMMENT '用户状态（预留）',
  `email` varchar(48) COLLATE utf8_bin DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `wechat_open_id` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `wechat_union_id` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `facebook_id` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `google_id` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `twitter_id` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `linkedin_id` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `alipay_id` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `github_id` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `aws_id` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `remark` varchar(500) COLLATE utf8_bin DEFAULT NULL COMMENT '备注',
  `create_by` bigint(25) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT '0',
  `update_date` datetime DEFAULT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='通用系统用户表';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_user` VALUES (1, 'root', 'root', '系统超级管理员', '729f609cb2db3a1d50f51d658adb7f571b8ca72a7046641eae6b8824571f1bce', 'a3e0b320c73020aa81ebf87bd8611bf1', 0, 1, 0, '983708408@qq.com', '18127968606', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '系统超级管理员', 1, '2019-11-17 18:11:00', 1, '2019-11-17 18:13:34', 0);
INSERT INTO `sys_user` VALUES (2, 'wanglsir', 'wanglsir', 'wanglsir', '5d384f8be417463220e009fa57c523fe3feb345807d5983deb5193e6df1f154b43bc75d00ba47742d3b25e74f9fa0cec51e529edb4b8b61bcdfbfd21b697b1ff', 'd553592177c116c3458f02007577fc09', 0, 1, 0, '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'OWNER-wanglsir', 1, '2019-11-17 18:11:00', 1, '2020-10-29 11:12:59', 0);
INSERT INTO `sys_user` VALUES (5, 'liuxl', 'liuxl', '刘童鞋', '81d206f6f32bf1d48728fc351cdde734a658b908cac178d3ab3be6bfff9644f169548439c0ab4e5c40b834807ef5dcdbd33476f53466795ce693e61ae548cf9a', 'cb93f6efd291fbc66d59d082e4014c12', 0, 1, 0, 'zhangsan@gmail.com', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Tester-刘童鞋', 1, '2019-10-30 11:16:05', 1, '2020-10-30 08:35:41', 0);
INSERT INTO `sys_user` VALUES (7, 'hwjie', 'hwjie', '何童鞋', '9bc434a8c2fb6f0ff3d218198bc2eea4ce4376c900b1a7f752098c0aad080e2d6f8c3c3a9f9117f1840fc9584f809718', '36c9ebe0f18dfb0464f80dbc21180803', 0, 1, 0, '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PMC-何童鞋', 1, '2019-11-17 15:01:05', 1, '2020-10-29 11:12:39', 0);
INSERT INTO `sys_user` VALUES (9, 'zhangsir', 'zhangsir', '张童鞋', '1dcc3ea0d398e28b176b9d88ddfc5d16cf251badda7717afacebebb017424c9b', '16eee4e2e220622aa8977c8e7c1a0cdc', 0, 1, 0, 'zhangsan@163.com', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PMC-张童鞋', 1, '2019-11-27 17:53:32', 1, '2020-10-29 11:13:27', 0);
INSERT INTO `sys_user` VALUES (10, 'lisir', 'lisir', '李童鞋', '668f12a45c135cffe9b09ceb215850f9cf86f015d1ab1edb26228d46102ed894545968fe9df052678085d8df25bb1fe7', '090a2655e2eb1b5a078117d822eadd18', 0, 1, 0, '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PMC-李童鞋', 1, '2019-11-28 14:59:30', 1, '2020-10-29 11:11:44', 0);
INSERT INTO `sys_user` VALUES (11, 'zhangsan', 'zhangsan', '张三', '2f4263193a702976b41d80853e08b5d25af77cab02bcaa265c746705dc7f4588a2bd6b09f436e8c90ecb0531545bdcfb5c49b2b298312903807bfb4cf8913ed0', '2babcadf7f5687ae636c737cdf6d4233', 0, 1, 0, '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'demo', 1, '2019-11-28 15:21:12', 1, '2020-10-29 11:13:37', 0);
COMMIT;

-- ----------------------------
-- Table structure for uci_analysis_history
-- ----------------------------
DROP TABLE IF EXISTS `uci_analysis_history`;
CREATE TABLE `uci_analysis_history` (
  `id` bigint(25) NOT NULL,
  `project_id` bigint(25) NOT NULL,
  `analyzer_kind` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '分析引擎',
  `language` varchar(30) COLLATE utf8_bin NOT NULL COMMENT 'e.g: java',
  `asset_version` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT '0.0.0' COMMENT '资产(源码)文件版本号',
  `asset_bytes` int(11) NOT NULL DEFAULT '0' COMMENT '资产(源码)文件总字节数',
  `asset_analysis_size` int(11) DEFAULT '0' COMMENT '已扫描的资产(源码)文件数量',
  `state` int(1) NOT NULL COMMENT '(扫描)分析任务状态(对应sys_dict)，如：new/waiting/scan/analyzing/done',
  `bug_collection_file` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '扫描结果文件路径',
  `create_date` datetime NOT NULL,
  `update_date` datetime NOT NULL,
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `project_id` (`project_id`) USING BTREE,
  CONSTRAINT `uci_analysis_history_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `uci_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='代码扫描(记录)历史表';

-- ----------------------------
-- Table structure for uci_cluster_extension
-- ----------------------------
DROP TABLE IF EXISTS `uci_cluster_extension`;
CREATE TABLE `uci_cluster_extension` (
  `id` bigint(25) NOT NULL,
  `cluster_id` bigint(25) NOT NULL,
  `default_env` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `default_branch` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_dependency
-- ----------------------------
DROP TABLE IF EXISTS `uci_dependency`;
CREATE TABLE `uci_dependency` (
  `id` bigint(25) NOT NULL,
  `project_id` bigint(25) DEFAULT NULL,
  `dependent_id` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pk_ci_denpendency_project_id` (`project_id`) USING BTREE,
  KEY `ok_ci_denpendency_dependent_id` (`dependent_id`) USING BTREE,
  CONSTRAINT `uci_dependency_ibfk_1` FOREIGN KEY (`dependent_id`) REFERENCES `uci_project` (`id`),
  CONSTRAINT `uci_dependency_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `uci_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_orchestration
-- ----------------------------
DROP TABLE IF EXISTS `uci_orchestration`;
CREATE TABLE `uci_orchestration` (
  `id` bigint(25) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `type` int(255) DEFAULT NULL COMMENT '编排的类型:1原生编排(即不用容器和k8的编排) 2底层调用k8编排',
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_orchestration_history
-- ----------------------------
DROP TABLE IF EXISTS `uci_orchestration_history`;
CREATE TABLE `uci_orchestration_history` (
  `id` bigint(25) NOT NULL,
  `run_id` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `status` int(2) DEFAULT NULL,
  `info` text COLLATE utf8_bin,
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  `cost_time` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_orchestration_pipeline
-- ----------------------------
DROP TABLE IF EXISTS `uci_orchestration_pipeline`;
CREATE TABLE `uci_orchestration_pipeline` (
  `id` bigint(25) NOT NULL,
  `orchestration_id` bigint(25) DEFAULT NULL,
  `pipeline_id` bigint(25) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_pcm
-- ----------------------------
DROP TABLE IF EXISTS `uci_pcm`;
CREATE TABLE `uci_pcm` (
  `id` bigint(25) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `provider_kind` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '类型: redmine,jira等,从字典获取',
  `base_url` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '接口请求地址',
  `auth_type` int(1) DEFAULT NULL COMMENT '认证方式,1账号密码,2密钥',
  `access_token` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '密钥',
  `username` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '密码',
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_pipe_history
-- ----------------------------
DROP TABLE IF EXISTS `uci_pipe_history`;
CREATE TABLE `uci_pipe_history` (
  `id` bigint(25) NOT NULL,
  `pipe_id` bigint(25) NOT NULL,
  `provider_kind` varchar(32) COLLATE utf8_bin NOT NULL,
  `status` int(2) DEFAULT NULL,
  `sha_local` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `ref_id` bigint(25) DEFAULT NULL COMMENT '回滚来自哪个历史版本',
  `cost_time` bigint(20) DEFAULT NULL,
  `track_type` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '跟踪类型：新建、BUG、迭代、反馈',
  `track_id` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '跟踪id',
  `annex` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `remark` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  `orchestration_type` int(11) DEFAULT NULL,
  `orchestration_id` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pipe_id` (`pipe_id`) USING BTREE,
  CONSTRAINT `uci_pipe_history_ibfk_1` FOREIGN KEY (`pipe_id`) REFERENCES `uci_pipeline` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_pipe_history_instance
-- ----------------------------
DROP TABLE IF EXISTS `uci_pipe_history_instance`;
CREATE TABLE `uci_pipe_history_instance` (
  `id` bigint(25) NOT NULL,
  `pipe_history_id` bigint(25) NOT NULL,
  `instance_id` bigint(25) NOT NULL,
  `status` int(2) DEFAULT NULL,
  `create_date` datetime NOT NULL,
  `cost_time` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pipe_history_id` (`pipe_history_id`) USING BTREE,
  CONSTRAINT `uci_pipe_history_instance_ibfk_1` FOREIGN KEY (`pipe_history_id`) REFERENCES `uci_pipe_history` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_pipe_history_pcm
-- ----------------------------
DROP TABLE IF EXISTS `uci_pipe_history_pcm`;
CREATE TABLE `uci_pipe_history_pcm` (
  `id` bigint(25) NOT NULL,
  `pipe_history_id` bigint(25) NOT NULL,
  `step_pcm_id` bigint(25) DEFAULT NULL,
  `x_parent_issue_id` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `x_tracker` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `x_status` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `x_subject` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `x_description` text COLLATE utf8_bin,
  `x_priority` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `x_assign_to` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `x_start_date` datetime DEFAULT NULL,
  `x_expected_time` bigint(20) DEFAULT NULL,
  `x_custom_fields` text COLLATE utf8_bin,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pcm_id` (`step_pcm_id`) USING BTREE,
  KEY `pipe_history_id` (`pipe_history_id`) USING BTREE,
  CONSTRAINT `uci_pipe_history_pcm_ibfk_1` FOREIGN KEY (`step_pcm_id`) REFERENCES `uci_pcm` (`id`),
  CONSTRAINT `uci_pipe_history_pcm_ibfk_2` FOREIGN KEY (`pipe_history_id`) REFERENCES `uci_pipe_history` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_pipe_step_analysis
-- ----------------------------
DROP TABLE IF EXISTS `uci_pipe_step_analysis`;
CREATE TABLE `uci_pipe_step_analysis` (
  `id` bigint(25) NOT NULL,
  `pipe_id` bigint(25) NOT NULL,
  `enable` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pipe_id` (`pipe_id`) USING BTREE,
  CONSTRAINT `uci_pipe_step_analysis_ibfk_1` FOREIGN KEY (`pipe_id`) REFERENCES `uci_pipeline` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_pipe_step_api
-- ----------------------------
DROP TABLE IF EXISTS `uci_pipe_step_api`;
CREATE TABLE `uci_pipe_step_api` (
  `id` bigint(20) NOT NULL,
  `pipe_id` bigint(20) NOT NULL,
  `enable` int(2) NOT NULL,
  `repository_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='UCI构建管道阶段之api构建配置表(自动构建部署应用的同时更新swagger-api文档到UDM(文档管理中心))';

-- ----------------------------
-- Table structure for uci_pipe_step_building
-- ----------------------------
DROP TABLE IF EXISTS `uci_pipe_step_building`;
CREATE TABLE `uci_pipe_step_building` (
  `id` bigint(25) NOT NULL,
  `pipe_id` bigint(25) NOT NULL,
  `pre_command` text COLLATE utf8_bin,
  `post_command` text COLLATE utf8_bin,
  `ref_type` int(2) DEFAULT NULL COMMENT '1branch,2tag',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pipe_id` (`pipe_id`) USING BTREE,
  CONSTRAINT `uci_pipe_step_building_ibfk_1` FOREIGN KEY (`pipe_id`) REFERENCES `uci_pipeline` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_pipe_step_building_project
-- ----------------------------
DROP TABLE IF EXISTS `uci_pipe_step_building_project`;
CREATE TABLE `uci_pipe_step_building_project` (
  `id` bigint(25) NOT NULL,
  `building_id` bigint(25) NOT NULL,
  `project_id` bigint(25) NOT NULL,
  `build_command` text COLLATE utf8_bin,
  `ref` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `enable` int(2) DEFAULT NULL,
  `sort` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `building_id` (`building_id`) USING BTREE,
  KEY `project_id` (`project_id`) USING BTREE,
  CONSTRAINT `uci_pipe_step_building_project_ibfk_1` FOREIGN KEY (`building_id`) REFERENCES `uci_pipe_step_building` (`id`),
  CONSTRAINT `uci_pipe_step_building_project_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `uci_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_pipe_step_deploy
-- ----------------------------
DROP TABLE IF EXISTS `uci_pipe_step_deploy`;
CREATE TABLE `uci_pipe_step_deploy` (
  `id` bigint(25) NOT NULL,
  `pipe_id` bigint(25) NOT NULL,
  `deploy_type` int(2) NOT NULL COMMENT 'host,container,k8s,coss|cdn',
  `deploy_dockerfile_content` text COLLATE utf8_bin COMMENT 'dockerfile',
  `deploy_config_type` int(2) DEFAULT NULL COMMENT '是官方配置还是自研配置',
  `deploy_config_content` text COLLATE utf8_bin COMMENT '例如:k8s-configmap',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_pipe_step_deploy_instance
-- ----------------------------
DROP TABLE IF EXISTS `uci_pipe_step_deploy_instance`;
CREATE TABLE `uci_pipe_step_deploy_instance` (
  `id` bigint(25) NOT NULL,
  `deploy_id` bigint(25) NOT NULL,
  `instance_id` bigint(25) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `instance_id` (`instance_id`) USING BTREE,
  KEY `deploy_id` (`deploy_id`) USING BTREE,
  CONSTRAINT `uci_pipe_step_deploy_instance_ibfk_1` FOREIGN KEY (`instance_id`) REFERENCES `cmdb_app_instance` (`id`),
  CONSTRAINT `uci_pipe_step_deploy_instance_ibfk_2` FOREIGN KEY (`deploy_id`) REFERENCES `uci_pipe_step_deploy` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_pipe_step_deploy_instance_command
-- ----------------------------
DROP TABLE IF EXISTS `uci_pipe_step_deploy_instance_command`;
CREATE TABLE `uci_pipe_step_deploy_instance_command` (
  `id` bigint(25) NOT NULL,
  `pipe_id` bigint(25) DEFAULT NULL,
  `pre_command` text COLLATE utf8_bin,
  `post_command` text COLLATE utf8_bin,
  `enable` int(2) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pipe_id` (`pipe_id`) USING BTREE,
  CONSTRAINT `uci_pipe_step_deploy_instance_command_ibfk_1` FOREIGN KEY (`pipe_id`) REFERENCES `uci_pipeline` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_pipe_step_notification
-- ----------------------------
DROP TABLE IF EXISTS `uci_pipe_step_notification`;
CREATE TABLE `uci_pipe_step_notification` (
  `id` bigint(25) NOT NULL,
  `pipe_id` bigint(25) NOT NULL,
  `enable` int(2) DEFAULT NULL,
  `contact_group_ids` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '联系人分组,逗号分隔',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pipe_id` (`pipe_id`) USING BTREE,
  CONSTRAINT `uci_pipe_step_notification_ibfk_1` FOREIGN KEY (`pipe_id`) REFERENCES `uci_pipeline` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_pipe_step_pcm
-- ----------------------------
DROP TABLE IF EXISTS `uci_pipe_step_pcm`;
CREATE TABLE `uci_pipe_step_pcm` (
  `id` bigint(25) NOT NULL,
  `enable` int(2) NOT NULL,
  `pipe_id` bigint(25) NOT NULL,
  `pcm_id` bigint(25) DEFAULT NULL,
  `x_project_id` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `x_tracker` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `x_status` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `x_priority` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `x_assign_to` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `x_custom_fields` text COLLATE utf8_bin,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pipe_id` (`pipe_id`) USING BTREE,
  KEY `pcm_id` (`pcm_id`) USING BTREE,
  CONSTRAINT `uci_pipe_step_pcm_ibfk_1` FOREIGN KEY (`pipe_id`) REFERENCES `uci_pipeline` (`id`),
  CONSTRAINT `uci_pipe_step_pcm_ibfk_2` FOREIGN KEY (`pcm_id`) REFERENCES `uci_pcm` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_pipe_step_testing
-- ----------------------------
DROP TABLE IF EXISTS `uci_pipe_step_testing`;
CREATE TABLE `uci_pipe_step_testing` (
  `id` bigint(25) NOT NULL,
  `pipe_id` bigint(25) NOT NULL,
  `enable` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pipe_id` (`pipe_id`) USING BTREE,
  CONSTRAINT `uci_pipe_step_testing_ibfk_1` FOREIGN KEY (`pipe_id`) REFERENCES `uci_pipeline` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_pipeline
-- ----------------------------
DROP TABLE IF EXISTS `uci_pipeline`;
CREATE TABLE `uci_pipeline` (
  `id` bigint(25) NOT NULL,
  `pipe_name` varchar(32) COLLATE utf8_bin NOT NULL,
  `cluster_id` bigint(25) NOT NULL,
  `provider_kind` varchar(32) COLLATE utf8_bin NOT NULL,
  `environment` varchar(32) COLLATE utf8_bin NOT NULL,
  `parent_app_home` varchar(255) COLLATE utf8_bin NOT NULL,
  `assets_dir` varchar(255) COLLATE utf8_bin NOT NULL,
  `deploy_kind` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT 'deploy类型',
  `remark` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `cluster_id` (`cluster_id`) USING BTREE,
  CONSTRAINT `uci_pipeline_ibfk_1` FOREIGN KEY (`cluster_id`) REFERENCES `cmdb_app_cluster` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for uci_project
-- ----------------------------
DROP TABLE IF EXISTS `uci_project`;
CREATE TABLE `uci_project` (
  `id` bigint(25) NOT NULL,
  `app_cluster_id` bigint(25) DEFAULT NULL COMMENT '项目组id',
  `project_name` varchar(32) COLLATE utf8_bin NOT NULL COMMENT 'git项目名',
  `vcs_id` bigint(25) DEFAULT NULL COMMENT '对应vcs表',
  `http_url` varchar(512) COLLATE utf8_bin DEFAULT NULL COMMENT 'git项目http地址',
  `ssh_url` varchar(512) COLLATE utf8_bin DEFAULT NULL COMMENT 'git项目的ssh地址',
  `git_info` text COLLATE utf8_bin COMMENT 'gitProject的信息（json）',
  `parent_app_home` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '真实项目存放的父级目录',
  `assets_path` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '构建的文件/目录路径（maven项目的target目录，vue项目的dist目录）',
  `is_boot` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '是否是可以启动的模块（参考maven结构）',
  `lock_status` int(11) DEFAULT NULL COMMENT '锁定状态,1运行中锁定,0非运行中解锁',
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pk_ci_project_app_cluster_id` (`app_cluster_id`) USING BTREE,
  CONSTRAINT `uci_project_ibfk_1` FOREIGN KEY (`app_cluster_id`) REFERENCES `cmdb_app_cluster` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='git项目,与appGroup一一对应';

-- ----------------------------
-- Table structure for uci_trigger
-- ----------------------------
DROP TABLE IF EXISTS `uci_trigger`;
CREATE TABLE `uci_trigger` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '名字',
  `cluster_id` bigint(25) NOT NULL COMMENT 'git项目id',
  `task_id` bigint(25) DEFAULT NULL COMMENT '对应任务id',
  `type` int(11) DEFAULT NULL COMMENT '类型: 1调度(定时),2触发(钩子)',
  `cron` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '当类型为调度时,时间表达式',
  `sha` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '当类型为调度时,比较新旧sha,有差异才更新',
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `enable` int(11) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pk_ci_trigger_cluster_id` (`cluster_id`) USING BTREE,
  KEY `pk_ci_trigger_task_id` (`task_id`) USING BTREE,
  CONSTRAINT `uci_trigger_ibfk_1` FOREIGN KEY (`cluster_id`) REFERENCES `cmdb_app_cluster` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='自动部署的 钩子 配置, 通过项目名和分支名,得到环境id';

-- ----------------------------
-- Table structure for uci_trigger_detail
-- ----------------------------
DROP TABLE IF EXISTS `uci_trigger_detail`;
CREATE TABLE `uci_trigger_detail` (
  `id` bigint(25) NOT NULL,
  `trigger_id` bigint(25) NOT NULL COMMENT '钩子id',
  `instance_id` bigint(25) NOT NULL COMMENT '实例id',
  `del_flag` int(1) DEFAULT '0',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pk_ci_trigger_detail_trigger_id` (`trigger_id`) USING BTREE,
  KEY `pk_ci_trigger_detail_instance_id` (`instance_id`) USING BTREE,
  CONSTRAINT `uci_trigger_detail_ibfk_1` FOREIGN KEY (`instance_id`) REFERENCES `cmdb_app_instance` (`id`),
  CONSTRAINT `uci_trigger_detail_ibfk_2` FOREIGN KEY (`trigger_id`) REFERENCES `uci_trigger` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='一个钩子 对应 多个实例';

-- ----------------------------
-- Table structure for ucm_release_detail
-- ----------------------------
DROP TABLE IF EXISTS `ucm_release_detail`;
CREATE TABLE `ucm_release_detail` (
  `id` bigint(25) NOT NULL,
  `release_id` bigint(25) NOT NULL COMMENT '发布ID',
  `instance_id` bigint(25) NOT NULL COMMENT '应用实例ID',
  `status` int(1) DEFAULT NULL COMMENT '发布结果状态（1:成功/0:未更改/-1:更新失败）',
  `description` text COLLATE utf8_bin COMMENT '发布结果说明',
  `result` text COLLATE utf8_bin COMMENT '配置发布结果内容，JSON格式',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `of_id` (`instance_id`) USING BTREE,
  KEY `release_id` (`release_id`) USING BTREE,
  CONSTRAINT `ucm_release_detail_ibfk_1` FOREIGN KEY (`instance_id`) REFERENCES `cmdb_app_instance` (`id`),
  CONSTRAINT `ucm_release_detail_ibfk_2` FOREIGN KEY (`release_id`) REFERENCES `ucm_release_history` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='ACM配置发布历史明细表';

-- ----------------------------
-- Table structure for ucm_release_history
-- ----------------------------
DROP TABLE IF EXISTS `ucm_release_history`;
CREATE TABLE `ucm_release_history` (
  `id` bigint(25) NOT NULL,
  `version_id` bigint(25) NOT NULL COMMENT '版本号ID',
  `status` int(1) DEFAULT NULL COMMENT '发布状态（1:成功/2:失败）',
  `type` int(1) NOT NULL DEFAULT '1' COMMENT '配置类型（1：新发布/2：重回滚）',
  `remark` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注',
  `create_by` bigint(25) NOT NULL COMMENT '发布用户ID',
  `create_date` datetime NOT NULL COMMENT '发布时间',
  `del_flag` int(1) NOT NULL DEFAULT '0' COMMENT '删除状态',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `version_id` (`version_id`) USING BTREE,
  KEY `create_by` (`create_by`) USING BTREE,
  CONSTRAINT `ucm_release_history_ibfk_1` FOREIGN KEY (`version_id`) REFERENCES `ucm_version` (`id`),
  CONSTRAINT `ucm_release_history_ibfk_2` FOREIGN KEY (`create_by`) REFERENCES `sys_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='ACM配置发布历史记录表';

-- ----------------------------
-- Table structure for ucm_version
-- ----------------------------
DROP TABLE IF EXISTS `ucm_version`;
CREATE TABLE `ucm_version` (
  `id` bigint(25) NOT NULL,
  `sign` varchar(128) COLLATE utf8_bin NOT NULL COMMENT '摘要签名',
  `sign_type` varchar(8) COLLATE utf8_bin NOT NULL COMMENT '摘要算法(MD5/SHA-1/SHA-512...)',
  `tag` int(1) DEFAULT NULL COMMENT '版本标记（1:健康/2:缺陷）',
  `remark` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注',
  `create_by` bigint(25) NOT NULL COMMENT '创建用户ID',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `create_by` (`create_by`) USING BTREE,
  CONSTRAINT `ucm_version_ibfk_1` FOREIGN KEY (`create_by`) REFERENCES `sys_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='ACM配置历史版本表';

-- ----------------------------
-- Table structure for ucm_version_detail
-- ----------------------------
DROP TABLE IF EXISTS `ucm_version_detail`;
CREATE TABLE `ucm_version_detail` (
  `id` bigint(25) NOT NULL,
  `version_id` bigint(25) NOT NULL COMMENT '版本号ID',
  `namespace_id` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '命名空间ID(sys_dict)',
  `type` int(1) NOT NULL DEFAULT '1' COMMENT '内容文件类型（1：yml/2：preperties）',
  `content` text COLLATE utf8_bin NOT NULL COMMENT '配置内容',
  `remark` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '备注',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `version_id` (`version_id`) USING BTREE,
  KEY `namespace_id` (`namespace_id`) USING BTREE,
  CONSTRAINT `ucm_version_detail_ibfk_1` FOREIGN KEY (`version_id`) REFERENCES `ucm_version` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='ACM配置明细表';

-- ----------------------------
-- Table structure for udc_gen_datasource
-- ----------------------------
DROP TABLE IF EXISTS `udc_gen_datasource`;
CREATE TABLE `udc_gen_datasource` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `type` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '数据库类型',
  `host` varchar(255) COLLATE utf8_bin NOT NULL,
  `port` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `database` varchar(64) COLLATE utf8_bin NOT NULL,
  `username` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `db_version` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime NOT NULL,
  `create_by` bigint(25) NOT NULL,
  `update_date` datetime NOT NULL,
  `update_by` bigint(25) NOT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for udc_gen_project
-- ----------------------------
DROP TABLE IF EXISTS `udc_gen_project`;
CREATE TABLE `udc_gen_project` (
  `id` bigint(25) NOT NULL,
  `datasource_id` bigint(25) NOT NULL,
  `project_name` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '生成项目名，如: myproject',
  `provider_set` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '生成器Provider组名, 参见枚举: GenProviderGroup',
  `organ_type` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '生成项目的所属机构类型，如: com.wl4g.xxx  (注：与sys_group无关)',
  `organ_name` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '生成项目的所属机构名，如: com.wl4g.xxx  (注：与sys_group无关)',
  `version` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `author` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '生成的项目作者信息',
  `since` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '生成的项目自版本源',
  `copyright` varchar(2000) COLLATE utf8_bin DEFAULT NULL COMMENT '生成的项目版权信息',
  `extra_options_json` text COLLATE utf8_bin COMMENT '生成的项目扩展配置(json格式). 如: mvn工程构建类型tar/jar',
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '生成的项目备注说明',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `database_id` (`datasource_id`) USING BTREE,
  CONSTRAINT `udc_gen_project_ibfk_1` FOREIGN KEY (`datasource_id`) REFERENCES `udc_gen_datasource` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for udc_gen_table
-- ----------------------------
DROP TABLE IF EXISTS `udc_gen_table`;
CREATE TABLE `udc_gen_table` (
  `id` bigint(25) NOT NULL,
  `project_id` bigint(25) NOT NULL,
  `table_name` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '表名',
  `entity_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `comments` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `module_name` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '模块名',
  `sub_module_name` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '子模块名',
  `function_name` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '生成功能名',
  `function_name_simple` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '功能名（简写）',
  `function_author` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '功能作者',
  `status` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '是否启用(1:启用/0:禁用)',
  `extra_options_json` text COLLATE utf8_bin,
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `project_id` (`project_id`) USING BTREE,
  CONSTRAINT `udc_gen_table_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `udc_gen_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for udc_gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `udc_gen_table_column`;
CREATE TABLE `udc_gen_table_column` (
  `id` bigint(25) NOT NULL,
  `table_id` bigint(25) NOT NULL,
  `column_name` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '生成表列名',
  `column_type` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '生成表列字段类型//e.g varchar(255)',
  `simple_column_type` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '生成表列字段类型//e.g varchar',
  `sql_type` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '生成表的字段类型//e.g mybatis的jdbctype',
  `column_comment` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '生成表列注释',
  `column_sort` int(11) NOT NULL COMMENT '生成表列顺序',
  `attr_name` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '生成表对应源码bean属性名(java:bean/go:struct/c#:class等)',
  `attr_type` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '生成表对应源码bean属性类型(java:bean/go:struct/c#:class等);例如当group选择了just Vue时，attr_type可以为空',
  `query_type` int(255) NOT NULL COMMENT '生成字段UI查询类型(如: >或<=)',
  `show_type` int(255) NOT NULL COMMENT '生成字段UI显示类型(如: 1:输入框/2:下拉框)',
  `dict_type` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '生成字段字典类型',
  `valid_rule` varchar(255) CHARACTER SET utf32 DEFAULT NULL COMMENT '表单校验规则(如: regex)',
  `is_pk` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '生成字段是否主键(1:是/0:否)',
  `no_null` varchar(32) COLLATE utf8_bin NOT NULL,
  `is_insert` varchar(32) COLLATE utf8_bin NOT NULL,
  `is_update` varchar(32) COLLATE utf8_bin NOT NULL,
  `is_list` varchar(32) COLLATE utf8_bin NOT NULL,
  `is_query` varchar(32) COLLATE utf8_bin NOT NULL,
  `is_edit` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `table_id` (`table_id`) USING BTREE,
  CONSTRAINT `udc_gen_table_column_ibfk_1` FOREIGN KEY (`table_id`) REFERENCES `udc_gen_table` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for udm_ee_api
-- ----------------------------
DROP TABLE IF EXISTS `udm_ee_api`;
CREATE TABLE `udm_ee_api` (
  `id` bigint(20) NOT NULL,
  `module_id` bigint(20) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `method` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `body_option` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `lockerId` int(11) DEFAULT NULL,
  `locker` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `doc_enterprise_api_ibfk_1` (`module_id`),
  CONSTRAINT `udm_ee_api_ibfk_1` FOREIGN KEY (`module_id`) REFERENCES `udm_ee_api_module` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='企业级API信息表';

-- ----------------------------
-- Table structure for udm_ee_api_module
-- ----------------------------
DROP TABLE IF EXISTS `udm_ee_api_module`;
CREATE TABLE `udm_ee_api_module` (
  `id` bigint(20) NOT NULL,
  `version_id` bigint(20) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `name` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `version_id` (`version_id`),
  CONSTRAINT `udm_ee_api_module_ibfk_1` FOREIGN KEY (`version_id`) REFERENCES `udm_ee_api_repo_version` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='企业级API模块信息表';

-- ----------------------------
-- Table structure for udm_ee_api_properties
-- ----------------------------
DROP TABLE IF EXISTS `udm_ee_api_properties`;
CREATE TABLE `udm_ee_api_properties` (
  `id` bigint(20) NOT NULL,
  `api_id` bigint(20) DEFAULT NULL,
  `name` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `scope` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `type` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `pos` int(11) DEFAULT NULL,
  `rule` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `required` char(1) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `doc_enterprise_api_properties_ibfk_1` (`api_id`),
  CONSTRAINT `udm_ee_api_properties_ibfk_1` FOREIGN KEY (`api_id`) REFERENCES `udm_ee_api` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='企业级API详细(如接口字段)信息表';

-- ----------------------------
-- Table structure for udm_ee_api_repo
-- ----------------------------
DROP TABLE IF EXISTS `udm_ee_api_repo`;
CREATE TABLE `udm_ee_api_repo` (
  `id` bigint(20) NOT NULL,
  `team_id` bigint(20) DEFAULT NULL,
  `group_id` bigint(20) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `logo` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `token` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `visibility` char(1) COLLATE utf8_bin NOT NULL COMMENT '可见性：1公开，2私有(team_id)',
  `can_user_edit` char(1) COLLATE utf8_bin DEFAULT NULL,
  `locker_id` int(11) DEFAULT NULL,
  `locker` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `team_id` (`team_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `udm_ee_api_repo_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `udm_ee_api_repo_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='企业级API仓库表，如有多个系统产品线，不同APIs不同仓库分开';

-- ----------------------------
-- Table structure for udm_ee_api_repo_group
-- ----------------------------
DROP TABLE IF EXISTS `udm_ee_api_repo_group`;
CREATE TABLE `udm_ee_api_repo_group` (
  `id` bigint(20) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='企业级API仓库分组';

-- ----------------------------
-- Table structure for udm_ee_api_repo_version
-- ----------------------------
DROP TABLE IF EXISTS `udm_ee_api_repo_version`;
CREATE TABLE `udm_ee_api_repo_version` (
  `id` bigint(20) NOT NULL,
  `repository_id` bigint(20) NOT NULL,
  `version` varchar(255) COLLATE utf8_bin NOT NULL,
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `repository_id` (`repository_id`),
  CONSTRAINT `udm_ee_api_repo_version_ibfk_1` FOREIGN KEY (`repository_id`) REFERENCES `udm_ee_api_repo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='企业级API仓库版本号信息表';

-- ----------------------------
-- Table structure for udm_ee_document
-- ----------------------------
DROP TABLE IF EXISTS `udm_ee_document`;
CREATE TABLE `udm_ee_document` (
  `id` bigint(20) NOT NULL,
  `parent_id` bigint(20) DEFAULT NULL COMMENT '父级id',
  `repository_id` bigint(20) NOT NULL,
  `version` varchar(64) COLLATE utf8_bin NOT NULL,
  `title` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '文档标题',
  `content` text COLLATE utf8_bin COMMENT 'md内容',
  `sort` int(11) DEFAULT NULL COMMENT '同级菜单排序',
  `lang` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '语言',
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `version_id` (`version`),
  KEY `repository_id` (`repository_id`),
  CONSTRAINT `udm_ee_document_ibfk_1` FOREIGN KEY (`repository_id`) REFERENCES `udm_ee_api_repo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='企业级文档信息表（document表一条记录对应一个文档文件内容，document_repo表一条记录对应一套文档文件，类似一个静态html项目）';

-- ----------------------------
-- Table structure for udm_ee_document_repo
-- ----------------------------
DROP TABLE IF EXISTS `udm_ee_document_repo`;
CREATE TABLE `udm_ee_document_repo` (
  `id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `git_url` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `logo` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `token` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `visibility` char(1) COLLATE utf8_bin NOT NULL COMMENT '可见性：1公开，2私有(team_id)',
  `can_user_edit` char(1) COLLATE utf8_bin DEFAULT NULL,
  `locker_id` int(11) DEFAULT NULL,
  `locker` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `group_id` (`group_id`),
  CONSTRAINT `udm_ee_document_repo_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `udm_ee_api_repo_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='企业级文档仓库表（document表一条记录对应一个文档文件内容，document_repo表一条记录对应一套文档文件，类似一个静态html项目）';

-- ----------------------------
-- Table structure for udm_ee_document_repo_group
-- ----------------------------
DROP TABLE IF EXISTS `udm_ee_document_repo_group`;
CREATE TABLE `udm_ee_document_repo_group` (
  `id` bigint(20) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='企业级文档仓库分组';

-- ----------------------------
-- Table structure for udm_ee_document_repo_version
-- ----------------------------
DROP TABLE IF EXISTS `udm_ee_document_repo_version`;
CREATE TABLE `udm_ee_document_repo_version` (
  `id` bigint(20) NOT NULL,
  `repository_id` bigint(20) NOT NULL,
  `version` varchar(255) COLLATE utf8_bin NOT NULL,
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `repository_id` (`repository_id`),
  CONSTRAINT `udm_ee_document_repo_version_ibfk_1` FOREIGN KEY (`repository_id`) REFERENCES `udm_ee_api_repo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='企业级文档仓库版本号信息表';

-- ----------------------------
-- Table structure for udm_file_changes
-- ----------------------------
DROP TABLE IF EXISTS `udm_file_changes`;
CREATE TABLE `udm_file_changes` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin NOT NULL,
  `doc_code` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '文件编码,uuid',
  `type` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '仅支持文本文件(如：md、txt)',
  `action` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT 'add, edit, del,取字典',
  `lang` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '语言',
  `content` text COLLATE utf8_bin NOT NULL COMMENT '文件路径',
  `sha` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '内容的sha1值',
  `description` text COLLATE utf8_bin COMMENT '说明(CN)',
  `is_latest` int(1) NOT NULL COMMENT '是否最新',
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` bigint(25) NOT NULL,
  `update_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_by` bigint(25) NOT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `file_code` (`doc_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='doc文档文件变更记录表';

-- ----------------------------
-- Table structure for udm_file_label
-- ----------------------------
DROP TABLE IF EXISTS `udm_file_label`;
CREATE TABLE `udm_file_label` (
  `id` bigint(25) NOT NULL,
  `label_id` bigint(25) NOT NULL,
  `file_id` bigint(25) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for udm_label
-- ----------------------------
DROP TABLE IF EXISTS `udm_label`;
CREATE TABLE `udm_label` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '标签名',
  `create_date` datetime NOT NULL,
  `create_by` bigint(25) NOT NULL,
  `update_date` datetime NOT NULL,
  `update_by` bigint(25) NOT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for udm_share
-- ----------------------------
DROP TABLE IF EXISTS `udm_share`;
CREATE TABLE `udm_share` (
  `id` bigint(25) NOT NULL,
  `share_code` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '分享编码',
  `doc_code` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '文档编码',
  `share_type` int(11) NOT NULL COMMENT '分享类型,分享类型,0不需要密码,1需要密码',
  `passwd` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '分享密码',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
  `expire_type` int(2) NOT NULL COMMENT '过期类型,1永久 2限时,',
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` bigint(25) NOT NULL,
  `update_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_by` bigint(25) NOT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `doc_share_ibfk_1` (`doc_code`) USING BTREE,
  CONSTRAINT `udm_share_ibfk_1` FOREIGN KEY (`doc_code`) REFERENCES `udm_file_changes` (`doc_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for umc_alarm_config
-- ----------------------------
DROP TABLE IF EXISTS `umc_alarm_config`;
CREATE TABLE `umc_alarm_config` (
  `id` bigint(25) NOT NULL,
  `collect_id` bigint(25) DEFAULT NULL COMMENT '采集器id',
  `template_id` bigint(25) DEFAULT NULL COMMENT '模版id',
  `contact_group_id` bigint(25) DEFAULT NULL COMMENT '通知联系人分组ID',
  `callback_url` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '触发回调地址',
  `enable` int(1) DEFAULT '1' COMMENT '启用状态',
  `create_date` datetime DEFAULT NULL,
  `create_by` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `contact_group_id` (`contact_group_id`) USING BTREE,
  KEY `collector_id` (`collect_id`) USING BTREE,
  KEY `template_id` (`template_id`) USING BTREE,
  CONSTRAINT `umc_alarm_config_ibfk_1` FOREIGN KEY (`contact_group_id`) REFERENCES `sys_contact_group` (`id`),
  CONSTRAINT `umc_alarm_config_ibfk_2` FOREIGN KEY (`template_id`) REFERENCES `umc_alarm_template` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for umc_alarm_record
-- ----------------------------
DROP TABLE IF EXISTS `umc_alarm_record`;
CREATE TABLE `umc_alarm_record` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '告警名称',
  `template_id` bigint(25) DEFAULT NULL COMMENT '对应模版名称',
  `gather_time` datetime DEFAULT NULL COMMENT '采集时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `alarm_type` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '通知类型:对应umc_alarm_config的alarm_type',
  `alarm_note` text COLLATE utf8_bin COMMENT 'note内容：collector_addr，metric_name，tags，value，threshold，relateOperator',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `config_id` (`template_id`) USING BTREE,
  CONSTRAINT `umc_alarm_record_ibfk_1` FOREIGN KEY (`template_id`) REFERENCES `umc_alarm_template` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='umc告警记录表';

-- ----------------------------
-- Table structure for umc_alarm_record_rule
-- ----------------------------
DROP TABLE IF EXISTS `umc_alarm_record_rule`;
CREATE TABLE `umc_alarm_record_rule` (
  `id` bigint(25) NOT NULL,
  `record_id` bigint(25) DEFAULT NULL COMMENT '记录id',
  `rule_id` bigint(25) DEFAULT NULL COMMENT '匹配规则id',
  `compare_value` double DEFAULT NULL COMMENT '比较值,聚合运算后得出的值',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `record_id` (`record_id`) USING BTREE,
  KEY `rule_id` (`rule_id`) USING BTREE,
  CONSTRAINT `umc_alarm_record_rule_ibfk_1` FOREIGN KEY (`record_id`) REFERENCES `umc_alarm_record` (`id`),
  CONSTRAINT `umc_alarm_record_rule_ibfk_2` FOREIGN KEY (`rule_id`) REFERENCES `umc_alarm_rule` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='告警记录对应规则表';

-- ----------------------------
-- Table structure for umc_alarm_rule
-- ----------------------------
DROP TABLE IF EXISTS `umc_alarm_rule`;
CREATE TABLE `umc_alarm_rule` (
  `id` bigint(25) NOT NULL,
  `template_id` bigint(25) NOT NULL COMMENT '模版id',
  `aggregator` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '聚合器',
  `relate_operator` int(32) DEFAULT NULL COMMENT 'metric值大小的条件运算（>|<|=|<=|>=）',
  `logical_operator` int(11) DEFAULT NULL COMMENT 'metric匹配逻辑运算（and/连续出现才匹配|or/只要出现就匹配|not/没有出现则匹配）',
  `queue_time_window` bigint(11) DEFAULT NULL COMMENT 'metric滑动队列时间窗口，单位:ms',
  `value` double DEFAULT NULL COMMENT '告警阀值（比较值）',
  `alarm_level` int(11) DEFAULT NULL COMMENT '告警等级{严重,一般}',
  `del_flag` int(1) DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `template_id` (`template_id`) USING BTREE,
  KEY `umc_alarm_rule_ibfk_2` (`aggregator`) USING BTREE,
  CONSTRAINT `umc_alarm_rule_ibfk_1` FOREIGN KEY (`template_id`) REFERENCES `umc_alarm_template` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='umc告警规则表';

-- ----------------------------
-- Table structure for umc_alarm_template
-- ----------------------------
DROP TABLE IF EXISTS `umc_alarm_template`;
CREATE TABLE `umc_alarm_template` (
  `id` bigint(25) NOT NULL,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '模板名称',
  `metric_id` bigint(25) DEFAULT NULL COMMENT '度量id',
  `tags` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '标签，如采集上行附加信息(ip=10.0.0.160, kafkaTopic=abc)',
  `notify_level` int(11) DEFAULT NULL COMMENT '高于此等级才告警',
  `enable` int(11) DEFAULT NULL COMMENT '启用状态',
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='umc告警模版表';

-- ----------------------------
-- Table structure for umc_custom_alarm_event
-- ----------------------------
DROP TABLE IF EXISTS `umc_custom_alarm_event`;
CREATE TABLE `umc_custom_alarm_event` (
  `id` bigint(25) NOT NULL,
  `custom_engine_id` bigint(25) NOT NULL,
  `notify_group_ids` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `message` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `custom_code_id` (`custom_engine_id`) USING BTREE,
  CONSTRAINT `umc_custom_alarm_event_ibfk_1` FOREIGN KEY (`custom_engine_id`) REFERENCES `umc_custom_engine` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for umc_custom_datasource
-- ----------------------------
DROP TABLE IF EXISTS `umc_custom_datasource`;
CREATE TABLE `umc_custom_datasource` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin NOT NULL,
  `provider` varchar(32) COLLATE utf8_bin NOT NULL COMMENT 'mysql,oracle等',
  `status` int(11) NOT NULL COMMENT '0:禁用, 1:启用',
  `create_date` datetime NOT NULL,
  `create_by` bigint(25) NOT NULL,
  `update_date` datetime NOT NULL,
  `update_by` bigint(25) NOT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for umc_custom_datasource_properties
-- ----------------------------
DROP TABLE IF EXISTS `umc_custom_datasource_properties`;
CREATE TABLE `umc_custom_datasource_properties` (
  `id` bigint(25) NOT NULL,
  `data_source_id` bigint(25) DEFAULT NULL,
  `key` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `data_source_id` (`data_source_id`) USING BTREE,
  CONSTRAINT `umc_custom_datasource_properties_ibfk_1` FOREIGN KEY (`data_source_id`) REFERENCES `umc_custom_datasource` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for umc_custom_engine
-- ----------------------------
DROP TABLE IF EXISTS `umc_custom_engine`;
CREATE TABLE `umc_custom_engine` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `datasource_id` bigint(25) NOT NULL,
  `status` int(1) NOT NULL DEFAULT '0' COMMENT '0:禁用, 1:启用',
  `notify_group_ids` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '联系人分组ids(数组)',
  `notify_template` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '消息模版',
  `cron` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT '定时执行cron表达式',
  `code_content` text COLLATE utf8_bin COMMENT '自定义规则逻辑动态语言代码',
  `arguments` varchar(500) COLLATE utf8_bin DEFAULT NULL COMMENT '自定义输入参数(json)',
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `create_date` datetime NOT NULL,
  `create_by` bigint(25) NOT NULL,
  `update_date` datetime NOT NULL,
  `update_by` bigint(25) NOT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `datasource_id` (`datasource_id`) USING BTREE,
  CONSTRAINT `umc_custom_engine_ibfk_1` FOREIGN KEY (`datasource_id`) REFERENCES `umc_custom_datasource` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for umc_custom_history
-- ----------------------------
DROP TABLE IF EXISTS `umc_custom_history`;
CREATE TABLE `umc_custom_history` (
  `id` bigint(25) NOT NULL,
  `custom_engine_id` bigint(25) NOT NULL,
  `start_time` datetime(3) DEFAULT NULL,
  `end_time` datetime(3) DEFAULT NULL,
  `cost_time` bigint(20) DEFAULT NULL,
  `state` int(1) DEFAULT NULL COMMENT '0待启动,1成功,2失败',
  `log_path` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '日志路径',
  `create_by` bigint(25) NOT NULL,
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for umc_metric_template
-- ----------------------------
DROP TABLE IF EXISTS `umc_metric_template`;
CREATE TABLE `umc_metric_template` (
  `id` bigint(25) NOT NULL,
  `metric` varchar(64) COLLATE utf8_bin NOT NULL COMMENT '度量(e.g Host.mem.free)',
  `classify` varchar(32) COLLATE utf8_bin NOT NULL COMMENT '度量类别,用字典key',
  `remark` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '说明',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `del_flag` int(1) NOT NULL DEFAULT '0',
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `classify` (`classify`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for urm_source_repo
-- ----------------------------
DROP TABLE IF EXISTS `urm_source_repo`;
CREATE TABLE `urm_source_repo` (
  `id` bigint(25) NOT NULL,
  `name` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '名字',
  `provider_kind` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '服务商:gitlab,github,等',
  `auth_type` int(11) DEFAULT NULL COMMENT '认证方式,1账号密码,2密钥',
  `base_uri` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '地址',
  `ssh_key_pub` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '公钥',
  `ssh_key` varchar(2000) COLLATE utf8_bin DEFAULT NULL COMMENT '私钥',
  `access_token` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '令牌',
  `username` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '账户',
  `password` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '密码',
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `enable` int(11) DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0',
  `create_date` datetime DEFAULT NULL,
  `create_by` bigint(25) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_by` bigint(25) DEFAULT NULL,
  `organization_code` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '组织编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for webconsole_session
-- ----------------------------
DROP TABLE IF EXISTS `webconsole_session`;
CREATE TABLE `webconsole_session` (
  `id` bigint(25) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT 'alias',
  `address` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `password` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `ssh_key` varchar(2048) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

SET FOREIGN_KEY_CHECKS = 1;
