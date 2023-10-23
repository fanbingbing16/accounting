/*
Navicat MySQL Data Transfer

Source Server         : localhost111
Source Server Version : 80100
Source Host           : localhost:3308
Source Database       : accounting

Target Server Type    : MYSQL
Target Server Version : 80100
File Encoding         : 65001

Date: 2023-10-09 17:52:56
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for base_category
-- ----------------------------
DROP TABLE IF EXISTS `base_category`;
CREATE TABLE `base_category` (
`id`  bigint NOT NULL ,
`name`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`icon`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`type`  enum('2','1') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '2' COMMENT '1是收入 2是支出' ,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci

;

-- ----------------------------
-- Records of base_category
-- ----------------------------
BEGIN;
INSERT INTO `base_category` VALUES ('1', '餐饮', null, '2'), ('2', '购物', null, '2'), ('3', '日用', null, '2'), ('4', '交通', null, '2'), ('5', '蔬菜', null, '2'), ('6', '水果', null, '2'), ('7', '零食', null, '2'), ('8', '运动', null, '2'), ('9', '娱乐', null, '2'), ('10', '通讯', null, '2'), ('11', '服饰', null, '2'), ('12', '美容', null, '2'), ('13', '住房', null, '2'), ('14', '家庭', null, '2'), ('15', '社交', null, '2'), ('16', '旅行', null, '2'), ('17', '烟酒', null, '2'), ('18', '数码', null, '2'), ('19', '汽车', null, '2'), ('20', '医疗', null, '2'), ('21', '书籍', null, '2'), ('22', '学习', null, '2'), ('23', '宠物', null, '2'), ('24', '礼金', null, '2'), ('25', '礼品', null, '2'), ('26', '办公', null, '2'), ('27', '维修', null, '2'), ('28', '捐赠', null, '2'), ('29', '彩票', null, '2'), ('30', '红包', null, '2'), ('31', '快递', null, '2'), ('32', '其他', null, '2'), ('33', '还款', null, '2'), ('34', '借出', null, '2'), ('35', '饮品', null, '2'), ('36', '追星', null, '2'), ('37', '游戏', null, '2'), ('38', '工资', null, '1'), ('39', '红包', null, '1'), ('40', '租金', null, '1'), ('41', '礼金', null, '1'), ('42', '分红', null, '1'), ('43', '理财', null, '1'), ('44', '年终奖', null, '1'), ('45', '借入', null, '1'), ('46', '收款', null, '1'), ('47', '其他', null, '1');
COMMIT;

-- ----------------------------
-- Table structure for budget
-- ----------------------------
DROP TABLE IF EXISTS `budget`;
CREATE TABLE `budget` (
`money`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`typeid`  bigint NOT NULL ,
`time`  date NULL DEFAULT NULL ,
`update_time`  datetime NOT NULL ,
`delete_time`  datetime NULL DEFAULT NULL ,
`id`  bigint NOT NULL ,
`userid`  bigint NOT NULL ,
PRIMARY KEY (`id`),
FOREIGN KEY (`typeid`) REFERENCES `category` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (`userid`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
INDEX `typeid2` (`typeid`) USING BTREE ,
INDEX `userid3` (`userid`) USING BTREE 
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci

;

-- ----------------------------
-- Records of budget
-- ----------------------------
BEGIN;
INSERT INTO `budget` VALUES ('10', '48', '2023-10-04', '2023-10-07 16:53:34', null, '339333762852', '1'), ('10', '48', '2023-10-04', '2023-10-07 16:52:51', null, '1018001262504', '1'), ('11', '2', '2023-10-09', '2023-10-09 10:06:35', null, '1018090317276', '1'), ('10', '48', '2023-10-01', '2023-10-07 16:52:40', null, '1357335008032', '1'), ('10', '48', '2023-09-26', '2023-10-07 16:51:38', null, '3054003656814', '1'), ('22.90', '16', '2023-10-09', '2023-10-09 10:42:04', null, '3054274783272', '1'), ('10', '48', '2023-09-26', '2023-10-07 16:51:20', null, '4072004832576', '1'), ('12333122.11', '13', '2023-10-09', '2023-10-09 10:09:27', null, '4072361681136', '1'), ('10', '48', '2023-09-27', '2023-10-07 16:52:28', null, '6108007492116', '1'), ('12.1', '2', '2023-10-09', '2023-10-09 10:09:00', null, '7635678027840', '1'), ('10', '48', '2023-09-27', '2023-10-07 16:52:01', null, '8483343607150', '1');
COMMIT;

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
`name`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`id`  bigint NOT NULL AUTO_INCREMENT ,
`sort`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' ,
`icon`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`update_time`  datetime NOT NULL ,
`delete_time`  datetime NULL DEFAULT NULL ,
`userid`  bigint NULL DEFAULT NULL ,
`type`  enum('2','1') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '1是收入 2是支出' ,
PRIMARY KEY (`id`),
FOREIGN KEY (`userid`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
INDEX `userid` (`userid`) USING BTREE 
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
AUTO_INCREMENT=50

;

-- ----------------------------
-- Records of category
-- ----------------------------
BEGIN;
INSERT INTO `category` VALUES ('购物', '2', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('日用', '3', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('交通', '4', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('蔬菜', '5', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('水果', '6', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('零食', '7', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('运动', '8', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('娱乐', '9', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('通讯', '10', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('服饰', '11', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('美容', '12', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('住房', '13', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('家庭', '14', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('社交', '15', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('旅行', '16', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('烟酒', '17', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('数码', '18', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('汽车', '19', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('医疗', '20', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('书籍', '21', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('学习', '22', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('宠物', '23', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('礼金', '24', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('礼品', '25', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('办公', '26', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('维修', '27', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('捐赠', '28', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('彩票', '29', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('红包', '30', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('快递', '31', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('其他', '32', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('还款', '33', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('借出', '34', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('饮品', '35', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('追星', '36', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('游戏', '37', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('餐饮', '38', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('红包', '39', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('租金', '40', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('礼金', '41', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('分红', '42', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('理财', '43', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('年终奖', '44', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('借入', '45', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('收款', '46', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('其他', '47', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('工资', '48', '0', null, '2023-09-26 11:17:59', null, '1', '1');
COMMIT;

-- ----------------------------
-- Table structure for expenditure_income
-- ----------------------------
DROP TABLE IF EXISTS `expenditure_income`;
CREATE TABLE `expenditure_income` (
`money`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' ,
`id`  bigint NOT NULL AUTO_INCREMENT ,
`userid`  bigint NOT NULL ,
`typeid`  bigint NOT NULL ,
`update_time`  datetime NOT NULL ,
`delete_time`  datetime NULL DEFAULT NULL ,
`description`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`time`  date NULL DEFAULT NULL ,
`type`  enum('2','1') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '1是收入 2是支出' ,
`ding`  enum('否','是') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '否' ,
PRIMARY KEY (`id`),
FOREIGN KEY (`typeid`) REFERENCES `category` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (`userid`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
INDEX `userid2` (`userid`) USING BTREE ,
INDEX `typeid` (`typeid`) USING BTREE 
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
AUTO_INCREMENT=16958946105101

;

-- ----------------------------
-- Records of expenditure_income
-- ----------------------------
BEGIN;
INSERT INTO `expenditure_income` VALUES ('55', '508742171001', '1', '35', '2023-09-27 17:33:57', null, null, '2023-09-27', '2', '否'), ('55', '508742171002', '1', '35', '2023-09-27 17:33:57', null, null, '2023-09-21', '2', '否'), ('96', '508992307140', '1', '4', '2023-10-07 09:10:24', null, null, '2023-10-06', '2', '否'), ('33', '848320501790', '1', '3', '2023-10-07 09:10:04', null, null, '2023-10-07', '2', '否'), ('333', '1695894725780', '1', '8', '2023-09-28 17:52:06', null, null, '2023-09-28', '2', '否'), ('222', '2035990984956', '1', '13', '2023-10-07 14:12:34', null, null, '2023-10-04', '2', '否'), ('55.4', '2036083288980', '1', '16', '2023-10-08 11:34:34', null, null, '2023-10-08', '2', '否'), ('1', '3052453102704', '1', '36', '2023-09-27 17:34:39', null, null, '2023-09-27', '2', '否'), ('969', '3391789482380', '1', '16', '2023-09-28 17:52:21', null, null, '2023-09-01', '2', '否'), ('69', '3562955136195', '1', '12', '2023-10-07 10:21:43', null, null, '2023-10-07', '2', '否'), ('89', '4071951499128', '1', '7', '2023-10-07 10:40:58', null, null, '2023-10-07', '2', '否'), ('6666', '5935579696865', '1', '48', '2023-09-28 13:45:13', null, null, '2023-09-28', '1', '否'), ('996', '5938258681600', '1', '15', '2023-10-07 10:22:18', null, null, '2023-10-07', '2', '否'), ('66', '6104906124192', '1', '38', '2023-09-27 17:34:17', null, null, '2023-09-27', '2', '否'), ('56', '6107927587056', '1', '4', '2023-10-07 10:42:32', null, null, '2023-10-07', '2', '否'), ('23', '6107972887260', '1', '17', '2023-10-07 14:12:15', null, null, '2023-10-02', '2', '否'), ('6', '9496520707240', '1', '38', '2023-09-27 17:34:29', null, null, '2023-09-27', '2', '否'), ('5666', '11876487295540', '1', '48', '2023-10-07 09:10:42', null, null, '2023-10-01', '1', '否'), ('85', '13742838423819', '1', '8', '2023-10-07 10:45:19', null, null, '2023-10-07', '2', '否'), ('9', '16957999304007', '1', '40', '2023-09-27 15:16:47', null, null, '2023-09-27', '1', '否'), ('9', '16957999306550', '1', '3', '2023-09-27 15:32:10', null, null, '2023-09-13', '1', '否'), ('9', '16957999306670', '1', '3', '2023-09-27 15:32:10', null, null, '2023-09-13', '1', '否'), ('67', '16957999306716', '1', '35', '2023-09-28 09:50:22', null, null, '2023-08-25', '2', '否'), ('9', '16957999306717', '2', '4', '2023-10-11 10:50:05', null, null, '2023-10-07', '2', '否'), ('99', '16958946105100', '1', '4', '2023-09-28 17:50:11', '2023-10-07 10:48:35', null, '2023-09-14', '2', '否');
COMMIT;

-- ----------------------------
-- Table structure for schedule_tasks
-- ----------------------------
DROP TABLE IF EXISTS `schedule_tasks`;
CREATE TABLE `schedule_tasks` (
`update_time`  datetime NOT NULL ,
`delete_time`  datetime NULL DEFAULT NULL ,
`userid`  bigint NOT NULL ,
`typeid`  bigint NOT NULL ,
`money`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`start_time`  datetime NOT NULL ,
`type`  enum('2','1') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' ,
`description`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`id`  bigint NOT NULL AUTO_INCREMENT ,
`end_time`  datetime NULL DEFAULT NULL ,
`name`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`every`  enum('MONTH','WEEK','DAY') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'DAY' ,
PRIMARY KEY (`id`),
FOREIGN KEY (`typeid`) REFERENCES `category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (`userid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
INDEX `s_userid` (`userid`) USING BTREE ,
INDEX `s_typeid` (`typeid`) USING BTREE 
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci

;

-- ----------------------------
-- Records of schedule_tasks
-- ----------------------------
BEGIN;
INSERT INTO `schedule_tasks` VALUES ('2023-10-09 17:33:03', null, '1', '8', '11.11', '2023-10-09 05:00:00', '1', null, '3054319169328', '2023-11-01 00:00:00', 'ding2714950372736', 'DAY');
COMMIT;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
`username`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`id`  bigint NOT NULL ,
`delete_time`  datetime NULL DEFAULT NULL ,
`update_time`  datetime NOT NULL ,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci

;

-- ----------------------------
-- Records of user
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES ('1', '1', null, '2023-09-26 09:25:58'), ('2', '2', null, '2023-09-27 15:53:31');
COMMIT;

-- ----------------------------
-- Event structure for ding2714950372736
-- ----------------------------
DROP EVENT IF EXISTS `ding2714950372736`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` EVENT `ding2714950372736` ON SCHEDULE EVERY 1 DAY STARTS '2023-10-09 05:00:00' ENDS '2023-11-01 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO insert into expenditure_income(type,time,money,userid,typeid,update_time,ding) values(1,date(CURRENT_DATE),11.11,'1',8,NOW(),'是')
;;
DELIMITER ;

-- ----------------------------
-- Event structure for test3
-- ----------------------------
DROP EVENT IF EXISTS `test3`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` EVENT `test3` ON SCHEDULE EVERY 1 DAY STARTS '2023-10-08 14:49:00' ON COMPLETION NOT PRESERVE ENABLE DO INSERT INTO expenditure_income(type,time,money,userid,typeid,update_time,description,ding) VALUES('1',date(CURRENT_DATE),'11','1','2',NOW(),'定时测试','是')
;;
DELIMITER ;

-- ----------------------------
-- Auto increment value for category
-- ----------------------------
ALTER TABLE `category` AUTO_INCREMENT=50;
