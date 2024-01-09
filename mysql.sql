/*
Navicat MySQL Data Transfer

Source Server         : 103.133.177.119
Source Server Version : 50639
Source Host           : 103.133.177.119:3306
Source Database       : accounting

Target Server Type    : MYSQL
Target Server Version : 50639
File Encoding         : 65001

Date: 2024-02-01 10:54:47
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for base_category
-- ----------------------------
DROP TABLE IF EXISTS `base_category`;
CREATE TABLE `base_category` (
`id`  bigint(20) NOT NULL ,
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
`typeid`  bigint(20) NOT NULL ,
`time`  date NULL DEFAULT NULL ,
`update_time`  datetime NOT NULL ,
`delete_time`  datetime NULL DEFAULT NULL ,
`id`  bigint(20) NOT NULL ,
`userid`  bigint(20) NOT NULL ,
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
INSERT INTO `budget` VALUES ('10', '48', '2023-10-04', '2023-10-07 16:53:34', null, '339333762852', '1'), ('10', '48', '2023-10-04', '2023-10-07 16:52:51', null, '1018001262504', '1'), ('11', '2', '2023-10-09', '2023-10-09 10:06:35', null, '1018090317276', '1'), ('10', '48', '2023-10-01', '2023-10-07 16:52:40', null, '1357335008032', '1'), ('10', '48', '2023-09-26', '2023-10-07 16:51:38', null, '3054003656814', '1'), ('22.90', '16', '2023-10-09', '2023-10-09 10:42:04', null, '3054274783272', '1'), ('10', '48', '2023-09-26', '2023-10-07 16:51:20', null, '4072004832576', '1'), ('12333122.11', '13', '2023-10-09', '2023-10-09 10:09:27', null, '4072361681136', '1'), ('10', '48', '2023-09-27', '2023-10-07 16:52:28', null, '6108007492116', '1'), ('12.1', '2', '2023-10-09', '2023-10-09 10:09:00', null, '7635678027840', '1'), ('10', '48', '2023-09-27', '2023-10-07 16:52:01', null, '8483343607150', '1'), ('1111111111111111111', '52', '2024-01-31', '2024-01-31 14:04:04', null, '13653448352943', '30716962541099');
COMMIT;

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
`name`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`id`  bigint(20) NOT NULL AUTO_INCREMENT ,
`sort`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' ,
`icon`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`update_time`  datetime NOT NULL ,
`delete_time`  datetime NULL DEFAULT NULL ,
`userid`  bigint(20) NULL DEFAULT NULL ,
`type`  enum('2','1') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '1是收入 2是支出' ,
PRIMARY KEY (`id`),
FOREIGN KEY (`userid`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
INDEX `userid` (`userid`) USING BTREE 
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
AUTO_INCREMENT=144

;

-- ----------------------------
-- Records of category
-- ----------------------------
BEGIN;
INSERT INTO `category` VALUES ('购物', '2', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('日用', '3', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('交通', '4', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('蔬菜', '5', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('水果', '6', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('零食', '7', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('运动', '8', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('娱乐', '9', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('通讯', '10', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('服饰', '11', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('美容', '12', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('住房', '13', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('家庭', '14', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('社交', '15', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('旅行', '16', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('烟酒', '17', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('数码', '18', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('汽车', '19', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('医疗', '20', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('书籍', '21', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('学习', '22', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('宠物', '23', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('礼金', '24', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('礼品', '25', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('办公', '26', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('维修', '27', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('捐赠', '28', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('彩票', '29', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('红包', '30', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('快递', '31', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('其他', '32', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('还款', '33', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('借出', '34', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('饮品', '35', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('追星', '36', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('游戏', '37', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('餐饮', '38', '0', null, '2023-09-26 11:05:23', null, '1', '2'), ('红包', '39', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('租金', '40', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('礼金', '41', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('分红', '42', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('理财', '43', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('年终奖', '44', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('借入', '45', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('收款', '46', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('其他', '47', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('工资', '48', '0', null, '2023-09-26 11:17:59', null, '1', '1'), ('餐饮', '50', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('购物', '51', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('日用', '52', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('交通', '53', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('蔬菜', '54', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('水果', '55', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('零食', '56', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('运动', '57', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('娱乐', '58', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('通讯', '59', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('服饰', '60', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('美容', '61', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('住房', '62', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('家庭', '63', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('社交', '64', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('旅行', '65', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('烟酒', '66', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('数码', '67', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('汽车', '68', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('医疗', '69', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('书籍', '70', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('学习', '71', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('宠物', '72', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('礼金', '73', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('礼品', '74', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('办公', '75', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('维修', '76', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('捐赠', '77', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('彩票', '78', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('红包', '79', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('快递', '80', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('其他', '81', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('还款', '82', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('借出', '83', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('饮品', '84', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('追星', '85', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('游戏', '86', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '2'), ('工资', '87', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '1'), ('红包', '88', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '1'), ('租金', '89', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '1'), ('礼金', '90', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '1'), ('分红', '91', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '1'), ('理财', '92', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '1'), ('年终奖', '93', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '1'), ('借入', '94', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '1'), ('收款', '95', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '1'), ('其他', '96', '0', '', '2024-01-29 11:12:18', null, '30716962541099', '1'), ('餐饮', '97', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('购物', '98', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('日用', '99', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('交通', '100', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('蔬菜', '101', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('水果', '102', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2');
INSERT INTO `category` VALUES ('零食', '103', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('运动', '104', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('娱乐', '105', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('通讯', '106', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('服饰', '107', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('美容', '108', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('住房', '109', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('家庭', '110', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('社交', '111', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('旅行', '112', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('烟酒', '113', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('数码', '114', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('汽车', '115', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('医疗', '116', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('书籍', '117', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('学习', '118', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('宠物', '119', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('礼金', '120', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('礼品', '121', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('办公', '122', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('维修', '123', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('捐赠', '124', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('彩票', '125', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('红包', '126', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('快递', '127', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('其他', '128', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('还款', '129', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('借出', '130', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('饮品', '131', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('追星', '132', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('游戏', '133', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '2'), ('工资', '134', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '1'), ('红包', '135', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '1'), ('租金', '136', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '1'), ('礼金', '137', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '1'), ('分红', '138', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '1'), ('理财', '139', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '1'), ('年终奖', '140', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '1'), ('借入', '141', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '1'), ('收款', '142', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '1'), ('其他', '143', '0', '', '2024-02-01 10:49:01', null, '136540459207216', '1');
COMMIT;

-- ----------------------------
-- Table structure for expenditure_income
-- ----------------------------
DROP TABLE IF EXISTS `expenditure_income`;
CREATE TABLE `expenditure_income` (
`money`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' ,
`id`  bigint(20) NOT NULL AUTO_INCREMENT ,
`userid`  bigint(20) NOT NULL ,
`typeid`  bigint(20) NOT NULL ,
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
AUTO_INCREMENT=153592056307583

;

-- ----------------------------
-- Records of expenditure_income
-- ----------------------------
BEGIN;
INSERT INTO `expenditure_income` VALUES ('233', '111', '30716962541099', '6', '2024-01-31 13:58:52', null, '11', '2024-01-31', '1', '否'), ('55', '508742171001', '1', '35', '2023-09-27 17:33:57', null, null, '2023-09-27', '2', '否'), ('55', '508742171002', '1', '35', '2023-09-27 17:33:57', null, null, '2023-09-21', '2', '否'), ('96', '508992307140', '1', '4', '2023-10-07 09:10:24', null, null, '2023-10-06', '2', '否'), ('33', '848320501790', '1', '3', '2023-10-07 09:10:04', null, null, '2023-10-07', '2', '否'), ('333', '1695894725780', '1', '8', '2023-09-28 17:52:06', null, null, '2023-09-28', '2', '否'), ('222', '2035990984956', '1', '13', '2023-10-07 14:12:34', null, null, '2023-10-04', '2', '否'), ('55.4', '2036083288980', '1', '16', '2023-10-08 11:34:34', null, null, '2023-10-08', '2', '否'), ('1', '3052453102704', '1', '36', '2023-09-27 17:34:39', null, null, '2023-09-27', '2', '否'), ('969', '3391789482380', '1', '16', '2023-09-28 17:52:21', null, null, '2023-09-01', '2', '否'), ('69', '3562955136195', '1', '12', '2023-10-07 10:21:43', null, null, '2023-10-07', '2', '否'), ('89', '4071951499128', '1', '7', '2023-10-07 10:40:58', null, null, '2023-10-07', '2', '否'), ('6666', '5935579696865', '1', '48', '2023-09-28 13:45:13', null, null, '2023-09-28', '1', '否'), ('996', '5938258681600', '1', '15', '2023-10-07 10:22:18', null, null, '2023-10-07', '2', '否'), ('66', '6104906124192', '1', '38', '2023-09-27 17:34:17', null, null, '2023-09-27', '2', '否'), ('56', '6107927587056', '1', '4', '2023-10-07 10:42:32', null, null, '2023-10-07', '2', '否'), ('23', '6107972887260', '1', '17', '2023-10-07 14:12:15', null, null, '2023-10-02', '2', '否'), ('99', '6826313499063', '30716962541099', '52', '2024-01-30 09:32:55', null, '11', '2024-01-30', '2', '否'), ('6', '9496520707240', '1', '38', '2023-09-27 17:34:29', null, null, '2023-09-27', '2', '否'), ('5666', '11876487295540', '1', '48', '2023-10-07 09:10:42', null, null, '2023-10-01', '1', '否'), ('88', '13651983819011', '30716962541099', '53', '2024-01-29 11:12:57', null, null, '2024-01-29', '2', '否'), ('8999', '13652629366675', '30716962541099', '72', '2024-01-30 09:37:51', null, null, '2024-01-31', '2', '否'), ('85', '13742838423819', '1', '8', '2023-10-07 10:45:19', null, null, '2023-10-07', '2', '否'), ('669', '15359207177948', '30716962541099', '80', '2024-01-30 09:36:15', null, null, '2024-01-13', '2', '否'), ('9', '16957999304007', '1', '40', '2023-09-27 15:16:47', null, null, '2023-09-27', '1', '否'), ('9', '16957999306550', '1', '3', '2023-09-27 15:32:10', null, null, '2023-09-13', '1', '否'), ('9', '16957999306670', '1', '3', '2023-09-27 15:32:10', null, null, '2023-09-13', '1', '否'), ('67', '16957999306716', '1', '35', '2023-09-28 09:50:22', null, null, '2023-08-25', '2', '否'), ('9', '16957999306717', '2', '4', '2023-10-11 10:50:05', null, null, '2023-10-07', '2', '否'), ('99', '16958946105100', '1', '4', '2023-09-28 17:50:11', '2023-10-07 10:48:35', null, '2023-09-14', '2', '否'), ('85', '27303968388921', '30716962541099', '59', '2024-01-29 11:13:44', null, null, '2024-01-29', '2', '否'), ('699', '27305255357460', '30716962541099', '61', '2024-01-30 09:34:20', null, null, '2024-01-04', '2', '否'), ('89', '30718413807548', '30716962541099', '64', '2024-01-30 09:35:45', null, null, '2024-01-18', '2', '否'), ('66985', '34131574902605', '30716962541099', '65', '2024-01-30 09:39:05', null, null, '2024-01-20', '2', '否'), ('99', '51197354937839', '30716962541099', '51', '2024-01-30 09:34:58', null, null, '2024-01-17', '2', '否'), ('88', '61433926877907', '30716962541099', '51', '2024-01-29 11:12:49', null, '11', '2024-01-29', '2', '否'), ('89999', '81915774628783', '30716962541099', '62', '2024-01-30 09:37:18', null, null, '2024-01-30', '2', '否'), ('89999', '81920687952058', '30716962541099', '52', '2024-01-31 14:03:19', null, null, '2024-01-31', '1', '否'), ('8965', '107514458266498', '30716962541099', '57', '2024-01-30 09:38:23', null, null, '2024-01-01', '2', '否'), ('78', '122867854968593', '30716962541099', '88', '2024-01-29 11:13:06', null, null, '2024-01-29', '1', '否'), ('8652', '122873668569137', '30716962541099', '51', '2024-01-30 09:38:50', null, null, '2024-01-08', '2', '否'), ('98', '153592056307580', '30716962541099', '52', '2024-01-30 09:33:23', null, null, '2024-01-30', '2', '否'), ('11', '153592056307581', '30716962541099', '56', '2024-01-31 13:53:00', null, '测试定时任务的', '2024-01-31', '1', '是'), ('11', '153592056307582', '1', '56', '2024-01-31 14:08:00', null, '测试定时任务的', '2024-01-31', '1', '是');
COMMIT;

-- ----------------------------
-- Table structure for logs
-- ----------------------------
DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs` (
`name`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`id`  bigint(20) NOT NULL ,
`content`  longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
`update_time`  datetime NULL DEFAULT NULL ,
`type1`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`type2`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`isMarkdown`  enum('0','1') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`delete_time`  datetime NULL DEFAULT NULL ,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci

;

-- ----------------------------
-- Records of logs
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for schedule_tasks
-- ----------------------------
DROP TABLE IF EXISTS `schedule_tasks`;
CREATE TABLE `schedule_tasks` (
`update_time`  datetime NOT NULL ,
`delete_time`  datetime NULL DEFAULT NULL ,
`userid`  bigint(20) NOT NULL ,
`typeid`  bigint(20) NOT NULL ,
`money`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`start_time`  datetime NOT NULL ,
`type`  enum('2','1') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' ,
`description`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`id`  bigint(20) NOT NULL AUTO_INCREMENT ,
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
AUTO_INCREMENT=68263160651532

;

-- ----------------------------
-- Records of schedule_tasks
-- ----------------------------
BEGIN;
INSERT INTO `schedule_tasks` VALUES ('2023-10-09 17:33:03', null, '1', '8', '11.11', '2023-10-09 05:00:00', '1', null, '3054319169328', '2023-11-01 00:00:00', 'ding2714950372736', 'DAY'), ('2024-01-30 09:43:36', null, '30716962541099', '56', '11', '2024-01-30 05:00:00', '2', '测试定时任务的', '68263160651531', null, 'ding71676318684097', 'DAY');
COMMIT;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
`username`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`id`  bigint(20) NOT NULL ,
`delete_time`  datetime NULL DEFAULT NULL ,
`update_time`  datetime NOT NULL ,
`password`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`avter`  longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci

;

-- ----------------------------
-- Records of user
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES ('1', '1', null, '2023-09-26 09:25:58', '111', null), ('2', '2', null, '2023-09-27 15:53:31', '111', null), ('日志所用，不可以删除', '111111111111', '2024-01-29 09:13:08', '2024-01-29 09:13:24', '1801132043', null), ('2333', '30716962541099', null, '2024-01-29 11:11:59', '111111', 'data:image/png;base64,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'), ('1111', '136540459207216', null, '2024-02-01 10:49:00', '111111', 'data:image/png;base64,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');
COMMIT;

-- ----------------------------
-- Event structure for ding71676318684097
-- ----------------------------
DROP EVENT IF EXISTS `ding71676318684097`;
DELIMITER ;;
CREATE DEFINER=`root`@`%` EVENT `ding71676318684097` ON SCHEDULE EVERY 1 DAY STARTS '2024-01-30 14:08:00' ON COMPLETION NOT PRESERVE ENABLE DO insert into expenditure_income(type,time,money,userid,typeid,update_time,ding,description) values(2,date(CURRENT_DATE),11,30716962541099,56,NOW(),'是','测试定时任务的')
;;
DELIMITER ;

-- ----------------------------
-- Event structure for test3
-- ----------------------------
DROP EVENT IF EXISTS `test3`;
DELIMITER ;;
CREATE DEFINER=`root`@`%` EVENT `test3` ON SCHEDULE EVERY 1 DAY STARTS '2023-10-08 13:51:00' ON COMPLETION NOT PRESERVE ENABLE DO INSERT INTO expenditure_income(type,time,money,userid,typeid,update_time,description,ding) VALUES('1',date(CURRENT_DATE),'11','1','2',NOW(),'定时测试','是')
;
;;
DELIMITER ;

-- ----------------------------
-- Auto increment value for category
-- ----------------------------
ALTER TABLE `category` AUTO_INCREMENT=144;
