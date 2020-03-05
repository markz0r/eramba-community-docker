#
# SQL Export
# Created by Querious (201067)
# Created: 22 October 2019 at 17:39:48 CEST
# Encoding: Unicode (UTF-8)
#


SET @PREVIOUS_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;


CREATE TABLE `account_review_feeds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `type` int(11) NOT NULL,
  `path` text NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `account_review_feed_pulls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_review_feed_id` int(11) NOT NULL,
  `account_review_pull_id` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_review_feed_id` (`account_review_feed_id`),
  KEY `account_review_pull_id` (`account_review_pull_id`),
  CONSTRAINT `account_review_feed_pulls_ibfk_1` FOREIGN KEY (`account_review_feed_id`) REFERENCES `account_review_feeds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `account_review_feed_pulls_ibfk_2` FOREIGN KEY (`account_review_pull_id`) REFERENCES `account_review_pulls` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `account_review_feed_rows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_review_feed_id` int(11) NOT NULL,
  `account_review_feed_pull_id` int(11) NOT NULL,
  `user` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_review_feed_id` (`account_review_feed_id`),
  KEY `account_review_feed_pull_id` (`account_review_feed_pull_id`),
  CONSTRAINT `account_review_feed_rows_ibfk_1` FOREIGN KEY (`account_review_feed_id`) REFERENCES `account_review_feeds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `account_review_feed_rows_ibfk_2` FOREIGN KEY (`account_review_feed_pull_id`) REFERENCES `account_review_feed_pulls` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `account_review_feed_row_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_review_feed_row_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_review_feed_row_id` (`account_review_feed_row_id`),
  CONSTRAINT `account_review_feed_row_roles_ibfk_1` FOREIGN KEY (`account_review_feed_row_id`) REFERENCES `account_review_feed_rows` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `account_review_feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_review_pull_id` int(11) NOT NULL,
  `account_review_feed_row_id` int(11) DEFAULT NULL,
  `type` int(11) NOT NULL,
  `answer` int(11) DEFAULT NULL,
  `locked` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_review_feed_row_id` (`account_review_feed_row_id`),
  KEY `account_review_pull_id` (`account_review_pull_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `account_review_feedbacks_ibfk_1` FOREIGN KEY (`account_review_feed_row_id`) REFERENCES `account_review_feed_rows` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `account_review_feedbacks_ibfk_2` FOREIGN KEY (`account_review_pull_id`) REFERENCES `account_review_pulls` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `account_review_feedbacks_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `account_review_feedback_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_review_feedback_id` int(11) NOT NULL,
  `type` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_review_feedback_id` (`account_review_feedback_id`),
  CONSTRAINT `account_review_feedback_roles_ibfk_1` FOREIGN KEY (`account_review_feedback_id`) REFERENCES `account_review_feedbacks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `account_review_findings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_review_pull_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `deadline` date NOT NULL,
  `close_date` date DEFAULT NULL,
  `auto_close_date` int(11) NOT NULL DEFAULT 1,
  `status` int(11) NOT NULL,
  `expired` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_review_pull_id` (`account_review_pull_id`),
  CONSTRAINT `account_review_findings_ibfk_1` FOREIGN KEY (`account_review_pull_id`) REFERENCES `account_review_pulls` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `account_review_findings_feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_review_finding_id` int(11) NOT NULL,
  `account_review_feedback_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_review_feedback_id` (`account_review_feedback_id`),
  KEY `account_review_finding_id` (`account_review_finding_id`),
  CONSTRAINT `account_review_findings_feedbacks_ibfk_1` FOREIGN KEY (`account_review_feedback_id`) REFERENCES `account_review_feedbacks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `account_review_findings_feedbacks_ibfk_2` FOREIGN KEY (`account_review_finding_id`) REFERENCES `account_review_findings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `account_reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hash` varchar(255) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `type` int(11) NOT NULL,
  `frequency` int(11) NOT NULL,
  `frequency_type` int(11) NOT NULL,
  `comparison_type` int(11) NOT NULL,
  `account_review_feed_id` int(11) DEFAULT NULL,
  `comparison_account_review_feed_id` int(11) DEFAULT NULL,
  `portal_title` varchar(255) NOT NULL DEFAULT '',
  `portal_description` text NOT NULL,
  `incomplete_submit` int(11) NOT NULL DEFAULT 0,
  `auto_submit_empty` int(11) NOT NULL DEFAULT 1,
  `status` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_review_feed_id` (`account_review_feed_id`),
  KEY `comparison_account_review_feed_id` (`comparison_account_review_feed_id`),
  CONSTRAINT `account_reviews_ibfk_1` FOREIGN KEY (`account_review_feed_id`) REFERENCES `account_review_feeds` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `account_reviews_ibfk_2` FOREIGN KEY (`comparison_account_review_feed_id`) REFERENCES `account_review_feeds` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `account_review_pulls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hash` varchar(255) NOT NULL DEFAULT '',
  `account_review_id` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `submitted` int(11) NOT NULL DEFAULT 0,
  `submit_date` datetime DEFAULT NULL,
  `count_check` int(11) NOT NULL DEFAULT 0,
  `count_added` int(11) NOT NULL DEFAULT 0,
  `count_deleted` int(11) NOT NULL DEFAULT 0,
  `count_current_check` int(11) NOT NULL DEFAULT 0,
  `count_former_check` int(11) NOT NULL DEFAULT 0,
  `count_role_change` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_review_id` (`account_review_id`),
  CONSTRAINT `account_review_pulls_ibfk_1` FOREIGN KEY (`account_review_id`) REFERENCES `account_reviews` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `account_reviews_assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_review_id` int(11) NOT NULL,
  `asset_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_review_id` (`account_review_id`),
  KEY `asset_id` (`asset_id`),
  CONSTRAINT `account_reviews_assets_ibfk_1` FOREIGN KEY (`account_review_id`) REFERENCES `account_reviews` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `account_reviews_assets_ibfk_2` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `acos` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `foreign_key` int(10) DEFAULT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `lft` int(10) DEFAULT NULL,
  `rght` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2938 DEFAULT CHARSET=utf8;


CREATE TABLE `advanced_filters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `description` text NOT NULL,
  `model` varchar(255) NOT NULL,
  `private` int(2) NOT NULL DEFAULT 0,
  `log_result_count` int(2) NOT NULL,
  `log_result_data` int(2) NOT NULL,
  `system_filter` int(3) NOT NULL DEFAULT 0,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `advanced_filters_ibfk_1` (`user_id`),
  CONSTRAINT `advanced_filters_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1070 DEFAULT CHARSET=utf8;


CREATE TABLE `advanced_filter_crons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `advanced_filter_id` int(11) NOT NULL,
  `cron_id` int(11) DEFAULT NULL,
  `type` int(4) DEFAULT NULL,
  `result` int(11) DEFAULT NULL,
  `execution_time` float NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `advanced_filter_id` (`advanced_filter_id`),
  KEY `cron_id` (`cron_id`),
  CONSTRAINT `advanced_filter_cron_ibfk_1` FOREIGN KEY (`advanced_filter_id`) REFERENCES `advanced_filters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `advanced_filter_cron_ibfk_2` FOREIGN KEY (`cron_id`) REFERENCES `cron` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `advanced_filter_cron_result_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `advanced_filter_cron_id` int(11) NOT NULL,
  `data` text NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `advanced_filter_cron_id` (`advanced_filter_cron_id`),
  CONSTRAINT `advanced_filter_cron_result_items_ibfk_1` FOREIGN KEY (`advanced_filter_cron_id`) REFERENCES `advanced_filter_crons` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `advanced_filter_user_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `advanced_filter_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 0,
  `param` varchar(255) NOT NULL DEFAULT '',
  `value` text DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `advanced_filter_id` (`advanced_filter_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `advanced_filter_user_params_ibfk_1` FOREIGN KEY (`advanced_filter_id`) REFERENCES `advanced_filters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `advanced_filter_user_params_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `advanced_filter_user_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `advanced_filter_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `default_index` int(2) NOT NULL DEFAULT 0,
  `limit` int(4) NOT NULL DEFAULT 10,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `advanced_filter_id` (`advanced_filter_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `advanced_filter_user_settings_ib_fk_1` FOREIGN KEY (`advanced_filter_id`) REFERENCES `advanced_filters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `advanced_filter_user_settings_ib_fk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1070 DEFAULT CHARSET=utf8;


CREATE TABLE `advanced_filter_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `advanced_filter_id` int(11) NOT NULL,
  `field` varchar(255) NOT NULL,
  `value` text NOT NULL,
  `many` int(4) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `advanced_filter_values_ibfk_1` (`advanced_filter_id`),
  CONSTRAINT `advanced_filter_values_ibfk_1` FOREIGN KEY (`advanced_filter_id`) REFERENCES `advanced_filters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24246 DEFAULT CHARSET=utf8;


CREATE TABLE `app_notification_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_notification_id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `app_notification_id` (`app_notification_id`),
  CONSTRAINT `app_notification_params_ibfk_1` FOREIGN KEY (`app_notification_id`) REFERENCES `app_notifications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `app_notification_views` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `notifications_view` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `app_notification_views_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `app_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notification` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `foreign_key` int(11) DEFAULT NULL,
  `expiration` datetime DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `aros` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `foreign_key` int(10) DEFAULT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `lft` int(10) DEFAULT NULL,
  `rght` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;


CREATE TABLE `aros_acos` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `aro_id` int(10) NOT NULL,
  `aco_id` int(10) NOT NULL,
  `_create` varchar(2) NOT NULL DEFAULT '0',
  `_read` varchar(2) NOT NULL DEFAULT '0',
  `_update` varchar(2) NOT NULL DEFAULT '0',
  `_delete` varchar(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ARO_ACO_KEY` (`aro_id`,`aco_id`)
) ENGINE=InnoDB AUTO_INCREMENT=166 DEFAULT CHARSET=utf8;


CREATE TABLE `asset_classification_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `asset_classification_count` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `asset_classifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `criteria` text NOT NULL,
  `value` float DEFAULT NULL,
  `asset_classification_type_id` int(11) NOT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_classification_type_id` (`asset_classification_type_id`),
  CONSTRAINT `asset_classifications_ibfk_1` FOREIGN KEY (`asset_classification_type_id`) REFERENCES `asset_classification_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `asset_classifications_assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_classification_id` int(11) NOT NULL,
  `asset_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_classification_id` (`asset_classification_id`),
  KEY `asset_id` (`asset_id`),
  CONSTRAINT `asset_classifications_assets_ibfk_1` FOREIGN KEY (`asset_classification_id`) REFERENCES `asset_classifications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `asset_classifications_assets_ibfk_2` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `asset_labels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `asset_media_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `editable` int(11) DEFAULT 0,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;


CREATE TABLE `asset_media_types_threats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_media_type_id` int(11) NOT NULL,
  `threat_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_media_type_id` (`asset_media_type_id`),
  KEY `threat_id` (`threat_id`),
  CONSTRAINT `FK_asset_media_types_threats_asset_media_types` FOREIGN KEY (`asset_media_type_id`) REFERENCES `asset_media_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_asset_media_types_threats_threats` FOREIGN KEY (`threat_id`) REFERENCES `threats` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;


CREATE TABLE `asset_media_types_vulnerabilities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_media_type_id` int(11) NOT NULL,
  `vulnerability_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_media_type_id` (`asset_media_type_id`),
  KEY `vulnerability_id` (`vulnerability_id`),
  CONSTRAINT `FK_asset_media_types_vulnerabilities_asset_media_types` FOREIGN KEY (`asset_media_type_id`) REFERENCES `asset_media_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_asset_media_types_vulnerabilities_vulnerabilities` FOREIGN KEY (`vulnerability_id`) REFERENCES `vulnerabilities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;


CREATE TABLE `assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `asset_label_id` int(11) DEFAULT NULL,
  `asset_media_type_id` int(11) DEFAULT NULL,
  `asset_owner_id` int(11) DEFAULT NULL,
  `asset_guardian_id` int(11) DEFAULT NULL,
  `asset_user_id` int(11) DEFAULT NULL,
  `review` date NOT NULL,
  `expired_reviews` int(1) NOT NULL DEFAULT 0,
  `security_incident_open_count` int(11) NOT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_label_id` (`asset_label_id`),
  KEY `asset_media_type_id` (`asset_media_type_id`),
  KEY `asset_owner_id` (`asset_owner_id`),
  KEY `asset_guardian_id` (`asset_guardian_id`),
  KEY `asset_user_id` (`asset_user_id`),
  FULLTEXT KEY `name` (`name`),
  CONSTRAINT `assets_ibfk_1` FOREIGN KEY (`asset_label_id`) REFERENCES `asset_labels` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `assets_ibfk_2` FOREIGN KEY (`asset_media_type_id`) REFERENCES `asset_media_types` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `assets_ibfk_4` FOREIGN KEY (`asset_owner_id`) REFERENCES `business_units` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `assets_ibfk_5` FOREIGN KEY (`asset_user_id`) REFERENCES `business_units` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `assets_ibfk_6` FOREIGN KEY (`asset_guardian_id`) REFERENCES `business_units` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `assets_business_units` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL,
  `business_unit_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_id` (`asset_id`),
  KEY `business_unit_id` (`business_unit_id`),
  CONSTRAINT `assets_business_units_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assets_business_units_ibfk_2` FOREIGN KEY (`business_unit_id`) REFERENCES `business_units` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `assets_compliance_managements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL,
  `compliance_management_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_id` (`asset_id`),
  KEY `compliance_management_id` (`compliance_management_id`),
  CONSTRAINT `assets_compliance_managements_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assets_compliance_managements_ibfk_2` FOREIGN KEY (`compliance_management_id`) REFERENCES `compliance_managements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `assets_legals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL,
  `legal_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_id` (`asset_id`),
  KEY `legal_id` (`legal_id`),
  CONSTRAINT `assets_legals_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assets_legals_ibfk_2` FOREIGN KEY (`legal_id`) REFERENCES `legals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `assets_policy_exceptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL,
  `policy_exception_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_id` (`asset_id`),
  KEY `policy_exception_id` (`policy_exception_id`),
  CONSTRAINT `assets_policy_exceptions_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assets_policy_exceptions_ibfk_2` FOREIGN KEY (`policy_exception_id`) REFERENCES `policy_exceptions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `assets_related` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL,
  `asset_related_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_id` (`asset_id`),
  KEY `asset_related_id` (`asset_related_id`),
  CONSTRAINT `assets_related_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assets_related_ibfk_2` FOREIGN KEY (`asset_related_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `assets_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL,
  `risk_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_id` (`asset_id`),
  KEY `risk_id` (`risk_id`),
  CONSTRAINT `assets_risks_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assets_risks_ibfk_2` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `assets_security_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL,
  `security_incident_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_id` (`asset_id`),
  KEY `security_incident_id` (`security_incident_id`),
  CONSTRAINT `assets_security_incidents_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assets_security_incidents_ibfk_2` FOREIGN KEY (`security_incident_id`) REFERENCES `security_incidents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `assets_third_party_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL,
  `third_party_risk_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_id` (`asset_id`),
  KEY `third_party_risk_id` (`third_party_risk_id`),
  CONSTRAINT `assets_third_party_risks_ibfk_1` FOREIGN KEY (`third_party_risk_id`) REFERENCES `third_party_risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assets_third_party_risks_ibfk_2` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL DEFAULT 1,
  `hash` varchar(255) NOT NULL,
  `model` varchar(45) NOT NULL,
  `foreign_key` int(11) DEFAULT NULL,
  `name` text DEFAULT NULL,
  `filename` text NOT NULL,
  `extension` varchar(155) NOT NULL,
  `mime_type` varchar(155) NOT NULL,
  `file_size` int(11) NOT NULL,
  `description` text NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_attachments_users` (`user_id`),
  CONSTRAINT `FK_attachments_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `audits` (
  `id` varchar(36) NOT NULL,
  `version` int(11) NOT NULL,
  `event` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `entity_id` varchar(36) NOT NULL,
  `request_id` varchar(36) NOT NULL,
  `json_object` text NOT NULL,
  `description` text DEFAULT NULL,
  `source_id` varchar(255) DEFAULT NULL,
  `restore_id` varchar(36) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `restore_id` (`restore_id`),
  CONSTRAINT `audits_ibfk_1` FOREIGN KEY (`restore_id`) REFERENCES `audits` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `audit_deltas` (
  `id` varchar(36) NOT NULL,
  `audit_id` varchar(36) NOT NULL,
  `property_name` varchar(255) NOT NULL,
  `old_value` text DEFAULT NULL,
  `new_value` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `audit_id` (`audit_id`),
  CONSTRAINT `audit_deltas_ibfk_1` FOREIGN KEY (`audit_id`) REFERENCES `audits` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `ldap_connectors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `description` text NOT NULL,
  `host` varchar(150) NOT NULL,
  `domain` varchar(150) DEFAULT NULL,
  `port` int(11) NOT NULL DEFAULT 389,
  `ldap_bind_dn` varchar(255) NOT NULL DEFAULT '',
  `ldap_bind_pw` varchar(150) NOT NULL,
  `ldap_base_dn` varchar(255) NOT NULL DEFAULT '',
  `type` enum('authenticator','group') NOT NULL,
  `ldap_auth_filter` varchar(255) DEFAULT '(| (sn=%USERNAME%) )',
  `ldap_auth_attribute` varchar(150) DEFAULT NULL,
  `ldap_name_attribute` varchar(150) DEFAULT NULL,
  `ldap_email_attribute` varchar(150) DEFAULT NULL,
  `ldap_memberof_attribute` varchar(150) DEFAULT NULL,
  `ldap_grouplist_filter` varchar(150) DEFAULT NULL,
  `ldap_grouplist_name` varchar(150) DEFAULT NULL,
  `ldap_groupmemberlist_filter` varchar(255) DEFAULT NULL,
  `ldap_group_account_attribute` varchar(150) DEFAULT NULL,
  `ldap_group_fetch_email_type` varchar(150) DEFAULT NULL,
  `ldap_group_email_attribute` varchar(150) DEFAULT NULL,
  `ldap_group_mail_domain` varchar(150) DEFAULT NULL,
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '0-disabled,1-active',
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `awareness_programs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `description` text NOT NULL,
  `recurrence` int(5) NOT NULL,
  `reminder_apart` int(11) NOT NULL,
  `reminder_amount` int(11) NOT NULL,
  `redirect` varchar(255) NOT NULL,
  `ldap_connector_id` int(11) NOT NULL,
  `video` varchar(255) DEFAULT NULL,
  `video_extension` varchar(50) DEFAULT NULL,
  `video_mime_type` varchar(150) DEFAULT NULL,
  `video_file_size` int(11) DEFAULT NULL,
  `questionnaire` varchar(255) DEFAULT NULL,
  `text_file` varchar(255) DEFAULT NULL,
  `text_file_extension` varchar(50) DEFAULT NULL,
  `text_file_frame_size` int(11) DEFAULT NULL,
  `uploads_sort_json` text NOT NULL,
  `welcome_text` text NOT NULL,
  `welcome_sub_text` text NOT NULL,
  `thank_you_text` text NOT NULL,
  `thank_you_sub_text` text NOT NULL,
  `email_subject` varchar(150) NOT NULL,
  `email_body` text NOT NULL,
  `email_reminder_custom` int(1) NOT NULL DEFAULT 0,
  `email_reminder_subject` varchar(150) NOT NULL,
  `email_reminder_body` text NOT NULL,
  `status` enum('started','stopped') NOT NULL DEFAULT 'stopped',
  `awareness_training_count` int(11) NOT NULL,
  `active_users` int(11) NOT NULL,
  `active_users_percentage` int(3) NOT NULL,
  `ignored_users` int(11) NOT NULL,
  `ignored_users_percentage` int(3) DEFAULT NULL,
  `compliant_users` int(11) NOT NULL,
  `compliant_users_percentage` int(3) NOT NULL,
  `not_compliant_users` int(11) NOT NULL,
  `not_compliant_users_percentage` int(3) NOT NULL,
  `stats_update_status` int(2) NOT NULL DEFAULT 0,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ldap_connector_id` (`ldap_connector_id`),
  CONSTRAINT `awareness_programs_ibfk_1` FOREIGN KEY (`ldap_connector_id`) REFERENCES `ldap_connectors` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `awareness_overtime_graphs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `awareness_program_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `doing` decimal(8,2) NOT NULL,
  `missing` decimal(8,2) NOT NULL,
  `correct_answers` decimal(8,2) NOT NULL,
  `average` decimal(8,2) NOT NULL,
  `timestamp` varchar(45) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `awareness_program_id` (`awareness_program_id`),
  CONSTRAINT `awareness_overtime_graphs_ibfk_1` FOREIGN KEY (`awareness_program_id`) REFERENCES `awareness_programs` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `awareness_program_active_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `awareness_program_id` int(11) NOT NULL,
  `uid` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `name` varchar(155) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `awareness_program_id` (`awareness_program_id`),
  CONSTRAINT `awareness_program_active_users_ibfk_1` FOREIGN KEY (`awareness_program_id`) REFERENCES `awareness_programs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `awareness_program_compliant_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `awareness_program_id` int(11) NOT NULL,
  `uid` varchar(100) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `awareness_program_id` (`awareness_program_id`),
  CONSTRAINT `awareness_program_compliant_users_ibfk_1` FOREIGN KEY (`awareness_program_id`) REFERENCES `awareness_programs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `awareness_program_demos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(100) NOT NULL,
  `awareness_program_id` int(11) NOT NULL,
  `completed` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `awareness_program_id` (`awareness_program_id`),
  CONSTRAINT `awareness_program_demos_ibfk_1` FOREIGN KEY (`awareness_program_id`) REFERENCES `awareness_programs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;


CREATE TABLE `awareness_program_ignored_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `awareness_program_id` int(11) NOT NULL,
  `uid` varchar(100) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `awareness_program_id` (`awareness_program_id`),
  CONSTRAINT `awareness_program_ignored_users_ibfk_1` FOREIGN KEY (`awareness_program_id`) REFERENCES `awareness_programs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `awareness_program_ldap_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `awareness_program_id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `awareness_program_id` (`awareness_program_id`),
  CONSTRAINT `awareness_program_ldap_groups_ibfk_1` FOREIGN KEY (`awareness_program_id`) REFERENCES `awareness_programs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `awareness_program_recurrences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `awareness_program_id` int(11) NOT NULL,
  `start` date NOT NULL,
  `awareness_training_count` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `awareness_program_id` (`awareness_program_id`),
  CONSTRAINT `awareness_program_recurrences_ibfk_1` FOREIGN KEY (`awareness_program_id`) REFERENCES `awareness_programs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `awareness_program_missed_recurrences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(100) NOT NULL,
  `awareness_program_id` int(11) DEFAULT NULL,
  `awareness_program_recurrence_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `awareness_program_recurrence_id` (`awareness_program_recurrence_id`),
  KEY `awareness_program_id` (`awareness_program_id`),
  CONSTRAINT `awareness_program_missed_recurrences_ibfk_2` FOREIGN KEY (`awareness_program_recurrence_id`) REFERENCES `awareness_program_recurrences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `awareness_program_missed_recurrences_ibfk_3` FOREIGN KEY (`awareness_program_id`) REFERENCES `awareness_programs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `awareness_program_not_compliant_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `awareness_program_id` int(11) NOT NULL,
  `uid` varchar(100) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `awareness_program_id` (`awareness_program_id`),
  CONSTRAINT `awareness_program_not_compliant_users_ibfk_1` FOREIGN KEY (`awareness_program_id`) REFERENCES `awareness_programs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `awareness_programs_security_policies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_policy_id` int(11) NOT NULL,
  `awareness_program_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_policy_id` (`security_policy_id`),
  KEY `awareness_program_id` (`awareness_program_id`),
  CONSTRAINT `awareness_programs_security_policies_ibfk_1` FOREIGN KEY (`awareness_program_id`) REFERENCES `awareness_programs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `awareness_programs_security_policies_ibfk_2` FOREIGN KEY (`security_policy_id`) REFERENCES `security_policies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `awareness_reminders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `awareness_program_id` int(11) NOT NULL,
  `demo` int(1) NOT NULL DEFAULT 0,
  `reminder_type` int(2) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `awareness_user_id` (`uid`),
  KEY `awareness_program_id` (`awareness_program_id`),
  CONSTRAINT `awareness_reminders_ibfk_1` FOREIGN KEY (`awareness_program_id`) REFERENCES `awareness_programs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `awareness_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(45) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `awareness_trainings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `awareness_user_id` int(11) NOT NULL,
  `awareness_program_id` int(11) DEFAULT NULL,
  `awareness_program_recurrence_id` int(11) DEFAULT NULL,
  `answers_json` text DEFAULT NULL,
  `correct` int(11) DEFAULT NULL,
  `wrong` int(11) DEFAULT NULL,
  `demo` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `awareness_user_id` (`awareness_user_id`),
  KEY `awareness_program_id` (`awareness_program_id`),
  KEY `awareness_program_recurrence_id` (`awareness_program_recurrence_id`),
  CONSTRAINT `awareness_trainings_ibfk_1` FOREIGN KEY (`awareness_user_id`) REFERENCES `awareness_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `awareness_trainings_ibfk_3` FOREIGN KEY (`awareness_program_id`) REFERENCES `awareness_programs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `awareness_trainings_ibfk_4` FOREIGN KEY (`awareness_program_recurrence_id`) REFERENCES `awareness_program_recurrences` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `backups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sql_file` varchar(255) NOT NULL,
  `deleted_files` int(4) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `bulk_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(2) NOT NULL,
  `model` varchar(150) NOT NULL,
  `json_data` text NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `bulk_actions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `bulk_action_objects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bulk_action_id` int(11) NOT NULL,
  `model` varchar(150) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bulk_action_objects_ibfk_1` (`bulk_action_id`),
  CONSTRAINT `bulk_action_objects_ibfk_1` FOREIGN KEY (`bulk_action_id`) REFERENCES `bulk_actions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `impact` text NOT NULL,
  `threats` text NOT NULL,
  `vulnerabilities` text NOT NULL,
  `description` text DEFAULT NULL,
  `residual_score` int(11) NOT NULL,
  `risk_score` float DEFAULT NULL,
  `risk_score_formula` text NOT NULL,
  `residual_risk` float NOT NULL,
  `residual_risk_formula` text NOT NULL,
  `review` date NOT NULL,
  `expired` int(1) NOT NULL DEFAULT 0,
  `exceptions_issues` int(1) NOT NULL DEFAULT 0,
  `controls_issues` int(1) NOT NULL DEFAULT 0,
  `control_in_design` int(1) NOT NULL DEFAULT 0,
  `expired_reviews` int(1) NOT NULL DEFAULT 0,
  `risk_above_appetite` int(1) NOT NULL DEFAULT 0,
  `plans_issues` int(1) NOT NULL DEFAULT 0,
  `risk_mitigation_strategy_id` int(11) DEFAULT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_mitigation_strategy_id` (`risk_mitigation_strategy_id`),
  FULLTEXT KEY `title` (`title`),
  CONSTRAINT `business_continuities_ibfk_2` FOREIGN KEY (`risk_mitigation_strategy_id`) REFERENCES `risk_mitigation_strategies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuities_business_continuity_plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_id` int(11) NOT NULL,
  `business_continuity_plan_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `business_continuity_id` (`business_continuity_id`),
  KEY `business_continuity_plan_id` (`business_continuity_plan_id`),
  CONSTRAINT `business_continuities_business_continuity_plans_ibfk_1` FOREIGN KEY (`business_continuity_id`) REFERENCES `business_continuities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `business_continuities_business_continuity_plans_ibfk_2` FOREIGN KEY (`business_continuity_plan_id`) REFERENCES `business_continuity_plans` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuities_business_units` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_id` int(11) NOT NULL,
  `business_unit_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `business_continuity_id` (`business_continuity_id`),
  KEY `business_unit_id` (`business_unit_id`),
  CONSTRAINT `business_continuities_business_units_ibfk_1` FOREIGN KEY (`business_continuity_id`) REFERENCES `business_continuities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `business_continuities_business_units_ibfk_2` FOREIGN KEY (`business_unit_id`) REFERENCES `business_units` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuities_compliance_managements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_id` int(11) NOT NULL,
  `compliance_management_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_management_id` (`compliance_management_id`),
  KEY `business_continuity_id` (`business_continuity_id`),
  CONSTRAINT `business_continuities_compliance_managements_ibfk_1` FOREIGN KEY (`business_continuity_id`) REFERENCES `business_continuities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `business_continuities_compliance_managements_ibfk_2` FOREIGN KEY (`compliance_management_id`) REFERENCES `compliance_managements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuities_goals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_id` int(11) NOT NULL,
  `goal_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `business_continuity_id` (`business_continuity_id`),
  KEY `goal_id` (`goal_id`),
  CONSTRAINT `business_continuities_goals_ibfk_1` FOREIGN KEY (`business_continuity_id`) REFERENCES `business_continuities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `business_continuities_goals_ibfk_2` FOREIGN KEY (`goal_id`) REFERENCES `goals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuities_processes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_id` int(11) NOT NULL,
  `process_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `business_continuity_id` (`business_continuity_id`),
  KEY `process_id` (`process_id`),
  CONSTRAINT `business_continuities_processes_ibfk_1` FOREIGN KEY (`business_continuity_id`) REFERENCES `business_continuities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `business_continuities_processes_ibfk_2` FOREIGN KEY (`process_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuities_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `business_continuity_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_business_continuities_projects_projects` (`project_id`),
  KEY `FK_business_continuities_projects_business_continuities` (`business_continuity_id`),
  CONSTRAINT `FK_business_continuities_projects_business_continuities` FOREIGN KEY (`business_continuity_id`) REFERENCES `business_continuities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_business_continuities_projects_projects` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuities_risk_classifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_id` int(11) NOT NULL,
  `risk_classification_id` int(11) NOT NULL,
  `type` int(3) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `business_continuity_id` (`business_continuity_id`),
  KEY `risk_classification_id` (`risk_classification_id`),
  CONSTRAINT `business_continuities_risk_classifications_ibfk_1` FOREIGN KEY (`business_continuity_id`) REFERENCES `business_continuities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `business_continuities_risk_classifications_ibfk_2` FOREIGN KEY (`risk_classification_id`) REFERENCES `risk_classifications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuities_risk_exceptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_id` int(11) NOT NULL,
  `risk_exception_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `business_continuity_id` (`business_continuity_id`),
  KEY `risk_exception_id` (`risk_exception_id`),
  CONSTRAINT `business_continuities_risk_exceptions_ibfk_1` FOREIGN KEY (`business_continuity_id`) REFERENCES `business_continuities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `business_continuities_risk_exceptions_ibfk_2` FOREIGN KEY (`risk_exception_id`) REFERENCES `risk_exceptions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuities_security_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_id` int(11) NOT NULL,
  `security_service_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuities_threats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_id` int(11) NOT NULL,
  `threat_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `business_continuity_id` (`business_continuity_id`),
  KEY `threat_id` (`threat_id`),
  CONSTRAINT `business_continuities_threats_ibfk_1` FOREIGN KEY (`business_continuity_id`) REFERENCES `business_continuities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `business_continuities_threats_ibfk_2` FOREIGN KEY (`threat_id`) REFERENCES `threats` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuities_vulnerabilities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_id` int(11) NOT NULL,
  `vulnerability_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `business_continuity_id` (`business_continuity_id`),
  KEY `vulnerability_id` (`vulnerability_id`),
  CONSTRAINT `business_continuities_vulnerabilities_ibfk_1` FOREIGN KEY (`business_continuity_id`) REFERENCES `business_continuities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `business_continuities_vulnerabilities_ibfk_2` FOREIGN KEY (`vulnerability_id`) REFERENCES `vulnerabilities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuity_plan_audit_dates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_plan_id` int(11) NOT NULL,
  `day` int(2) NOT NULL,
  `month` int(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `business_continuity_plan_id` (`business_continuity_plan_id`),
  CONSTRAINT `business_continuity_plan_audit_dates_ibfk_1` FOREIGN KEY (`business_continuity_plan_id`) REFERENCES `business_continuity_plans` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuity_plan_audit_improvements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_plan_audit_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `business_continuity_plan_audit_id` (`business_continuity_plan_audit_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `business_continuity_plan_audit_improvements_ibfk_1` FOREIGN KEY (`business_continuity_plan_audit_id`) REFERENCES `business_continuity_plan_audits` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `business_continuity_plan_audit_improvements_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuity_plan_audit_improvements_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_plan_audit_improvement_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `business_continuity_plan_audit_improvement_id` (`business_continuity_plan_audit_improvement_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `business_continuity_plan_audit_improvements_projects_ibfk_1` FOREIGN KEY (`business_continuity_plan_audit_improvement_id`) REFERENCES `business_continuity_plan_audit_improvements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `business_continuity_plan_audit_improvements_projects_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuity_plan_audit_improvements_security_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_plan_audit_improvement_id` int(11) NOT NULL,
  `security_incident_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `business_continuity_plan_audit_improvement_id` (`business_continuity_plan_audit_improvement_id`),
  KEY `security_incident_id` (`security_incident_id`),
  CONSTRAINT `business_continuity_plan_audit_improvements_incidents_ibfk_1` FOREIGN KEY (`business_continuity_plan_audit_improvement_id`) REFERENCES `business_continuity_plan_audit_improvements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `business_continuity_plan_audit_improvements_incidents_ibfk_2` FOREIGN KEY (`security_incident_id`) REFERENCES `security_incidents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuity_plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `objective` text NOT NULL,
  `audit_metric` text NOT NULL,
  `audit_success_criteria` text NOT NULL,
  `launch_criteria` text NOT NULL,
  `security_service_type_id` int(11) DEFAULT NULL,
  `opex` float NOT NULL,
  `capex` float NOT NULL,
  `resource_utilization` int(11) NOT NULL,
  `regular_review` date NOT NULL,
  `awareness_recurrence` varchar(150) DEFAULT NULL,
  `audits_all_done` int(1) NOT NULL,
  `audits_last_missing` int(1) NOT NULL,
  `audits_last_passed` int(1) NOT NULL,
  `audits_improvements` int(1) NOT NULL,
  `ongoing_corrective_actions` int(1) NOT NULL DEFAULT 0,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `security_service_type_id` (`security_service_type_id`),
  FULLTEXT KEY `title` (`title`),
  CONSTRAINT `business_continuity_plans_ibfk_1` FOREIGN KEY (`security_service_type_id`) REFERENCES `security_service_types` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuity_plan_audits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_plan_id` int(11) NOT NULL,
  `audit_metric_description` text NOT NULL,
  `audit_success_criteria` text NOT NULL,
  `result` int(1) DEFAULT NULL,
  `result_description` text NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `planned_date` date NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `business_continuity_plan_id` (`business_continuity_plan_id`),
  CONSTRAINT `business_continuity_plan_audits_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `business_continuity_plan_audits_ibfk_5` FOREIGN KEY (`business_continuity_plan_id`) REFERENCES `business_continuity_plans` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuity_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_plan_id` int(11) NOT NULL,
  `step` int(11) NOT NULL,
  `when` text NOT NULL,
  `who` text NOT NULL,
  `does` text NOT NULL,
  `where` text NOT NULL,
  `how` text NOT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `business_continuity_plan_id` (`business_continuity_plan_id`),
  CONSTRAINT `business_continuity_tasks_ibfk_3` FOREIGN KEY (`business_continuity_plan_id`) REFERENCES `business_continuity_plans` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_continuity_task_reminders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_continuity_task_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `seen` tinyint(1) NOT NULL DEFAULT 0,
  `acknowledged` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `business_continuity_task_id` (`business_continuity_task_id`),
  CONSTRAINT `business_continuity_task_reminders_ibfk_1` FOREIGN KEY (`business_continuity_task_id`) REFERENCES `business_continuity_tasks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_units` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `_hidden` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `business_units_data_assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_unit_id` int(11) NOT NULL,
  `data_asset_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `business_units_legals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_unit_id` int(11) NOT NULL,
  `legal_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `business_unit_id` (`business_unit_id`),
  KEY `legal_id` (`legal_id`),
  CONSTRAINT `business_units_legals_ibfk_1` FOREIGN KEY (`business_unit_id`) REFERENCES `business_units` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `business_units_legals_ibfk_2` FOREIGN KEY (`legal_id`) REFERENCES `legals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `cake_sessions` (
  `id` varchar(255) NOT NULL DEFAULT '',
  `data` text DEFAULT NULL,
  `expires` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL DEFAULT 0,
  `hash` varchar(255) NOT NULL DEFAULT '',
  `model` varchar(150) NOT NULL,
  `foreign_key` int(11) DEFAULT NULL,
  `message` text NOT NULL,
  `user_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_analysis_findings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `due_date` date DEFAULT NULL,
  `expired` int(1) NOT NULL DEFAULT 0,
  `status` int(3) NOT NULL DEFAULT 1,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_analysis_findings_compliance_managements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_analysis_finding_id` int(11) NOT NULL,
  `compliance_management_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_analysis_finding_id` (`compliance_analysis_finding_id`),
  KEY `compliance_management_id` (`compliance_management_id`),
  CONSTRAINT `compliance_analysis_findings_compliance_managements_ibfk_1` FOREIGN KEY (`compliance_analysis_finding_id`) REFERENCES `compliance_analysis_findings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_analysis_findings_compliance_managements_ibfk_2` FOREIGN KEY (`compliance_management_id`) REFERENCES `compliance_managements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_analysis_findings_compliance_package_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_analysis_finding_id` int(11) NOT NULL,
  `compliance_package_item_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_analysis_finding_id` (`compliance_analysis_finding_id`),
  KEY `compliance_package_item_id` (`compliance_package_item_id`),
  CONSTRAINT `compliance_analysis_findings_compliance_package_items_ibfk_1` FOREIGN KEY (`compliance_analysis_finding_id`) REFERENCES `compliance_analysis_findings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_analysis_findings_compliance_package_items_ibfk_2` FOREIGN KEY (`compliance_package_item_id`) REFERENCES `compliance_package_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_analysis_findings_compliance_package_regulators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_analysis_finding_id` int(11) NOT NULL,
  `compliance_package_regulator_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_analysis_finding_id` (`compliance_analysis_finding_id`),
  KEY `compliance_package_regulator_id` (`compliance_package_regulator_id`),
  CONSTRAINT `compliance_analysis_findings_join_ibfk_1` FOREIGN KEY (`compliance_analysis_finding_id`) REFERENCES `compliance_analysis_findings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_analysis_findings_join_ibfk_2` FOREIGN KEY (`compliance_package_regulator_id`) REFERENCES `compliance_package_regulators` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_audit_feedback_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `compliance_audit_feedback_count` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_audit_feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_audit_feedback_profile_id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_audit_feedback_profile_id` (`compliance_audit_feedback_profile_id`),
  CONSTRAINT `compliance_audit_feedbacks_ibfk_1` FOREIGN KEY (`compliance_audit_feedback_profile_id`) REFERENCES `compliance_audit_feedback_profiles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_audit_auditee_feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `compliance_audit_setting_id` int(11) NOT NULL,
  `compliance_audit_feedback_profile_id` int(11) NOT NULL,
  `compliance_audit_feedback_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_audit_setting_id` (`compliance_audit_setting_id`),
  KEY `compliance_audit_feedback_profile_id` (`compliance_audit_feedback_profile_id`),
  KEY `compliance_audit_feedback_id` (`compliance_audit_feedback_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `FK_compliance_audit_auditee_feedbacks_compliance_audit_feedback` FOREIGN KEY (`compliance_audit_feedback_id`) REFERENCES `compliance_audit_feedbacks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_compliance_audit_auditee_feedbacks_compliance_audit_settings` FOREIGN KEY (`compliance_audit_setting_id`) REFERENCES `compliance_audit_settings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_compliance_audit_auditee_feedbacks_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_audit_auditee_feedbacks_ibfk_3` FOREIGN KEY (`compliance_audit_feedback_profile_id`) REFERENCES `compliance_audit_feedback_profiles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_audit_feedbacks_compliance_audits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_audit_feedback_id` int(11) NOT NULL,
  `compliance_audit_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_audit_feedback_id` (`compliance_audit_feedback_id`),
  KEY `compliance_audit_id` (`compliance_audit_id`),
  CONSTRAINT `compliance_audit_feedbacks_compliance_audits_ibfk_1` FOREIGN KEY (`compliance_audit_feedback_id`) REFERENCES `compliance_audit_feedbacks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_audit_feedbacks_compliance_audits_ibfk_2` FOREIGN KEY (`compliance_audit_id`) REFERENCES `compliance_audits` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_audit_overtime_graphs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_audit_id` int(11) NOT NULL,
  `open` int(3) NOT NULL,
  `closed` int(3) NOT NULL,
  `expired` int(3) NOT NULL,
  `no_evidence` int(3) NOT NULL,
  `waiting_evidence` int(3) NOT NULL,
  `provided_evidence` int(3) NOT NULL,
  `timestamp` varchar(45) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_audit_id` (`compliance_audit_id`),
  CONSTRAINT `compliance_audit_overtime_graphs_ibfk_1` FOREIGN KEY (`compliance_audit_id`) REFERENCES `compliance_audits` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_audit_provided_feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `compliance_audit_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `compliance_audit_id` (`compliance_audit_id`),
  CONSTRAINT `compliance_audit_provided_feedbacks_ib_fk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_audit_provided_feedbacks_ib_fk_2` FOREIGN KEY (`compliance_audit_id`) REFERENCES `compliance_audits` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_audit_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_audit_id` int(11) NOT NULL,
  `compliance_package_item_id` int(11) NOT NULL,
  `status` int(1) DEFAULT NULL,
  `compliance_audit_feedback_profile_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_audit_id` (`compliance_audit_id`),
  KEY `compliance_package_item_id` (`compliance_package_item_id`),
  KEY `compliance_audit_feedback_profile_id` (`compliance_audit_feedback_profile_id`),
  CONSTRAINT `compliance_audit_settings_ibfk_1` FOREIGN KEY (`compliance_audit_id`) REFERENCES `compliance_audits` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_audit_settings_ibfk_2` FOREIGN KEY (`compliance_package_item_id`) REFERENCES `compliance_package_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_audit_settings_ibfk_4` FOREIGN KEY (`compliance_audit_feedback_profile_id`) REFERENCES `compliance_audit_feedback_profiles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_audit_setting_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_audit_setting_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_audit_setting_id` (`compliance_audit_setting_id`),
  CONSTRAINT `compliance_audit_setting_notifications_ibfk_1` FOREIGN KEY (`compliance_audit_setting_id`) REFERENCES `compliance_audit_settings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_audit_settings_auditees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_audit_setting_id` int(11) NOT NULL,
  `auditee_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_audit_setting_id` (`compliance_audit_setting_id`),
  KEY `auditee_id` (`auditee_id`),
  CONSTRAINT `compliance_audit_settings_auditees_ibfk_1` FOREIGN KEY (`compliance_audit_setting_id`) REFERENCES `compliance_audit_settings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_audit_settings_auditees_ibfk_2` FOREIGN KEY (`auditee_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_audits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `third_party_id` int(11) NOT NULL,
  `auditor_id` int(11) NOT NULL,
  `third_party_contact_id` int(11) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `auditee_title` varchar(155) NOT NULL,
  `auditee_instructions` text NOT NULL,
  `use_default_template` int(1) NOT NULL DEFAULT 1,
  `email_subject` varchar(255) NOT NULL,
  `email_body` text NOT NULL,
  `auditee_notifications` tinyint(1) NOT NULL DEFAULT 0,
  `auditee_emails` tinyint(1) NOT NULL DEFAULT 0,
  `auditor_notifications` tinyint(1) NOT NULL DEFAULT 0,
  `auditor_emails` tinyint(1) NOT NULL DEFAULT 0,
  `show_analyze_title` tinyint(1) NOT NULL DEFAULT 0,
  `show_analyze_description` tinyint(1) NOT NULL DEFAULT 0,
  `show_analyze_audit_criteria` tinyint(1) NOT NULL DEFAULT 0,
  `show_findings` tinyint(1) NOT NULL DEFAULT 0,
  `status` varchar(50) NOT NULL DEFAULT 'started' COMMENT 'started or stopped',
  `compliance_finding_count` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `third_party_id` (`third_party_id`),
  KEY `auditor_id` (`auditor_id`),
  KEY `third_party_contact_id` (`third_party_contact_id`),
  CONSTRAINT `compliance_audits_ibfk_1` FOREIGN KEY (`third_party_id`) REFERENCES `third_parties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_audits_ibfk_2` FOREIGN KEY (`auditor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_audits_ibfk_3` FOREIGN KEY (`third_party_contact_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_exceptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `expiration` date NOT NULL,
  `expired` int(1) NOT NULL DEFAULT 0,
  `closure_date_toggle` tinyint(1) NOT NULL DEFAULT 1,
  `closure_date` date DEFAULT NULL,
  `status` int(1) NOT NULL COMMENT '0-closed, 1-open',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_exceptions_compliance_findings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_exception_id` int(11) NOT NULL,
  `compliance_finding_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_exception_id` (`compliance_exception_id`),
  KEY `compliance_finding_id` (`compliance_finding_id`),
  CONSTRAINT `compliance_exceptions_compliance_findings_ibfk1` FOREIGN KEY (`compliance_exception_id`) REFERENCES `compliance_exceptions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_exceptions_compliance_findings_ibfk2` FOREIGN KEY (`compliance_finding_id`) REFERENCES `compliance_findings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_exceptions_compliance_managements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_exception_id` int(11) NOT NULL,
  `compliance_management_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_exception_id` (`compliance_exception_id`),
  KEY `compliance_management_id` (`compliance_management_id`),
  CONSTRAINT `compliance_exceptions_compliance_managements_ibfk_1` FOREIGN KEY (`compliance_exception_id`) REFERENCES `compliance_exceptions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_exceptions_compliance_managements_ibfk_2` FOREIGN KEY (`compliance_management_id`) REFERENCES `compliance_managements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_finding_classifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_finding_id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_finding_id` (`compliance_finding_id`),
  CONSTRAINT `compliance_finding_classifications_ibfk_1` FOREIGN KEY (`compliance_finding_id`) REFERENCES `compliance_findings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_finding_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_findings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `deadline` date DEFAULT NULL,
  `expired` int(1) NOT NULL DEFAULT 0,
  `compliance_finding_status_id` int(11) DEFAULT NULL,
  `compliance_audit_id` int(11) NOT NULL,
  `compliance_package_item_id` int(11) DEFAULT NULL,
  `type` int(1) NOT NULL DEFAULT 1 COMMENT '1-audit finding, 2-assesed item',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_finding_status_id` (`compliance_finding_status_id`),
  KEY `compliance_audit_id` (`compliance_audit_id`),
  KEY `compliance_package_item_id` (`compliance_package_item_id`),
  CONSTRAINT `compliance_findings_ibfk_1` FOREIGN KEY (`compliance_finding_status_id`) REFERENCES `compliance_finding_statuses` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `compliance_findings_ibfk_2` FOREIGN KEY (`compliance_audit_id`) REFERENCES `compliance_audits` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_findings_ibfk_3` FOREIGN KEY (`compliance_package_item_id`) REFERENCES `compliance_package_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_findings_third_party_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_finding_id` int(11) NOT NULL,
  `third_party_risk_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_finding_id` (`compliance_finding_id`),
  KEY `third_party_risk_id` (`third_party_risk_id`),
  CONSTRAINT `compliance_findings_third_party_risks_ibfk1` FOREIGN KEY (`compliance_finding_id`) REFERENCES `compliance_findings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_findings_third_party_risks_ibfk2` FOREIGN KEY (`third_party_risk_id`) REFERENCES `third_party_risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_managements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_package_item_id` int(11) NOT NULL,
  `compliance_treatment_strategy_id` int(11) DEFAULT NULL,
  `legal_id` int(11) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `efficacy` int(3) NOT NULL,
  `description` text NOT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_package_item_id` (`compliance_package_item_id`),
  KEY `compliance_treatment_strategy_id` (`compliance_treatment_strategy_id`),
  KEY `FK_compliance_managements_legals` (`legal_id`),
  KEY `idx_owner_id` (`owner_id`),
  CONSTRAINT `FK_compliance_managements_legals` FOREIGN KEY (`legal_id`) REFERENCES `legals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_managements_ibfk_1` FOREIGN KEY (`compliance_package_item_id`) REFERENCES `compliance_package_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_managements_ibfk_2` FOREIGN KEY (`compliance_treatment_strategy_id`) REFERENCES `compliance_treatment_strategies` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `compliance_managements_ibfk_3` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_managements_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_management_id` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_compliance_managements_projects_compliance_managements` (`compliance_management_id`),
  KEY `FK_compliance_managements_projects_projects` (`project_id`),
  CONSTRAINT `FK_compliance_managements_projects_compliance_managements` FOREIGN KEY (`compliance_management_id`) REFERENCES `compliance_managements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_compliance_managements_projects_projects` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_managements_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_management_id` int(11) NOT NULL,
  `risk_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_id` (`risk_id`),
  KEY `compliance_management_id` (`compliance_management_id`),
  CONSTRAINT `compliance_managements_risks_ibfk_1` FOREIGN KEY (`compliance_management_id`) REFERENCES `compliance_managements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_managements_risks_ibfk_2` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_managements_security_policies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_management_id` int(11) NOT NULL,
  `security_policy_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_management_id` (`compliance_management_id`),
  KEY `security_policy_id` (`security_policy_id`),
  CONSTRAINT `compliance_managements_security_policies_ibfk_1` FOREIGN KEY (`compliance_management_id`) REFERENCES `compliance_managements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_managements_security_policies_ibfk_2` FOREIGN KEY (`security_policy_id`) REFERENCES `security_policies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_managements_security_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_management_id` int(11) NOT NULL,
  `security_service_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_management_id` (`compliance_management_id`),
  KEY `security_service_id` (`security_service_id`),
  CONSTRAINT `compliance_managements_security_services_ibfk_1` FOREIGN KEY (`compliance_management_id`) REFERENCES `compliance_managements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_managements_security_services_ibfk_2` FOREIGN KEY (`security_service_id`) REFERENCES `security_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_managements_third_party_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_management_id` int(11) NOT NULL,
  `third_party_risk_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_management_id` (`compliance_management_id`),
  KEY `third_party_risk_id` (`third_party_risk_id`),
  CONSTRAINT `compliance_managements_third_party_risks_ibfk_1` FOREIGN KEY (`compliance_management_id`) REFERENCES `compliance_managements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_managements_third_party_risks_ibfk_2` FOREIGN KEY (`third_party_risk_id`) REFERENCES `third_party_risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_package_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `audit_questionaire` text NOT NULL,
  `compliance_package_id` int(11) NOT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_package_id` (`compliance_package_id`),
  CONSTRAINT `compliance_package_items_ibfk_1` FOREIGN KEY (`compliance_package_id`) REFERENCES `compliance_packages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_package_regulators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` text NOT NULL,
  `publisher_name` varchar(128) NOT NULL,
  `version` varchar(128) NOT NULL,
  `language` varchar(128) NOT NULL,
  `url` text NOT NULL,
  `restriction` int(3) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `name` (`name`),
  FULLTEXT KEY `name_2` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `compliance_package_regulators_legals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compliance_package_regulator_id` int(11) NOT NULL,
  `legal_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `compliance_package_regulator_id` (`compliance_package_regulator_id`),
  KEY `legal_id` (`legal_id`),
  CONSTRAINT `compliance_package_regulators_legals_ibfk_1` FOREIGN KEY (`compliance_package_regulator_id`) REFERENCES `compliance_package_regulators` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `compliance_package_regulators_legals_ibfk_2` FOREIGN KEY (`legal_id`) REFERENCES `legals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_packages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `package_id` varchar(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `compliance_package_regulator_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_compliance_package_regulator_id` (`compliance_package_regulator_id`),
  CONSTRAINT `compliance_packages_ibfk_1` FOREIGN KEY (`compliance_package_regulator_id`) REFERENCES `compliance_package_regulators` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;


CREATE TABLE `compliance_treatment_strategies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


CREATE TABLE `concurrent_edits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `last_update` datetime NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `concurrent_edits_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(3) DEFAULT NULL,
  `model` varchar(50) NOT NULL DEFAULT '',
  `foreign_key` int(11) NOT NULL,
  `country_id` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `foreign_key` (`foreign_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `cron` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(128) NOT NULL,
  `execution_time` float DEFAULT NULL,
  `status` varchar(128) DEFAULT 'success',
  `request_id` varchar(36) DEFAULT NULL,
  `created` datetime NOT NULL,
  `completed` datetime DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `cron_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cron_id` int(11) NOT NULL,
  `task` varchar(128) NOT NULL DEFAULT '',
  `status` int(3) NOT NULL DEFAULT 0,
  `execution_time` float DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `completed` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cron_id` (`cron_id`),
  CONSTRAINT `cron_tasks_ibfk_1` FOREIGN KEY (`cron_id`) REFERENCES `cron` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `custom_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `custom_form_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `type` int(3) NOT NULL,
  `mandatory` int(11) NOT NULL DEFAULT 0,
  `description` text NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `custom_form_id` (`custom_form_id`),
  CONSTRAINT `FK_custom_fields_custom_forms` FOREIGN KEY (`custom_form_id`) REFERENCES `custom_forms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `custom_field_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `custom_field_id` int(11) NOT NULL,
  `value` varchar(155) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `custom_field_id` (`custom_field_id`),
  CONSTRAINT `FK_custom_field_options_custom_fields` FOREIGN KEY (`custom_field_id`) REFERENCES `custom_fields` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `custom_field_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(155) NOT NULL,
  `status` int(3) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `model` (`model`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;


CREATE TABLE `custom_field_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `custom_field_id` int(11) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `field_name` (`custom_field_id`),
  KEY `model` (`model`),
  KEY `foreign_key` (`foreign_key`),
  CONSTRAINT `FK_custom_field_values_custom_fields` FOREIGN KEY (`custom_field_id`) REFERENCES `custom_fields` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `custom_forms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(155) NOT NULL,
  `name` varchar(155) NOT NULL,
  `slug` varchar(155) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `model` (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `custom_labels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `model` varchar(255) NOT NULL DEFAULT '',
  `subject` varchar(255) NOT NULL DEFAULT '',
  `label` varchar(255) DEFAULT '',
  `description` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `custom_roles_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `custom_roles_groups_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;


CREATE TABLE `custom_roles_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(155) DEFAULT NULL,
  `field` varchar(155) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_model` (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `custom_roles_role_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(155) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `custom_roles_role_id` int(11) NOT NULL,
  `group_id` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `custom_roles_role_id` (`custom_roles_role_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `custom_roles_role_groups_ibfk_1` FOREIGN KEY (`custom_roles_role_id`) REFERENCES `custom_roles_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `custom_roles_role_groups_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `custom_roles_role_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(155) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `custom_roles_role_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `custom_roles_role_id` (`custom_roles_role_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `custom_roles_role_users_ibfk_1` FOREIGN KEY (`custom_roles_role_id`) REFERENCES `custom_roles_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `custom_roles_role_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `custom_roles_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `custom_roles_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `custom_validator_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL DEFAULT '',
  `validator` varchar(255) NOT NULL DEFAULT '',
  `field` varchar(255) NOT NULL DEFAULT '',
  `type` int(11) NOT NULL,
  `validation` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `dashboard_calendar_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL DEFAULT '',
  `foreign_key` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `start` date NOT NULL,
  `end` date DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `dashboard_kpi_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kpi_id` int(11) NOT NULL,
  `model` varchar(128) DEFAULT NULL,
  `foreign_key` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `kpi_id` (`kpi_id`),
  CONSTRAINT `dashboard_kpi_attributes_ibfk_1` FOREIGN KEY (`kpi_id`) REFERENCES `dashboard_kpis` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `dashboard_kpi_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kpi_id` int(11) NOT NULL DEFAULT 0,
  `value` int(7) NOT NULL,
  `timestamp` int(10) NOT NULL,
  `current_timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `kpi_id` (`kpi_id`),
  CONSTRAINT `dashboard_kpi_logs_ibfk_1` FOREIGN KEY (`kpi_id`) REFERENCES `dashboard_kpis` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `dashboard_kpi_thresholds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kpi_id` int(11) NOT NULL,
  `title` varchar(155) NOT NULL,
  `description` text NOT NULL,
  `color` text NOT NULL,
  `type` int(3) NOT NULL DEFAULT 0,
  `min` int(11) DEFAULT NULL,
  `max` int(11) DEFAULT NULL,
  `percentage` int(3) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `kpi_id` (`kpi_id`),
  CONSTRAINT `dashboard_kpi_thresholds_ibfk_1` FOREIGN KEY (`kpi_id`) REFERENCES `dashboard_kpis` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `dashboard_kpi_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kpi_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `value` int(8) DEFAULT NULL,
  `type` int(3) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `kpi_id` (`kpi_id`),
  CONSTRAINT `dashboard_kpi_values_ibfk_1` FOREIGN KEY (`kpi_id`) REFERENCES `dashboard_kpis` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `dashboard_kpi_value_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kpi_value_id` int(11) NOT NULL DEFAULT 0,
  `kpi_id` int(11) NOT NULL DEFAULT 0,
  `value` int(7) NOT NULL DEFAULT 0,
  `request_id` varchar(36) DEFAULT NULL,
  `timestamp` int(10) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `kpi_value_id` (`kpi_value_id`),
  CONSTRAINT `dashboard_kpi_value_logs_ibfk_1` FOREIGN KEY (`kpi_value_id`) REFERENCES `dashboard_kpi_values` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `dashboard_kpis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_name` varchar(155) DEFAULT NULL,
  `title` varchar(155) DEFAULT NULL,
  `model` varchar(155) NOT NULL DEFAULT '',
  `type` int(3) NOT NULL DEFAULT 0,
  `category` int(3) NOT NULL DEFAULT 0,
  `owner_id` int(11) DEFAULT NULL,
  `dashboard_kpi_attribute_count` int(11) NOT NULL DEFAULT 0,
  `json` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `value` int(8) DEFAULT NULL,
  `status` int(3) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `dashboard_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(3) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_asset_gdpr` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_asset_id` int(11) NOT NULL,
  `purpose` text NOT NULL,
  `right_to_be_informed` text NOT NULL,
  `data_subject` text NOT NULL,
  `volume` text NOT NULL,
  `recived_data` text NOT NULL,
  `contracts` text NOT NULL,
  `retention` text NOT NULL,
  `encryption` text NOT NULL,
  `right_to_erasure` text NOT NULL,
  `archiving_driver_empty` int(3) NOT NULL DEFAULT 0,
  `origin` text NOT NULL,
  `destination` text NOT NULL,
  `transfer_outside_eea` int(3) NOT NULL DEFAULT 0,
  `third_party_involved_all` int(3) NOT NULL DEFAULT 0,
  `security` text NOT NULL,
  `right_to_portability` text NOT NULL,
  `stakeholders` text NOT NULL,
  `accuracy` text NOT NULL,
  `right_to_access` text NOT NULL,
  `right_to_rectification` text NOT NULL,
  `right_to_decision` text NOT NULL,
  `right_to_object` text NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_asset_id` (`data_asset_id`),
  CONSTRAINT `data_asset_gdpr_ibfk_1` FOREIGN KEY (`data_asset_id`) REFERENCES `data_assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_asset_gdpr_archiving_drivers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_asset_gdpr_id` int(11) NOT NULL,
  `archiving_driver` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_asset_gdpr_id` (`data_asset_gdpr_id`),
  CONSTRAINT `data_asset_gdpr_archiving_drivers_ibfk_1` FOREIGN KEY (`data_asset_gdpr_id`) REFERENCES `data_asset_gdpr` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_asset_gdpr_collection_methods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_asset_gdpr_id` int(11) NOT NULL,
  `collection_method` int(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_asset_gdpr_id` (`data_asset_gdpr_id`),
  CONSTRAINT `data_asset_gdpr_collection_methods_ibfk_1` FOREIGN KEY (`data_asset_gdpr_id`) REFERENCES `data_asset_gdpr` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_asset_gdpr_data_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_asset_gdpr_id` int(11) NOT NULL,
  `data_type` int(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_asset_gdpr_id` (`data_asset_gdpr_id`),
  CONSTRAINT `data_asset_gdpr_data_types_ibfk_1` FOREIGN KEY (`data_asset_gdpr_id`) REFERENCES `data_asset_gdpr` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_asset_gdpr_lawful_bases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_asset_gdpr_id` int(11) NOT NULL,
  `lawful_base` int(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_asset_gdpr_id` (`data_asset_gdpr_id`),
  CONSTRAINT `data_asset_gdpr_lawful_bases_ibfk_1` FOREIGN KEY (`data_asset_gdpr_id`) REFERENCES `data_asset_gdpr` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_asset_gdpr_third_party_countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_asset_gdpr_id` int(11) NOT NULL,
  `third_party_country` int(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_asset_gdpr_id` (`data_asset_gdpr_id`),
  CONSTRAINT `data_asset_gdpr_third_party_countries_ibfk_1` FOREIGN KEY (`data_asset_gdpr_id`) REFERENCES `data_asset_gdpr` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_asset_instances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL,
  `analysis_unlocked` int(3) NOT NULL DEFAULT 0,
  `asset_missing_review` int(3) NOT NULL DEFAULT 0,
  `controls_with_issues` int(3) NOT NULL DEFAULT 0,
  `controls_with_failed_audits` int(3) NOT NULL DEFAULT 0,
  `controls_with_missing_audits` int(3) NOT NULL DEFAULT 0,
  `policies_with_missing_reviews` int(3) NOT NULL DEFAULT 0,
  `risks_with_missing_reviews` int(3) NOT NULL DEFAULT 0,
  `project_expired` int(3) NOT NULL DEFAULT 0,
  `expired_tasks` int(3) NOT NULL DEFAULT 0,
  `incomplete_analysis` int(3) NOT NULL DEFAULT 0,
  `incomplete_gdpr_analysis` int(3) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_id` (`asset_id`),
  CONSTRAINT `data_asset_instances_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_asset_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `data_asset_instance_id` int(11) NOT NULL,
  `gdpr_enabled` int(1) NOT NULL,
  `driver_for_compliance` text NOT NULL,
  `dpo_empty` int(3) NOT NULL DEFAULT 0,
  `processor_empty` int(3) NOT NULL DEFAULT 0,
  `controller_empty` int(3) NOT NULL DEFAULT 0,
  `controller_representative_empty` int(3) DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_asset_instance_id` (`data_asset_instance_id`),
  CONSTRAINT `data_asset_settings_ibfk_1` FOREIGN KEY (`data_asset_instance_id`) REFERENCES `data_asset_instances` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_asset_settings_third_parties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL DEFAULT '',
  `data_asset_setting_id` int(11) NOT NULL,
  `third_party_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_asset_setting_id` (`data_asset_setting_id`),
  KEY `third_party_id` (`third_party_id`),
  CONSTRAINT `data_asset_settings_third_parties_ibfk_1` FOREIGN KEY (`data_asset_setting_id`) REFERENCES `data_asset_settings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `data_asset_settings_third_parties_ibfk_2` FOREIGN KEY (`third_party_id`) REFERENCES `third_parties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_asset_settings_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `data_asset_setting_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_asset_setting_id` (`data_asset_setting_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `data_asset_settings_users_ibfk_1` FOREIGN KEY (`data_asset_setting_id`) REFERENCES `data_asset_settings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `data_asset_settings_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_asset_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;


CREATE TABLE `data_assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `data_asset_instance_id` int(11) NOT NULL,
  `order` int(11) NOT NULL DEFAULT 0,
  `data_asset_status_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `data_asset_status_id` (`data_asset_status_id`),
  KEY `FK_data_assets_data_asset_instances` (`data_asset_instance_id`),
  KEY `FK_data_assets_data_assets` (`order`),
  CONSTRAINT `data_assets_ibfk_2` FOREIGN KEY (`data_asset_status_id`) REFERENCES `data_asset_statuses` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `data_assets_ibfk_4` FOREIGN KEY (`data_asset_instance_id`) REFERENCES `data_asset_instances` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_assets_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `data_asset_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_data_assets_projects_projects` (`project_id`),
  KEY `FK_data_assets_projects_data_assets` (`data_asset_id`),
  CONSTRAINT `FK_data_assets_projects_data_assets` FOREIGN KEY (`data_asset_id`) REFERENCES `data_assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_data_assets_projects_projects` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_assets_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(20) NOT NULL DEFAULT '0',
  `data_asset_id` int(11) NOT NULL,
  `risk_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_asset_id` (`data_asset_id`),
  KEY `risk_id` (`risk_id`),
  CONSTRAINT `data_assets_risks_ibfk_1` FOREIGN KEY (`data_asset_id`) REFERENCES `data_assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_assets_security_policies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_asset_id` int(11) NOT NULL,
  `security_policy_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_asset_id` (`data_asset_id`),
  KEY `security_policy_id` (`security_policy_id`),
  CONSTRAINT `data_assets_security_policies_ibfk_1` FOREIGN KEY (`data_asset_id`) REFERENCES `data_assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `data_assets_security_policies_ibfk_2` FOREIGN KEY (`security_policy_id`) REFERENCES `security_policies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_assets_security_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_asset_id` int(11) NOT NULL,
  `security_service_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_asset_id` (`data_asset_id`),
  KEY `security_service_id` (`security_service_id`),
  CONSTRAINT `data_assets_security_services_ibfk_1` FOREIGN KEY (`data_asset_id`) REFERENCES `data_assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `data_assets_security_services_ibfk_2` FOREIGN KEY (`security_service_id`) REFERENCES `security_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `data_assets_third_parties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_asset_id` int(11) NOT NULL,
  `third_party_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `data_asset_id` (`data_asset_id`),
  KEY `third_party_id` (`third_party_id`),
  CONSTRAINT `data_assets_third_parties_ibfk_1` FOREIGN KEY (`data_asset_id`) REFERENCES `data_assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `data_assets_third_parties_ibfk_2` FOREIGN KEY (`third_party_id`) REFERENCES `third_parties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `goal_audit_dates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goal_id` int(11) NOT NULL,
  `day` int(2) NOT NULL,
  `month` int(2) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goal_id` (`goal_id`),
  CONSTRAINT `goal_audit_dates_ibfk_1` FOREIGN KEY (`goal_id`) REFERENCES `goals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `goal_audit_improvements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goal_audit_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goal_audit_id` (`goal_audit_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `goal_audit_improvements_ibfk_1` FOREIGN KEY (`goal_audit_id`) REFERENCES `goal_audits` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `goal_audit_improvements_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `goal_audit_improvements_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goal_audit_improvement_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goal_audit_improvement_id` (`goal_audit_improvement_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `goal_audit_improvements_projects_ibfk_1` FOREIGN KEY (`goal_audit_improvement_id`) REFERENCES `goal_audit_improvements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `goal_audit_improvements_projects_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `goal_audit_improvements_security_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goal_audit_improvement_id` int(11) NOT NULL,
  `security_incident_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goal_audit_improvement_id` (`goal_audit_improvement_id`),
  KEY `security_incident_id` (`security_incident_id`),
  CONSTRAINT `goal_audit_improvements_security_incidents_ibfk_1` FOREIGN KEY (`goal_audit_improvement_id`) REFERENCES `goal_audit_improvements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `goal_audit_improvements_security_incidents_ibfk_2` FOREIGN KEY (`security_incident_id`) REFERENCES `security_incidents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `goals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(155) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `description` text NOT NULL,
  `audit_metric` text NOT NULL,
  `audit_criteria` text NOT NULL,
  `metrics_last_missing` int(1) NOT NULL,
  `ongoing_corrective_actions` int(1) NOT NULL DEFAULT 0,
  `status` enum('draft','discarded','current') NOT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `goals_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `goal_audits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goal_id` int(11) NOT NULL,
  `audit_metric_description` text NOT NULL,
  `audit_success_criteria` text NOT NULL,
  `result` int(1) DEFAULT NULL COMMENT 'null-not defined, 0-fail, 1-pass',
  `result_description` text NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `planned_date` date NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `goal_id` (`goal_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `goal_audits_ibfk_1` FOREIGN KEY (`goal_id`) REFERENCES `goals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `goal_audits_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `goals_program_issues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goal_id` int(11) NOT NULL,
  `program_issue_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goal_id` (`goal_id`),
  KEY `program_issue_id` (`program_issue_id`),
  CONSTRAINT `goals_program_issues_ibfk_1` FOREIGN KEY (`goal_id`) REFERENCES `goals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `goals_program_issues_ibfk_2` FOREIGN KEY (`program_issue_id`) REFERENCES `program_issues` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `goals_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goal_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goal_id` (`goal_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `goals_projects_ibfk_1` FOREIGN KEY (`goal_id`) REFERENCES `goals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `goals_projects_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `goals_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goal_id` int(11) NOT NULL,
  `risk_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goal_id` (`goal_id`),
  KEY `risk_id` (`risk_id`),
  CONSTRAINT `goals_risks_ibfk_1` FOREIGN KEY (`goal_id`) REFERENCES `goals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `goals_risks_ibfk_2` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `goals_security_policies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goal_id` int(11) NOT NULL,
  `security_policy_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goal_id` (`goal_id`),
  KEY `security_policy_id` (`security_policy_id`),
  CONSTRAINT `goals_security_policies_ibfk_1` FOREIGN KEY (`goal_id`) REFERENCES `goals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `goals_security_policies_ibfk_2` FOREIGN KEY (`security_policy_id`) REFERENCES `security_policies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `goals_security_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goal_id` int(11) NOT NULL,
  `security_service_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goal_id` (`goal_id`),
  KEY `security_service_id` (`security_service_id`),
  CONSTRAINT `goals_security_services_ibfk_1` FOREIGN KEY (`goal_id`) REFERENCES `goals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `goals_security_services_ibfk_2` FOREIGN KEY (`security_service_id`) REFERENCES `security_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `goals_third_party_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goal_id` int(11) NOT NULL,
  `third_party_risk_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goal_id` (`goal_id`),
  KEY `third_party_risk_id` (`third_party_risk_id`),
  CONSTRAINT `goals_third_party_risks_ibfk_1` FOREIGN KEY (`goal_id`) REFERENCES `goals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `goals_third_party_risks_ibfk_2` FOREIGN KEY (`third_party_risk_id`) REFERENCES `third_party_risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `status` int(11) DEFAULT 1 COMMENT '0-non active, 1-active',
  `slug` varchar(100) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  FULLTEXT KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;


CREATE TABLE `issues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(150) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `date_start` date NOT NULL,
  `date_end` date DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `description` text NOT NULL,
  `status` enum('open','closed') NOT NULL DEFAULT 'open',
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_issues_users` (`user_id`),
  CONSTRAINT `FK_issues_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `ldap_connector_authentication` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auth_users` int(1) NOT NULL,
  `auth_users_id` int(11) DEFAULT NULL,
  `oauth_google` int(1) NOT NULL,
  `oauth_google_id` int(11) NOT NULL,
  `auth_saml` int(1) NOT NULL,
  `saml_connector_id` int(11) DEFAULT NULL,
  `auth_awareness` int(1) NOT NULL,
  `auth_awareness_id` int(11) DEFAULT NULL,
  `auth_policies` int(1) NOT NULL,
  `auth_policies_id` int(11) DEFAULT NULL,
  `auth_compliance_audit` int(1) NOT NULL DEFAULT 0,
  `auth_vendor_assessment` int(1) NOT NULL DEFAULT 0,
  `auth_account_review` int(1) NOT NULL DEFAULT 0,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `auth_users_id` (`auth_users_id`),
  KEY `auth_awareness_id` (`auth_awareness_id`),
  KEY `auth_policies_id` (`auth_policies_id`),
  KEY `saml_connector_id` (`saml_connector_id`),
  CONSTRAINT `ldap_connector_authentication_ibfk_1` FOREIGN KEY (`auth_users_id`) REFERENCES `ldap_connectors` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `ldap_connector_authentication_ibfk_2` FOREIGN KEY (`auth_awareness_id`) REFERENCES `ldap_connectors` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `ldap_connector_authentication_ibfk_3` FOREIGN KEY (`auth_policies_id`) REFERENCES `ldap_connectors` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `ldap_connector_authentication_ibfk_4` FOREIGN KEY (`saml_connector_id`) REFERENCES `saml_connectors` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `ldap_synchronizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `ldap_auth_connector_id` int(11) NOT NULL,
  `ldap_group_connector_id` int(11) NOT NULL,
  `ldap_group` varchar(255) NOT NULL,
  `status` int(1) NOT NULL DEFAULT 1,
  `language` varchar(10) NOT NULL,
  `api` int(1) NOT NULL,
  `no_user_action` int(3) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ldap_auth_connector_id` (`ldap_auth_connector_id`),
  KEY `ldap_group_connector_id` (`ldap_group_connector_id`),
  CONSTRAINT `ldap_synchronizations_ibfk_1` FOREIGN KEY (`ldap_auth_connector_id`) REFERENCES `ldap_connectors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ldap_synchronizations_ibfk_2` FOREIGN KEY (`ldap_group_connector_id`) REFERENCES `ldap_connectors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `ldap_synchronizations_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ldap_synchronization_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ldap_synchronization_id` (`ldap_synchronization_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `ldap_synchronizations_groups_ibfk_1` FOREIGN KEY (`ldap_synchronization_id`) REFERENCES `ldap_synchronizations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ldap_synchronizations_groups_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `ldap_synchronizations_portals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ldap_synchronization_id` int(11) NOT NULL,
  `portal_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ldap_synchronization_id` (`ldap_synchronization_id`),
  KEY `portal_id` (`portal_id`),
  CONSTRAINT `ldap_synchronizations_portals_ibfk_1` FOREIGN KEY (`ldap_synchronization_id`) REFERENCES `ldap_synchronizations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ldap_synchronizations_portals_ibfk_2` FOREIGN KEY (`portal_id`) REFERENCES `portals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `legals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `risk_magnifier` float DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `legals_third_parties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `legal_id` int(11) NOT NULL,
  `third_party_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `legal_id` (`legal_id`),
  KEY `third_party_id` (`third_party_id`),
  CONSTRAINT `legals_third_parties_ibfk_1` FOREIGN KEY (`legal_id`) REFERENCES `legals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `legals_third_parties_ibfk_2` FOREIGN KEY (`third_party_id`) REFERENCES `third_parties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `log_security_policies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_policy_id` int(11) NOT NULL,
  `index` varchar(100) NOT NULL,
  `short_description` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `document_type` enum('policy','standard','procedure') NOT NULL,
  `version` varchar(50) NOT NULL,
  `published_date` date NOT NULL,
  `next_review_date` date NOT NULL,
  `permission` enum('public','private','logged') NOT NULL,
  `ldap_connector_id` int(11) DEFAULT NULL,
  `asset_label_id` int(11) DEFAULT NULL,
  `user_edit_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `mapping_relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `left_model` varchar(128) NOT NULL,
  `left_foreign_key` int(11) NOT NULL,
  `right_model` varchar(128) NOT NULL,
  `right_foreign_key` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `left_foreign_key` (`left_foreign_key`),
  KEY `right_foreign_key` (`right_foreign_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `support_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  `content` text NOT NULL,
  `date` datetime DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `notification_system_item_custom_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(3) NOT NULL DEFAULT 0,
  `notification_system_item_id` int(11) NOT NULL,
  `custom_identifier` varchar(255) DEFAULT NULL,
  `migration_updated` int(3) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notification_system_item_id` (`notification_system_item_id`),
  CONSTRAINT `notification_system_item_custom_roles_ibfk_1` FOREIGN KEY (`notification_system_item_id`) REFERENCES `notification_system_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `notification_system_items_objects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notification_system_item_id` int(11) NOT NULL,
  `model` varchar(250) NOT NULL,
  `foreign_key` int(11) DEFAULT NULL,
  `status_feedback` int(2) NOT NULL DEFAULT 0 COMMENT '0-ok, 1- waiting for feedback, 2-feedback ignored',
  `log_count` int(11) NOT NULL,
  `status` int(1) NOT NULL DEFAULT 1 COMMENT '0-disabled, 1-enabled',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notification_system_item_id` (`notification_system_item_id`),
  CONSTRAINT `notification_system_items_objects_ibfk_1` FOREIGN KEY (`notification_system_item_id`) REFERENCES `notification_system_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `notification_system_item_custom_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notification_system_item_object_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `notification_system_item_object_id` (`notification_system_item_object_id`),
  CONSTRAINT `notification_system_item_custom_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notification_system_item_custom_users_ibfk_3` FOREIGN KEY (`notification_system_item_object_id`) REFERENCES `notification_system_items_objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `notification_system_item_emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(3) NOT NULL DEFAULT 0,
  `notification_system_item_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notification_system_item_id` (`notification_system_item_id`),
  CONSTRAINT `notification_system_item_emails_ibfk_1` FOREIGN KEY (`notification_system_item_id`) REFERENCES `notification_system_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `notification_system_item_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notification_system_item_object_id` int(11) NOT NULL,
  `hash` text DEFAULT NULL,
  `is_new` int(1) NOT NULL DEFAULT 1 COMMENT '1-new, 0-reminder',
  `feedback_resolved` int(1) DEFAULT 0 COMMENT '1-feedback entered',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notification_system_item_object_id` (`notification_system_item_object_id`),
  CONSTRAINT `notification_system_item_logs_ibfk_1` FOREIGN KEY (`notification_system_item_object_id`) REFERENCES `notification_system_items_objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `notification_system_item_feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notification_system_item_log_id` int(11) NOT NULL,
  `notification_system_item_object_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `comment` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notification_system_item_log_id` (`notification_system_item_log_id`),
  KEY `user_id` (`user_id`),
  KEY `notification_system_item_object_id` (`notification_system_item_object_id`),
  CONSTRAINT `notification_system_item_feedbacks_ibfk_1` FOREIGN KEY (`notification_system_item_log_id`) REFERENCES `notification_system_item_logs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notification_system_item_feedbacks_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notification_system_item_feedbacks_ibfk_4` FOREIGN KEY (`notification_system_item_object_id`) REFERENCES `notification_system_items_objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `notification_system_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `description` text NOT NULL,
  `model` varchar(255) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `feedback` int(1) NOT NULL DEFAULT 0,
  `feedback_message` text NOT NULL,
  `chase_interval` int(2) DEFAULT NULL,
  `chase_amount` int(3) DEFAULT NULL COMMENT 'how many times a notification will be remindered',
  `trigger_period` int(5) DEFAULT NULL COMMENT 'awareness uses this field',
  `automated` int(1) NOT NULL DEFAULT 1,
  `email_customized` int(1) NOT NULL DEFAULT 1,
  `email_subject` varchar(255) NOT NULL,
  `email_body` text NOT NULL,
  `email_type` int(2) NOT NULL DEFAULT 0,
  `report_send_empty_results` int(2) unsigned DEFAULT NULL,
  `report_attachment_type` int(2) unsigned DEFAULT NULL,
  `advanced_filter_id` int(11) DEFAULT NULL,
  `report_id` int(11) DEFAULT NULL,
  `type` varchar(45) NOT NULL,
  `status_feedback` int(2) NOT NULL DEFAULT 0 COMMENT '0-ok, 1- waiting for feedback, 2-feedback ignored',
  `feedback_show_item` int(3) NOT NULL DEFAULT 0,
  `feedback_report_id` int(11) DEFAULT NULL,
  `feedback_completed_notification` int(3) NOT NULL DEFAULT 0,
  `log_count` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `advanced_filter_id` (`advanced_filter_id`),
  KEY `idx_report_id` (`report_id`),
  KEY `idx_feedback_report_id` (`feedback_report_id`),
  CONSTRAINT `notification_system_items_ibfk_1` FOREIGN KEY (`advanced_filter_id`) REFERENCES `advanced_filters` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `notification_system_items_ibfk_2` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notification_system_items_ibfk_3` FOREIGN KEY (`feedback_report_id`) REFERENCES `reports` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `notification_system_items_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(3) NOT NULL DEFAULT 0,
  `notification_system_item_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notification_system_item_id` (`notification_system_item_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notification_system_items_users_ibfk_1` FOREIGN KEY (`notification_system_item_id`) REFERENCES `notification_system_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notification_system_items_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `model` varchar(150) NOT NULL,
  `user_id` int(11) NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `status` int(1) NOT NULL DEFAULT 1 COMMENT '1-new, 0-seen',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `oauth_connectors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `client_id` varchar(255) NOT NULL,
  `client_secret` varchar(255) NOT NULL,
  `provider` varchar(255) NOT NULL,
  `status` int(1) NOT NULL DEFAULT 1,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `object_status_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `object_status_object_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(100) NOT NULL DEFAULT '',
  `foreign_key` int(11) NOT NULL,
  `name` varchar(100) NOT NULL DEFAULT '',
  `status` int(3) NOT NULL,
  `status_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `status_id` (`status_id`),
  KEY `foreign_key` (`foreign_key`),
  CONSTRAINT `object_status_object_statuses_ibfk_1` FOREIGN KEY (`status_id`) REFERENCES `object_status_statuses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `phinxlog` (
  `version` bigint(20) NOT NULL,
  `migration_name` varchar(100) DEFAULT NULL,
  `start_time` timestamp NULL DEFAULT NULL,
  `end_time` timestamp NULL DEFAULT NULL,
  `breakpoint` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `policy_exceptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `expiration` date NOT NULL,
  `expired` int(1) NOT NULL DEFAULT 0,
  `closure_date_toggle` tinyint(1) NOT NULL DEFAULT 1,
  `closure_date` date DEFAULT NULL,
  `status` int(1) NOT NULL COMMENT '0-closed, 1-open',
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `policy_exception_classifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `policy_exception_id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `policy_exception_id` (`policy_exception_id`),
  CONSTRAINT `policy_exception_classifications_ibfk_1` FOREIGN KEY (`policy_exception_id`) REFERENCES `policy_exceptions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `policy_exceptions_security_policies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `policy_exception_id` int(11) NOT NULL,
  `security_policy_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `policy_exception_id` (`policy_exception_id`),
  KEY `security_policy_id` (`security_policy_id`),
  CONSTRAINT `policy_exceptions_security_policies_ibfk_1` FOREIGN KEY (`policy_exception_id`) REFERENCES `policy_exceptions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `policy_exceptions_security_policies_ibfk_2` FOREIGN KEY (`security_policy_id`) REFERENCES `security_policies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `policy_exceptions_third_parties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `policy_exception_id` int(11) NOT NULL,
  `third_party_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_policy_exceptions_third_parties_policy_exceptions` (`policy_exception_id`),
  KEY `FK_policy_exceptions_third_parties_third_parties` (`third_party_id`),
  CONSTRAINT `FK_policy_exceptions_third_parties_policy_exceptions` FOREIGN KEY (`policy_exception_id`) REFERENCES `policy_exceptions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_policy_exceptions_third_parties_third_parties` FOREIGN KEY (`third_party_id`) REFERENCES `third_parties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `policy_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(45) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `portals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `controller` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


CREATE TABLE `processes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `business_unit_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `rto` int(11) DEFAULT NULL,
  `rpo` int(11) DEFAULT NULL,
  `rpd` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `business_unit_id` (`business_unit_id`),
  FULLTEXT KEY `name` (`name`),
  CONSTRAINT `processes_ibfk_1` FOREIGN KEY (`business_unit_id`) REFERENCES `business_units` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `program_issues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(155) NOT NULL,
  `issue_source` enum('internal','external') NOT NULL,
  `description` text NOT NULL,
  `status` enum('draft','discarded','current') NOT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `program_issue_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `program_issue_id` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `program_issue_id` (`program_issue_id`),
  CONSTRAINT `program_issue_types_ibfk_1` FOREIGN KEY (`program_issue_id`) REFERENCES `program_issues` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `program_scopes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` varchar(150) NOT NULL,
  `description` text NOT NULL,
  `status` enum('draft','discarded','current') NOT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `project_achievements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` text NOT NULL,
  `date` date NOT NULL,
  `expired` int(1) NOT NULL DEFAULT 0,
  `completion` int(3) NOT NULL,
  `project_id` int(11) NOT NULL,
  `task_order` int(3) NOT NULL DEFAULT 1,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `project_achievements_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `project_expenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` float NOT NULL,
  `description` text NOT NULL,
  `date` date NOT NULL,
  `project_id` int(11) NOT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `project_expenses_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `project_overtime_graphs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `current_budget` int(11) NOT NULL,
  `budget` int(11) NOT NULL,
  `timestamp` varchar(45) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `project_overtime_graphs_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `project_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


CREATE TABLE `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `goal` text NOT NULL,
  `start` date NOT NULL,
  `deadline` date NOT NULL,
  `plan_budget` int(11) DEFAULT NULL,
  `project_status_id` int(11) DEFAULT NULL,
  `over_budget` int(1) NOT NULL DEFAULT 0,
  `expired_tasks` int(1) NOT NULL DEFAULT 0,
  `expired` int(1) NOT NULL DEFAULT 0,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_status_id` (`project_status_id`),
  FULLTEXT KEY `title` (`title`),
  CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`project_status_id`) REFERENCES `project_statuses` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `projects_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `risk_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_projects_risks_projects` (`project_id`),
  KEY `FK_projects_risks_risks` (`risk_id`),
  CONSTRAINT `FK_projects_risks_projects` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_projects_risks_risks` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `projects_security_policies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `security_policy_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_projects_security_policies_projects` (`project_id`),
  KEY `FK_projects_security_policies_security_policies` (`security_policy_id`),
  CONSTRAINT `FK_projects_security_policies_projects` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_projects_security_policies_security_policies` FOREIGN KEY (`security_policy_id`) REFERENCES `security_policies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `projects_security_service_audit_improvements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `security_service_audit_improvement_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`),
  KEY `security_service_audit_improvement_id` (`security_service_audit_improvement_id`),
  CONSTRAINT `projects_security_service_audit_improvements_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `projects_security_service_audit_improvements_ibfk_2` FOREIGN KEY (`security_service_audit_improvement_id`) REFERENCES `security_service_audit_improvements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `projects_security_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `security_service_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_projects_security_services_projects` (`project_id`),
  KEY `FK_projects_security_services_security_services` (`security_service_id`),
  CONSTRAINT `FK_projects_security_services_projects` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_projects_security_services_security_services` FOREIGN KEY (`security_service_id`) REFERENCES `security_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `projects_third_party_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `third_party_risk_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_projects_third_party_risks_projects` (`project_id`),
  KEY `FK_projects_third_party_risks_third_party_risks` (`third_party_risk_id`),
  CONSTRAINT `FK_projects_third_party_risks_projects` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_projects_third_party_risks_third_party_risks` FOREIGN KEY (`third_party_risk_id`) REFERENCES `third_party_risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` mediumtext DEFAULT NULL,
  `queue_id` varchar(255) DEFAULT NULL,
  `model` varchar(128) DEFAULT NULL,
  `foreign_key` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` int(4) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `report_block_chart_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) NOT NULL,
  `report_block_id` int(11) NOT NULL,
  `chart_id` int(11) DEFAULT NULL,
  `model` varchar(255) NOT NULL DEFAULT '',
  `content` text NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `report_block_id` (`report_block_id`),
  KEY `report_id` (`report_id`),
  CONSTRAINT `report_block_chart_settings_ibfk_1` FOREIGN KEY (`report_block_id`) REFERENCES `report_blocks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `report_block_chart_settings_ibfk_2` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8;


CREATE TABLE `report_block_filter_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) NOT NULL,
  `report_block_id` int(11) NOT NULL,
  `advanced_filter_id` int(11) DEFAULT NULL,
  `content` text NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `advanced_filter_id` (`advanced_filter_id`),
  KEY `report_block_id` (`report_block_id`),
  KEY `report_id` (`report_id`),
  CONSTRAINT `report_block_filter_settings_ibfk_1` FOREIGN KEY (`advanced_filter_id`) REFERENCES `advanced_filters` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `report_block_filter_settings_ibfk_2` FOREIGN KEY (`report_block_id`) REFERENCES `report_blocks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `report_block_filter_settings_ibfk_3` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `report_block_table_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) NOT NULL,
  `report_block_id` int(11) NOT NULL,
  `model` varchar(255) NOT NULL,
  `content` text NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `report_block_id` (`report_block_id`),
  KEY `report_id` (`report_id`),
  CONSTRAINT `report_block_table_settings_ibfk_1` FOREIGN KEY (`report_block_id`) REFERENCES `report_blocks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `report_block_table_settings_ibfk_2` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;


CREATE TABLE `report_block_table_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_block_table_setting_id` int(11) NOT NULL,
  `field` varchar(255) NOT NULL DEFAULT '',
  `order` int(11) NOT NULL DEFAULT 1,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `report_block_table_setting_id` (`report_block_table_setting_id`),
  CONSTRAINT `report_block_table_fields_ibfk_1` FOREIGN KEY (`report_block_table_setting_id`) REFERENCES `report_block_table_settings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8;


CREATE TABLE `report_block_text_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) NOT NULL,
  `report_block_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `report_block_id` (`report_block_id`),
  KEY `report_id` (`report_id`),
  CONSTRAINT `report_block_text_settings_ibfk_1` FOREIGN KEY (`report_block_id`) REFERENCES `report_blocks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `report_block_text_settings_ibfk_2` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;


CREATE TABLE `report_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `type` int(11) NOT NULL,
  `format` int(11) NOT NULL DEFAULT 1,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;


CREATE TABLE `report_blocks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_template_id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `type` int(11) NOT NULL,
  `design` int(11) NOT NULL DEFAULT 1,
  `size` int(11) NOT NULL DEFAULT 1,
  `order` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  KEY `report_template_id` (`report_template_id`),
  CONSTRAINT `report_blocks_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `report_blocks` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `report_blocks_ibfk_2` FOREIGN KEY (`report_template_id`) REFERENCES `report_templates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8;


CREATE TABLE `reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_template_id` int(11) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `model` varchar(255) NOT NULL DEFAULT '',
  `foreign_key` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `protected` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `report_template_id` (`report_template_id`),
  CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`report_template_id`) REFERENCES `report_templates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;


CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(150) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `planned_date` date DEFAULT NULL,
  `actual_date` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `description` text NOT NULL,
  `completed` int(1) NOT NULL DEFAULT 0,
  `use_attachments` int(11) DEFAULT NULL,
  `policy_description` text DEFAULT NULL,
  `url` text DEFAULT NULL,
  `version` varchar(150) DEFAULT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_reviews_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risk_appetite_thresholds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_appetite_id` int(11) NOT NULL,
  `title` varchar(155) NOT NULL,
  `description` text NOT NULL,
  `color` text NOT NULL,
  `type` int(3) NOT NULL DEFAULT 1,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_appetite_id` (`risk_appetite_id`),
  CONSTRAINT `risk_appetite_thresholds_ibfk_1` FOREIGN KEY (`risk_appetite_id`) REFERENCES `risk_appetites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risk_appetite_threshold_risk_classifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_appetite_threshold_id` int(11) NOT NULL,
  `risk_classification_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_appetite_threshold_id` (`risk_appetite_threshold_id`),
  KEY `risk_classification_id` (`risk_classification_id`),
  CONSTRAINT `risk_appetite_threshold_risk_classifications_ibfk_1` FOREIGN KEY (`risk_appetite_threshold_id`) REFERENCES `risk_appetite_thresholds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risk_appetite_threshold_risk_classifications_ibfk_2` FOREIGN KEY (`risk_classification_id`) REFERENCES `risk_classifications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risk_appetite_thresholds_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(155) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `risk_appetite_threshold_id` int(11) NOT NULL,
  `type` int(3) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_appetite_threshold_id` (`risk_appetite_threshold_id`),
  CONSTRAINT `risk_appetite_thresholds_risks_ibfk_1` FOREIGN KEY (`risk_appetite_threshold_id`) REFERENCES `risk_appetite_thresholds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risk_appetites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `method` int(11) NOT NULL DEFAULT 0,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `risk_classification_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `risk_classification_count` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risk_appetites_risk_classification_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_appetite_id` int(11) NOT NULL,
  `risk_classification_type_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_appetite_id` (`risk_appetite_id`),
  KEY `risk_classification_type_id` (`risk_classification_type_id`),
  CONSTRAINT `risk_appetites_risk_classification_types_ibfk_1` FOREIGN KEY (`risk_appetite_id`) REFERENCES `risk_appetites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risk_appetites_risk_classification_types_ibfk_2` FOREIGN KEY (`risk_classification_type_id`) REFERENCES `risk_classification_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risk_calculations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL,
  `method` varchar(255) NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


CREATE TABLE `risk_calculation_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_calculation_id` int(11) NOT NULL,
  `field` varchar(255) NOT NULL,
  `value` text NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_calculation_id` (`risk_calculation_id`),
  CONSTRAINT `risk_calculation_values_ibfk_1` FOREIGN KEY (`risk_calculation_id`) REFERENCES `risk_calculations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risk_classifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `criteria` text NOT NULL,
  `value` float DEFAULT NULL,
  `risk_classification_type_id` int(11) DEFAULT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_classification_type_id` (`risk_classification_type_id`),
  CONSTRAINT `risk_classifications_ibfk_1` FOREIGN KEY (`risk_classification_type_id`) REFERENCES `risk_classification_types` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risk_classifications_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_classification_id` int(11) NOT NULL,
  `risk_id` int(11) NOT NULL,
  `type` int(3) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `risk_classification_id` (`risk_classification_id`),
  KEY `risk_id` (`risk_id`),
  CONSTRAINT `risk_classifications_risks_ibfk_1` FOREIGN KEY (`risk_classification_id`) REFERENCES `risk_classifications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risk_classifications_risks_ibfk_2` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risk_classifications_third_party_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_classification_id` int(11) NOT NULL,
  `third_party_risk_id` int(11) NOT NULL,
  `type` int(3) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `risk_classification_id` (`risk_classification_id`),
  KEY `third_party_risk_id` (`third_party_risk_id`),
  CONSTRAINT `risk_classifications_third_party_risks_ibfk_1` FOREIGN KEY (`risk_classification_id`) REFERENCES `risk_classifications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risk_classifications_third_party_risks_ibfk_2` FOREIGN KEY (`third_party_risk_id`) REFERENCES `third_party_risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risk_exceptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `expiration` date NOT NULL,
  `expired` int(1) NOT NULL DEFAULT 0,
  `closure_date_toggle` tinyint(1) NOT NULL DEFAULT 1,
  `closure_date` date DEFAULT NULL,
  `status` int(1) NOT NULL COMMENT '0-closed, 1-open',
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risk_exceptions_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_id` int(11) NOT NULL,
  `risk_exception_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_id` (`risk_id`),
  KEY `risk_exception_id` (`risk_exception_id`),
  CONSTRAINT `risk_exceptions_risks_ibfk_1` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risk_exceptions_risks_ibfk_2` FOREIGN KEY (`risk_exception_id`) REFERENCES `risk_exceptions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risk_exceptions_third_party_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_exception_id` int(11) NOT NULL,
  `third_party_risk_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risk_mitigation_strategies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;


CREATE TABLE `risk_overtime_graphs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_count` int(11) NOT NULL,
  `risk_score` int(11) NOT NULL,
  `residual_score` int(11) NOT NULL,
  `timestamp` varchar(45) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `threats` text NOT NULL,
  `vulnerabilities` text NOT NULL,
  `description` text DEFAULT NULL,
  `residual_score` int(11) NOT NULL,
  `risk_score` float DEFAULT NULL,
  `risk_score_formula` text NOT NULL,
  `residual_risk` float NOT NULL,
  `residual_risk_formula` text NOT NULL,
  `review` date NOT NULL,
  `expired` int(1) NOT NULL DEFAULT 0,
  `exceptions_issues` int(1) NOT NULL DEFAULT 0,
  `controls_issues` int(1) NOT NULL DEFAULT 0,
  `control_in_design` int(1) NOT NULL DEFAULT 0,
  `expired_reviews` int(1) NOT NULL DEFAULT 0,
  `risk_above_appetite` int(1) NOT NULL DEFAULT 0,
  `risk_mitigation_strategy_id` int(11) DEFAULT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_mitigation_strategy_id` (`risk_mitigation_strategy_id`),
  FULLTEXT KEY `title` (`title`),
  CONSTRAINT `risks_ibfk_2` FOREIGN KEY (`risk_mitigation_strategy_id`) REFERENCES `risk_mitigation_strategies` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risks_security_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_id` int(11) NOT NULL,
  `security_incident_id` int(11) NOT NULL,
  `risk_type` enum('asset-risk','third-party-risk','business-risk') NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_incident_id` (`security_incident_id`),
  CONSTRAINT `risks_security_incidents_ibfk_2` FOREIGN KEY (`security_incident_id`) REFERENCES `security_incidents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risks_security_policies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_id` int(11) NOT NULL,
  `security_policy_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL DEFAULT 'treatment' COMMENT '''treatment'',''incident''',
  `risk_type` enum('asset-risk','third-party-risk','business-risk') NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_policy_id` (`security_policy_id`),
  CONSTRAINT `risks_security_policies_ibfk_2` FOREIGN KEY (`security_policy_id`) REFERENCES `security_policies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risks_security_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_id` int(11) NOT NULL,
  `security_service_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_id` (`risk_id`),
  KEY `security_service_id` (`security_service_id`),
  CONSTRAINT `risks_security_services_ibfk_1` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risks_security_services_ibfk_2` FOREIGN KEY (`security_service_id`) REFERENCES `security_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risks_threats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_id` int(11) NOT NULL,
  `threat_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_id` (`risk_id`),
  KEY `threat_id` (`threat_id`),
  CONSTRAINT `risks_threats_ibfk_1` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risks_threats_ibfk_2` FOREIGN KEY (`threat_id`) REFERENCES `threats` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `risks_vulnerabilities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_id` int(11) NOT NULL,
  `vulnerability_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_id` (`risk_id`),
  KEY `vulnerability_id` (`vulnerability_id`),
  CONSTRAINT `risks_vulnerabilities_ibfk_1` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risks_vulnerabilities_ibfk_2` FOREIGN KEY (`vulnerability_id`) REFERENCES `vulnerabilities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `saml_connectors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `identity_provider` varchar(255) NOT NULL,
  `idp_certificate` text NOT NULL,
  `remote_sign_in_url` varchar(255) NOT NULL,
  `remote_sign_out_url` varchar(255) NOT NULL,
  `email_field` varchar(255) NOT NULL DEFAULT '',
  `sign_saml_request` int(1) NOT NULL DEFAULT 0,
  `sp_certificate` text NOT NULL,
  `sp_private_key` text NOT NULL,
  `validate_saml_request` int(1) NOT NULL DEFAULT 1,
  `status` int(1) NOT NULL DEFAULT 1,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `schema_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class` varchar(255) NOT NULL,
  `type` varchar(50) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;


CREATE TABLE `scopes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ciso_role_id` int(11) DEFAULT NULL,
  `ciso_deputy_id` int(11) DEFAULT NULL,
  `board_representative_id` int(11) DEFAULT NULL,
  `board_representative_deputy_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ciso_role_id` (`ciso_role_id`),
  KEY `ciso_deputy_id` (`ciso_deputy_id`),
  KEY `board_representative_id` (`board_representative_id`),
  KEY `board_representative_deputy_id` (`board_representative_deputy_id`),
  CONSTRAINT `scopes_ibfk_1` FOREIGN KEY (`ciso_role_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `scopes_ibfk_2` FOREIGN KEY (`ciso_deputy_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `scopes_ibfk_3` FOREIGN KEY (`board_representative_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `scopes_ibfk_4` FOREIGN KEY (`board_representative_deputy_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(155) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_incident_classifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_incident_id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_incident_id` (`security_incident_id`),
  CONSTRAINT `security_incident_classifications_ibfk_1` FOREIGN KEY (`security_incident_id`) REFERENCES `security_incidents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_incident_stages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_incident_stages_security_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_incident_stage_id` int(11) NOT NULL,
  `security_incident_id` int(11) NOT NULL,
  `status` tinyint(2) NOT NULL DEFAULT 0,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_security_incident_stages_security_incidents` (`security_incident_id`),
  KEY `FK_security_incident_stages_security_incident_stages` (`security_incident_stage_id`),
  CONSTRAINT `FK_security_incident_stages_security_incident_stages` FOREIGN KEY (`security_incident_stage_id`) REFERENCES `security_incident_stages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_security_incident_stages_security_incidents` FOREIGN KEY (`security_incident_id`) REFERENCES `security_incidents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_incident_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


CREATE TABLE `security_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `reporter` varchar(100) NOT NULL,
  `victim` varchar(100) NOT NULL,
  `open_date` date NOT NULL,
  `closure_date` date DEFAULT NULL,
  `expired` int(1) NOT NULL DEFAULT 0,
  `type` enum('event','possible-incident','incident') NOT NULL,
  `security_incident_status_id` int(11) DEFAULT NULL,
  `auto_close_incident` int(1) DEFAULT 0,
  `security_incident_classification_id` int(11) DEFAULT NULL,
  `lifecycle_incomplete` int(11) DEFAULT 1,
  `ongoing_incident` int(1) NOT NULL DEFAULT 0,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `security_incident_status_id` (`security_incident_status_id`),
  KEY `security_incident_classification_id` (`security_incident_classification_id`),
  CONSTRAINT `security_incidents_ibfk_1` FOREIGN KEY (`security_incident_status_id`) REFERENCES `security_incident_statuses` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `security_incidents_ibfk_3` FOREIGN KEY (`security_incident_classification_id`) REFERENCES `security_incident_classifications` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_incidents_security_service_audit_improvements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_incident_id` int(11) NOT NULL,
  `security_service_audit_improvement_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_incident_id` (`security_incident_id`),
  KEY `security_service_audit_improvement_id` (`security_service_audit_improvement_id`),
  CONSTRAINT `security_incidents_security_service_audit_improvements_ibfk_1` FOREIGN KEY (`security_incident_id`) REFERENCES `security_incidents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `security_incidents_security_service_audit_improvements_ibfk_2` FOREIGN KEY (`security_service_audit_improvement_id`) REFERENCES `security_service_audit_improvements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_incidents_security_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_incident_id` int(11) NOT NULL,
  `security_service_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_incident_id` (`security_incident_id`),
  KEY `security_service_id` (`security_service_id`),
  CONSTRAINT `security_incidents_security_services_ibfk_1` FOREIGN KEY (`security_incident_id`) REFERENCES `security_incidents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `security_incidents_security_services_ibfk_2` FOREIGN KEY (`security_service_id`) REFERENCES `security_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_incidents_third_parties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_incident_id` int(11) NOT NULL,
  `third_party_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_incident_id` (`security_incident_id`),
  KEY `third_party_id` (`third_party_id`),
  CONSTRAINT `security_incidents_third_parties_ibfk_1` FOREIGN KEY (`third_party_id`) REFERENCES `third_parties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `security_incidents_third_parties_ibfk_2` FOREIGN KEY (`security_incident_id`) REFERENCES `security_incidents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_policies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `index` varchar(100) NOT NULL,
  `short_description` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `url` text DEFAULT NULL,
  `use_attachments` int(1) NOT NULL DEFAULT 0,
  `document_type` enum('policy','standard','procedure') NOT NULL,
  `security_policy_document_type_id` int(11) DEFAULT NULL,
  `version` varchar(50) NOT NULL,
  `published_date` date NOT NULL,
  `next_review_date` date NOT NULL,
  `permission` enum('public','private','logged') NOT NULL,
  `ldap_connector_id` int(11) DEFAULT NULL,
  `asset_label_id` int(11) DEFAULT NULL,
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '0-draft, 1-released',
  `expired_reviews` int(1) NOT NULL DEFAULT 0,
  `hash` varchar(255) DEFAULT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `asset_label_id` (`asset_label_id`),
  KEY `ldap_connector_id` (`ldap_connector_id`),
  KEY `security_policy_document_type_id` (`security_policy_document_type_id`),
  FULLTEXT KEY `index` (`index`),
  CONSTRAINT `security_policies_ibfk_3` FOREIGN KEY (`asset_label_id`) REFERENCES `asset_labels` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `security_policies_ibfk_4` FOREIGN KEY (`ldap_connector_id`) REFERENCES `ldap_connectors` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `security_policies_ibfk_5` FOREIGN KEY (`security_policy_document_type_id`) REFERENCES `security_policy_document_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_policies_related` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_policy_id` int(11) NOT NULL,
  `related_document_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_policy_id` (`security_policy_id`),
  KEY `related_document_id` (`related_document_id`),
  CONSTRAINT `security_policies_related_ibfk_1` FOREIGN KEY (`security_policy_id`) REFERENCES `security_policies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `security_policies_related_ibfk_2` FOREIGN KEY (`related_document_id`) REFERENCES `security_policies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_policies_security_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_policy_id` int(11) NOT NULL,
  `security_service_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_policy_id` (`security_policy_id`),
  KEY `security_service_id` (`security_service_id`),
  CONSTRAINT `security_policies_security_services_ibfk_1` FOREIGN KEY (`security_policy_id`) REFERENCES `security_policies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `security_policies_security_services_ibfk_2` FOREIGN KEY (`security_service_id`) REFERENCES `security_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_policy_document_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `editable` int(11) NOT NULL DEFAULT 1,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


CREATE TABLE `security_policy_ldap_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_policy_id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_policy_id` (`security_policy_id`),
  CONSTRAINT `security_policy_ldap_groups_ibfk_1` FOREIGN KEY (`security_policy_id`) REFERENCES `security_policies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_policy_reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_policy_id` int(11) NOT NULL,
  `planned_date` date NOT NULL,
  `actual_review_date` date DEFAULT NULL,
  `reviewer_id` int(11) DEFAULT NULL,
  `comments` text NOT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `reviewer_id` (`reviewer_id`),
  KEY `security_policy_id` (`security_policy_id`),
  CONSTRAINT `security_policy_reviews_ibfk_1` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `security_policy_reviews_ibfk_2` FOREIGN KEY (`security_policy_id`) REFERENCES `security_policies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_service_audit_dates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_service_id` int(11) NOT NULL,
  `day` int(2) NOT NULL,
  `month` int(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_service_id` (`security_service_id`),
  CONSTRAINT `security_service_audit_dates_ibfk_1` FOREIGN KEY (`security_service_id`) REFERENCES `security_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_service_audits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_service_id` int(11) NOT NULL,
  `audit_metric_description` text NOT NULL,
  `audit_success_criteria` text NOT NULL,
  `result` int(1) DEFAULT NULL COMMENT 'null-not defined, 0-fail, 1-pass',
  `result_description` text NOT NULL,
  `planned_date` date NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `security_service_id` (`security_service_id`),
  CONSTRAINT `security_service_audits_ibfk_1` FOREIGN KEY (`security_service_id`) REFERENCES `security_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_service_audit_improvements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_service_audit_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_service_audit_id` (`security_service_audit_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `security_service_audit_improvements_ibfk_1` FOREIGN KEY (`security_service_audit_id`) REFERENCES `security_service_audits` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `security_service_audit_improvements_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_service_classifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_service_id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_service_id` (`security_service_id`),
  CONSTRAINT `security_service_classifications_ibfk_1` FOREIGN KEY (`security_service_id`) REFERENCES `security_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_service_maintenance_dates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_service_id` int(11) NOT NULL,
  `day` int(2) NOT NULL,
  `month` int(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_service_id` (`security_service_id`),
  CONSTRAINT `security_service_maintenance_dates_ibfk_1` FOREIGN KEY (`security_service_id`) REFERENCES `security_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `service_classifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `objective` text NOT NULL,
  `security_service_type_id` int(11) DEFAULT NULL,
  `service_classification_id` int(11) DEFAULT NULL,
  `documentation_url` text NOT NULL,
  `audit_calendar_type` int(3) NOT NULL DEFAULT 0,
  `audit_calendar_recurrence_start_date` datetime NOT NULL,
  `audit_calendar_recurrence_frequency` int(11) NOT NULL DEFAULT 0,
  `audit_calendar_recurrence_period` int(11) NOT NULL DEFAULT 0,
  `maintenance_calendar_type` int(3) NOT NULL DEFAULT 0,
  `maintenance_calendar_recurrence_start_date` datetime NOT NULL,
  `maintenance_calendar_recurrence_frequency` int(11) NOT NULL DEFAULT 0,
  `maintenance_calendar_recurrence_period` int(11) NOT NULL DEFAULT 0,
  `audit_metric_description` text NOT NULL,
  `audit_success_criteria` text NOT NULL,
  `maintenance_metric_description` text NOT NULL,
  `opex` float NOT NULL,
  `capex` float NOT NULL,
  `resource_utilization` int(11) NOT NULL,
  `audits_all_done` int(1) NOT NULL,
  `audits_not_all_done` int(1) NOT NULL,
  `audits_last_missing` int(1) NOT NULL,
  `audits_last_passed` int(1) NOT NULL,
  `audits_improvements` int(1) NOT NULL,
  `audits_status` int(1) NOT NULL,
  `maintenances_all_done` int(1) NOT NULL,
  `maintenances_not_all_done` int(1) NOT NULL,
  `maintenances_last_missing` int(1) NOT NULL,
  `maintenances_last_passed` int(1) NOT NULL,
  `ongoing_security_incident` int(1) NOT NULL DEFAULT 0,
  `security_incident_open_count` int(11) NOT NULL,
  `control_with_issues` int(1) NOT NULL DEFAULT 0,
  `ongoing_corrective_actions` int(1) NOT NULL DEFAULT 0,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `security_service_type_id` (`security_service_type_id`),
  KEY `service_classification_id` (`service_classification_id`),
  FULLTEXT KEY `name` (`name`),
  CONSTRAINT `security_services_ibfk_1` FOREIGN KEY (`security_service_type_id`) REFERENCES `security_service_types` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `security_services_ibfk_2` FOREIGN KEY (`service_classification_id`) REFERENCES `service_classifications` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_service_maintenances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_service_id` int(11) NOT NULL,
  `task` text NOT NULL,
  `task_conclusion` text NOT NULL,
  `planned_date` date NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `result` int(1) DEFAULT NULL COMMENT 'null-not defined, 0-fail, 1-pass',
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `security_service_id` (`security_service_id`),
  CONSTRAINT `security_service_maintenances_ibfk_3` FOREIGN KEY (`security_service_id`) REFERENCES `security_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_service_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;


CREATE TABLE `service_contracts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `third_party_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `value` int(11) NOT NULL,
  `start` date NOT NULL,
  `end` date NOT NULL,
  `expired` int(1) NOT NULL DEFAULT 0,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `third_party_id` (`third_party_id`),
  CONSTRAINT `service_contracts_ibfk_2` FOREIGN KEY (`third_party_id`) REFERENCES `third_parties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_services_service_contracts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_service_id` int(11) NOT NULL,
  `service_contract_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_service_id` (`security_service_id`),
  KEY `service_contract_id` (`service_contract_id`),
  CONSTRAINT `security_services_service_contracts_ibfk_1` FOREIGN KEY (`security_service_id`) REFERENCES `security_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `security_services_service_contracts_ibfk_2` FOREIGN KEY (`service_contract_id`) REFERENCES `service_contracts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `security_services_third_party_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `security_service_id` int(11) NOT NULL,
  `third_party_risk_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `security_service_id` (`security_service_id`),
  KEY `third_party_risk_id` (`third_party_risk_id`),
  CONSTRAINT `security_services_third_party_risks_ibfk_1` FOREIGN KEY (`third_party_risk_id`) REFERENCES `third_party_risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `security_services_third_party_risks_ibfk_2` FOREIGN KEY (`security_service_id`) REFERENCES `security_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `setting_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `slug` varchar(50) NOT NULL,
  `parent_slug` varchar(50) DEFAULT NULL,
  `name` varchar(150) DEFAULT NULL,
  `icon_code` varchar(150) DEFAULT NULL,
  `notes` varchar(250) DEFAULT NULL,
  `url` varchar(250) DEFAULT NULL,
  `modal` int(1) NOT NULL DEFAULT 0,
  `hidden` tinyint(4) DEFAULT 0,
  `order` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `FK_setting_groups_setting_groups` (`parent_slug`),
  CONSTRAINT `FK_setting_groups_setting_groups` FOREIGN KEY (`parent_slug`) REFERENCES `setting_groups` (`slug`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;


CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `active` int(1) NOT NULL DEFAULT 1,
  `name` varchar(255) NOT NULL,
  `variable` varchar(100) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `default_value` varchar(255) DEFAULT NULL,
  `values` varchar(255) DEFAULT NULL,
  `type` enum('text','number','select','multiselect','checkbox','textarea','password') NOT NULL DEFAULT 'text',
  `options` varchar(150) DEFAULT NULL,
  `hidden` int(1) NOT NULL DEFAULT 0,
  `required` int(1) NOT NULL DEFAULT 0,
  `setting_group_slug` varchar(50) DEFAULT NULL,
  `setting_type` enum('constant','config') DEFAULT 'constant',
  `order` int(11) NOT NULL DEFAULT 0,
  `modified` datetime NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_settings_setting_groups` (`setting_group_slug`),
  CONSTRAINT `FK_settings_setting_groups` FOREIGN KEY (`setting_group_slug`) REFERENCES `setting_groups` (`slug`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;


CREATE TABLE `status_triggers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(155) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `config_name` varchar(155) NOT NULL,
  `column_name` varchar(155) NOT NULL,
  `value` varchar(155) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `suggestions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `suggestion` varchar(255) NOT NULL,
  `model` varchar(155) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `system_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL DEFAULT '',
  `foreign_key` int(11) DEFAULT NULL,
  `sub_model` varchar(255) DEFAULT '',
  `sub_foreign_key` int(11) DEFAULT NULL,
  `action` int(11) NOT NULL,
  `result` text DEFAULT NULL,
  `message` text DEFAULT NULL,
  `user_model` varchar(255) DEFAULT '',
  `user_id` int(11) DEFAULT NULL,
  `ip` varchar(255) NOT NULL DEFAULT '',
  `uri` text NOT NULL,
  `request_id` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `system_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(70) NOT NULL,
  `model_nice` varchar(70) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `item` varchar(100) NOT NULL,
  `notes` text DEFAULT NULL,
  `type` int(1) NOT NULL COMMENT '1-insert, 2-update, 3-delete, 4-login, 5-wrong login',
  `workflow_status` int(1) DEFAULT NULL,
  `workflow_comment` text DEFAULT NULL,
  `ip` varchar(45) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `system_records_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(250) NOT NULL,
  `foreign_key` int(11) DEFAULT NULL,
  `title` varchar(150) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `tags_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `team_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `role` varchar(155) NOT NULL,
  `responsibilities` text NOT NULL,
  `competences` text NOT NULL,
  `status` enum('active','discarded') NOT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `team_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `third_parties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `third_party_type_id` int(11) DEFAULT NULL,
  `security_incident_count` int(11) NOT NULL,
  `security_incident_open_count` int(11) NOT NULL,
  `service_contract_count` int(11) NOT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `_hidden` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `third_party_type_id` (`third_party_type_id`),
  FULLTEXT KEY `name` (`name`),
  CONSTRAINT `third_parties_ibfk_1` FOREIGN KEY (`third_party_type_id`) REFERENCES `third_party_types` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `third_parties_third_party_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `third_party_risk_id` int(11) NOT NULL,
  `third_party_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `third_party_risk_id` (`third_party_risk_id`),
  KEY `third_party_id` (`third_party_id`),
  CONSTRAINT `third_parties_third_party_risks_ibfk_1` FOREIGN KEY (`third_party_risk_id`) REFERENCES `third_party_risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `third_parties_third_party_risks_ibfk_2` FOREIGN KEY (`third_party_id`) REFERENCES `third_parties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `third_parties_vendor_assessments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `third_party_id` int(11) NOT NULL,
  `vendor_assessment_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `third_party_id` (`third_party_id`),
  KEY `vendor_assessment_id` (`vendor_assessment_id`),
  CONSTRAINT `third_parties_vendor_assessments_ibfk_1` FOREIGN KEY (`third_party_id`) REFERENCES `third_parties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `third_parties_vendor_assessments_ibfk_2` FOREIGN KEY (`vendor_assessment_id`) REFERENCES `vendor_assessments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `third_party_audit_overtime_graphs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `third_party_id` int(11) NOT NULL,
  `open` int(3) DEFAULT NULL,
  `closed` int(3) DEFAULT NULL,
  `expired` int(3) DEFAULT NULL,
  `no_evidence` int(3) NOT NULL,
  `waiting_evidence` int(3) NOT NULL,
  `provided_evidence` int(3) NOT NULL,
  `timestamp` varchar(45) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `third_party_id` (`third_party_id`),
  CONSTRAINT `third_party_audit_overtime_graphs_ibfk_1` FOREIGN KEY (`third_party_id`) REFERENCES `third_parties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `third_party_incident_overtime_graphs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `third_party_id` int(11) NOT NULL,
  `security_incident_count` int(11) NOT NULL,
  `timestamp` varchar(45) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `third_party_id` (`third_party_id`),
  CONSTRAINT `third_party_incident_overtime_graphs_ibfk_1` FOREIGN KEY (`third_party_id`) REFERENCES `third_parties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `third_party_overtime_graphs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `third_party_id` int(11) NOT NULL,
  `no_controls` int(3) NOT NULL,
  `failed_controls` int(3) NOT NULL,
  `ok_controls` int(3) NOT NULL,
  `average_effectiveness` int(3) NOT NULL,
  `timestamp` varchar(45) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `third_party_id` (`third_party_id`),
  CONSTRAINT `third_party_overtime_graphs_ibfk_1` FOREIGN KEY (`third_party_id`) REFERENCES `third_parties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `third_party_risk_overtime_graphs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_count` int(11) NOT NULL,
  `risk_score` int(11) NOT NULL,
  `residual_score` int(11) NOT NULL,
  `timestamp` varchar(45) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `third_party_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `shared_information` text NOT NULL,
  `controlled` text NOT NULL,
  `threats` text NOT NULL,
  `vulnerabilities` text NOT NULL,
  `description` text DEFAULT NULL,
  `residual_score` int(11) NOT NULL,
  `risk_score` float DEFAULT NULL,
  `risk_score_formula` text NOT NULL,
  `residual_risk` float NOT NULL,
  `residual_risk_formula` text NOT NULL,
  `review` date NOT NULL,
  `expired` int(1) NOT NULL DEFAULT 0,
  `exceptions_issues` int(1) NOT NULL DEFAULT 0,
  `controls_issues` int(1) NOT NULL DEFAULT 0,
  `control_in_design` int(1) NOT NULL DEFAULT 0,
  `expired_reviews` int(1) NOT NULL DEFAULT 0,
  `risk_above_appetite` int(1) NOT NULL DEFAULT 0,
  `risk_mitigation_strategy_id` int(11) DEFAULT NULL,
  `workflow_owner_id` int(11) DEFAULT NULL,
  `workflow_status` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `risk_mitigation_strategy_id` (`risk_mitigation_strategy_id`),
  FULLTEXT KEY `title` (`title`),
  CONSTRAINT `third_party_risks_ibfk_2` FOREIGN KEY (`risk_mitigation_strategy_id`) REFERENCES `risk_mitigation_strategies` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `third_party_risks_threats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `third_party_risk_id` int(11) NOT NULL,
  `threat_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `third_party_risk_id` (`third_party_risk_id`),
  KEY `threat_id` (`threat_id`),
  CONSTRAINT `third_party_risks_threats_ibfk_1` FOREIGN KEY (`third_party_risk_id`) REFERENCES `third_party_risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `third_party_risks_threats_ibfk_2` FOREIGN KEY (`threat_id`) REFERENCES `threats` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `third_party_risks_vulnerabilities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `third_party_risk_id` int(11) NOT NULL,
  `vulnerability_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `third_party_risk_id` (`third_party_risk_id`),
  KEY `vulnerability_id` (`vulnerability_id`),
  CONSTRAINT `third_party_risks_vulnerabilities_ibfk_1` FOREIGN KEY (`third_party_risk_id`) REFERENCES `third_party_risks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `third_party_risks_vulnerabilities_ibfk_2` FOREIGN KEY (`vulnerability_id`) REFERENCES `vulnerabilities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `third_party_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


CREATE TABLE `threats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;


CREATE TABLE `tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `is_used` tinyint(1) NOT NULL DEFAULT 0,
  `hash` varchar(50) DEFAULT NULL,
  `data` varchar(50) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime NOT NULL,
  `expires` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hash` (`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `tooltip_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `seen` int(1) NOT NULL DEFAULT 0,
  `model` varchar(255) NOT NULL,
  `type` varchar(30) NOT NULL,
  `file_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `tooltip_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `translations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `folder` varchar(255) NOT NULL DEFAULT '',
  `status` int(11) NOT NULL DEFAULT 1,
  `type` int(11) NOT NULL DEFAULT 1,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;


CREATE TABLE `user_bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `until` datetime NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_bans_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `user_fields_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `field` varchar(255) NOT NULL,
  `group_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `user_fields_groups_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `user_fields_objects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL DEFAULT '',
  `foreign_key` int(11) NOT NULL,
  `field` varchar(255) NOT NULL DEFAULT '',
  `object_id` int(11) NOT NULL,
  `object_key` varchar(255) NOT NULL DEFAULT '',
  `object_model` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `surname` varchar(45) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `login` varchar(45) NOT NULL,
  `password` varchar(100) NOT NULL,
  `language` varchar(10) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '0-non active, 1-active',
  `blocked` int(1) NOT NULL DEFAULT 0,
  `local_account` int(3) DEFAULT 1,
  `api_allow` int(2) NOT NULL DEFAULT 0,
  `default_password` int(1) NOT NULL DEFAULT 1,
  `account_ready` int(1) NOT NULL DEFAULT 0,
  `ldap_sync` int(1) NOT NULL DEFAULT 0,
  `ldap_synchronization_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login` (`login`),
  UNIQUE KEY `email` (`email`),
  KEY `ldap_synchronization_id` (`ldap_synchronization_id`),
  FULLTEXT KEY `login_2` (`login`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `user_fields_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `field` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_fields_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `users_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `users_ldap_synchronizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `ldap_synchronization_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `ldap_synchronization_id` (`ldap_synchronization_id`),
  CONSTRAINT `users_ldap_synchronizations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `users_ldap_synchronizations_ibfk_2` FOREIGN KEY (`ldap_synchronization_id`) REFERENCES `ldap_synchronizations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `users_portals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `portal_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `portal_id` (`portal_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `users_portals_ibfk_1` FOREIGN KEY (`portal_id`) REFERENCES `portals` (`id`),
  CONSTRAINT `users_portals_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `vendor_assessment_feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_assessment_id` int(11) NOT NULL,
  `vendor_assessment_question_id` int(11) NOT NULL,
  `vendor_assessment_option_id` int(11) DEFAULT NULL,
  `answer` text NOT NULL,
  `completed` int(11) NOT NULL DEFAULT 0,
  `locked` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `vendor_assessment_id` (`vendor_assessment_id`),
  KEY `vendor_assessment_option_id` (`vendor_assessment_option_id`),
  KEY `vendor_assessment_question_id` (`vendor_assessment_question_id`),
  CONSTRAINT `vendor_assessment_feedbacks_ibfk_1` FOREIGN KEY (`vendor_assessment_id`) REFERENCES `vendor_assessments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vendor_assessment_feedbacks_ibfk_2` FOREIGN KEY (`vendor_assessment_option_id`) REFERENCES `vendor_assessment_options` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vendor_assessment_feedbacks_ibfk_3` FOREIGN KEY (`vendor_assessment_question_id`) REFERENCES `vendor_assessment_questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `vendor_assessment_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `vendor_assessment_findings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_assessment_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `deadline` date NOT NULL,
  `close_date` date DEFAULT NULL,
  `auto_close_date` int(11) NOT NULL DEFAULT 1,
  `status` int(11) NOT NULL,
  `expired` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `vendor_assessment_id` (`vendor_assessment_id`),
  CONSTRAINT `vendor_assessment_findings_ibfk_1` FOREIGN KEY (`vendor_assessment_id`) REFERENCES `vendor_assessments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `vendor_assessment_findings_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_assessment_finding_id` int(11) NOT NULL,
  `vendor_assessment_question_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `vendor_assessment_finding_id` (`vendor_assessment_finding_id`),
  KEY `vendor_assessment_question_id` (`vendor_assessment_question_id`),
  CONSTRAINT `vendor_assessment_findings_questions_ibfk_1` FOREIGN KEY (`vendor_assessment_finding_id`) REFERENCES `vendor_assessment_findings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vendor_assessment_findings_questions_ibfk_2` FOREIGN KEY (`vendor_assessment_question_id`) REFERENCES `vendor_assessment_questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `vendor_assessment_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_assessment_question_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  `warning` text NOT NULL,
  `weight` decimal(11,4) NOT NULL DEFAULT 1.0000,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `vendor_assessment_question_id` (`vendor_assessment_question_id`),
  CONSTRAINT `vendor_assessment_options_ibfk_1` FOREIGN KEY (`vendor_assessment_question_id`) REFERENCES `vendor_assessment_questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `vendor_assessment_questionnaires` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `vendor_assessment_file_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `vendor_assessment_file_id` (`vendor_assessment_file_id`),
  CONSTRAINT `vendor_assessment_questionnaires_ibfk_1` FOREIGN KEY (`vendor_assessment_file_id`) REFERENCES `vendor_assessment_files` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `vendor_assessment_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_assessment_questionnaire_id` int(11) NOT NULL,
  `chapter_number` varchar(255) NOT NULL DEFAULT '',
  `chapter_title` varchar(255) NOT NULL DEFAULT '',
  `chapter_description` text NOT NULL,
  `number` varchar(255) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `answer_type` int(11) NOT NULL,
  `score` decimal(11,4) NOT NULL,
  `widget_type` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `vendor_assessment_questionnaire_id` (`vendor_assessment_questionnaire_id`),
  CONSTRAINT `vendor_assessment_questions_ibfk_1` FOREIGN KEY (`vendor_assessment_questionnaire_id`) REFERENCES `vendor_assessment_questionnaires` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `vendor_assessments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `hash` varchar(255) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `vendor_assessment_questionnaire_id` int(11) NOT NULL,
  `portal_title` varchar(255) NOT NULL DEFAULT '',
  `portal_description` text NOT NULL,
  `finding_download` int(11) NOT NULL,
  `questions_download` int(11) NOT NULL,
  `incomplete_submit` int(11) NOT NULL,
  `scheduling` int(11) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `auto_close` int(11) NOT NULL DEFAULT 0,
  `recurrence` int(11) NOT NULL,
  `recurrence_period` int(11) NOT NULL,
  `recurrence_auto_load` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `submited` int(11) NOT NULL DEFAULT 0,
  `submit_date` datetime DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `edited` datetime DEFAULT NULL,
  `deleted` int(2) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `vendor_assessment_questionnaire_id` (`vendor_assessment_questionnaire_id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `vendor_assessments_ibfk_1` FOREIGN KEY (`vendor_assessment_questionnaire_id`) REFERENCES `vendor_assessment_questionnaires` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `vendor_assessments_ibfk_2` FOREIGN KEY (`parent_id`) REFERENCES `vendor_assessments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `visualisation_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(155) NOT NULL,
  `status` int(3) NOT NULL DEFAULT 0,
  `order` int(3) NOT NULL DEFAULT 999,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8;


CREATE TABLE `visualisation_settings_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `visualisation_setting_id` int(11) NOT NULL,
  `aros_acos_id` int(11) DEFAULT NULL,
  `user_fields_group_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aros_acos_id` (`aros_acos_id`),
  KEY `user_fields_group_id` (`user_fields_group_id`),
  KEY `visualisation_setting_id` (`visualisation_setting_id`),
  CONSTRAINT `visualisation_settings_groups_ibfk_1` FOREIGN KEY (`aros_acos_id`) REFERENCES `aros_acos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `visualisation_settings_groups_ibfk_2` FOREIGN KEY (`user_fields_group_id`) REFERENCES `user_fields_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `visualisation_settings_groups_ibfk_3` FOREIGN KEY (`visualisation_setting_id`) REFERENCES `visualisation_settings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `visualisation_settings_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `visualisation_setting_id` int(11) NOT NULL,
  `aros_acos_id` int(11) DEFAULT NULL,
  `user_fields_user_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aros_acos_id` (`aros_acos_id`),
  KEY `visualisation_setting_id` (`visualisation_setting_id`),
  KEY `user_fields_user_id` (`user_fields_user_id`),
  CONSTRAINT `visualisation_settings_users_ibfk_3` FOREIGN KEY (`visualisation_setting_id`) REFERENCES `visualisation_settings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `visualisation_settings_users_ibfk_4` FOREIGN KEY (`aros_acos_id`) REFERENCES `aros_acos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `visualisation_settings_users_ibfk_5` FOREIGN KEY (`user_fields_user_id`) REFERENCES `user_fields_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `visualisation_share` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(128) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `visualisation_share_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `visualisation_share_id` int(11) NOT NULL,
  `aros_acos_id` int(11) DEFAULT NULL,
  `user_fields_group_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aros_acos_id` (`aros_acos_id`),
  KEY `user_fields_group_id` (`user_fields_group_id`),
  KEY `visualisation_share_id` (`visualisation_share_id`),
  CONSTRAINT `visualisation_share_groups_ibfk_1` FOREIGN KEY (`aros_acos_id`) REFERENCES `aros_acos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `visualisation_share_groups_ibfk_2` FOREIGN KEY (`user_fields_group_id`) REFERENCES `user_fields_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `visualisation_share_groups_ibfk_3` FOREIGN KEY (`visualisation_share_id`) REFERENCES `visualisation_share` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `visualisation_share_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `visualisation_share_id` int(11) NOT NULL,
  `aros_acos_id` int(11) DEFAULT NULL,
  `user_fields_user_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aros_acos_id` (`aros_acos_id`),
  KEY `user_fields_user_id` (`user_fields_user_id`),
  KEY `visualisation_share_id` (`visualisation_share_id`),
  CONSTRAINT `visualisation_share_users_ibfk_1` FOREIGN KEY (`aros_acos_id`) REFERENCES `aros_acos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `visualisation_share_users_ibfk_2` FOREIGN KEY (`user_fields_user_id`) REFERENCES `user_fields_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `visualisation_share_users_ibfk_3` FOREIGN KEY (`visualisation_share_id`) REFERENCES `visualisation_share` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `vulnerabilities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;


CREATE TABLE `wf_access_models` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plugin` varchar(155) DEFAULT NULL,
  `name` varchar(155) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `wf_access_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `slug` varchar(155) NOT NULL,
  `model` varchar(155) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `model` (`model`),
  KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `wf_accesses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wf_access_model` varchar(155) NOT NULL DEFAULT '',
  `wf_access_foreign_key` int(11) NOT NULL DEFAULT 0,
  `wf_access_type` varchar(155) NOT NULL DEFAULT '',
  `foreign_key` varchar(155) NOT NULL,
  `access` int(3) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `wf_access_model` (`wf_access_model`),
  KEY `wf_access_type` (`wf_access_type`),
  CONSTRAINT `wf_accesses_ibfk_1` FOREIGN KEY (`wf_access_model`) REFERENCES `wf_access_models` (`name`) ON UPDATE CASCADE,
  CONSTRAINT `wf_accesses_ibfk_2` FOREIGN KEY (`wf_access_type`) REFERENCES `wf_access_types` (`slug`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `wf_instance_approvals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wf_instance_request_id` int(11) NOT NULL,
  `wf_stage_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `wf_instance_request_id` (`wf_instance_request_id`),
  KEY `wf_stage_id` (`wf_stage_id`),
  CONSTRAINT `wf_instance_approvals_ibfk_1` FOREIGN KEY (`wf_instance_request_id`) REFERENCES `wf_instance_requests` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `wf_instance_approvals_ibfk_2` FOREIGN KEY (`wf_stage_id`) REFERENCES `wf_stages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `wf_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(155) NOT NULL,
  `name` varchar(155) NOT NULL,
  `description` text DEFAULT NULL,
  `status` int(3) NOT NULL DEFAULT 0,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `model` (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `wf_stages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(155) NOT NULL DEFAULT '',
  `wf_setting_id` int(11) NOT NULL,
  `name` varchar(155) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `stage_type` int(2) NOT NULL,
  `approval_method` int(2) NOT NULL,
  `timeout` int(5) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `model` (`model`),
  KEY `wf_setting_id` (`wf_setting_id`),
  CONSTRAINT `wf_stages_ibfk_1` FOREIGN KEY (`model`) REFERENCES `wf_settings` (`model`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `wf_stages_ibfk_2` FOREIGN KEY (`wf_setting_id`) REFERENCES `wf_settings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `wf_instances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(155) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `wf_stage_id` int(11) NOT NULL,
  `wf_stage_step_id` int(11) NOT NULL DEFAULT 0,
  `stage_init_date` datetime NOT NULL,
  `status` int(3) NOT NULL DEFAULT 1,
  `pending_requests` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `model` (`model`),
  KEY `wf_stage_id` (`wf_stage_id`),
  CONSTRAINT `wf_instances_ibfk_1` FOREIGN KEY (`model`) REFERENCES `wf_settings` (`model`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `wf_instances_ibfk_2` FOREIGN KEY (`wf_stage_id`) REFERENCES `wf_stages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `wf_instance_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wf_instance_id` int(11) NOT NULL,
  `wf_stage_id` int(11) DEFAULT NULL,
  `type` int(3) NOT NULL,
  `message` text DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `wf_instance_id` (`wf_instance_id`),
  CONSTRAINT `wf_instance_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `wf_instance_logs_ibfk_2` FOREIGN KEY (`wf_instance_id`) REFERENCES `wf_instances` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `wf_stage_steps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wf_stage_id` int(11) NOT NULL,
  `wf_next_stage_id` int(11) NOT NULL,
  `step_type` int(3) NOT NULL,
  `notification_message` text DEFAULT NULL,
  `timeout` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `wf_next_stage_id` (`wf_next_stage_id`),
  KEY `wf_stage_id` (`wf_stage_id`),
  CONSTRAINT `wf_stage_steps_ibfk_1` FOREIGN KEY (`wf_next_stage_id`) REFERENCES `wf_stages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `wf_stage_steps_ibfk_2` FOREIGN KEY (`wf_stage_id`) REFERENCES `wf_stages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `wf_instance_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wf_instance_id` int(11) NOT NULL,
  `wf_stage_id` int(11) NOT NULL,
  `wf_stage_step_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `status` int(3) NOT NULL DEFAULT 1,
  `approvals_count` int(11) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `wf_instance_id` (`wf_instance_id`),
  KEY `wf_stage_id` (`wf_stage_id`),
  KEY `wf_stage_step_id` (`wf_stage_step_id`),
  CONSTRAINT `wf_instance_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `wf_instance_requests_ibfk_2` FOREIGN KEY (`wf_instance_id`) REFERENCES `wf_instances` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `wf_instance_requests_ibfk_3` FOREIGN KEY (`wf_stage_id`) REFERENCES `wf_stages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `wf_instance_requests_ibfk_4` FOREIGN KEY (`wf_stage_step_id`) REFERENCES `wf_stage_steps` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `wf_stage_step_conditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wf_stage_step_id` int(11) NOT NULL,
  `field` varchar(155) NOT NULL,
  `comparison_type` varchar(55) NOT NULL,
  `value` varchar(155) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `wf_stage_step_id` (`wf_stage_step_id`),
  CONSTRAINT `wf_stage_step_conditions_ibfk_1` FOREIGN KEY (`wf_stage_step_id`) REFERENCES `wf_stage_steps` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `widget_views` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `widget_view` datetime NOT NULL,
  `comments_view` datetime NOT NULL,
  `attachments_view` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `widget_views_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `workflow_acknowledgements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `type` enum('edit','delete') NOT NULL,
  `model` varchar(255) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `resolved` int(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `workflow_acknowledgements_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `workflow_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `status` int(1) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `workflow_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL,
  `foreign_key` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` int(1) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `workflow_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `workflows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `notifications` int(1) NOT NULL DEFAULT 1,
  `parent_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `workflows_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `workflows` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;


CREATE TABLE `workflows_all_approver_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflow_id` int(11) NOT NULL,
  `foreign_key` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `workflow_id` (`workflow_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `workflows_all_approver_items_ibfk_1` FOREIGN KEY (`workflow_id`) REFERENCES `workflows` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `workflows_all_approver_items_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `workflows_all_validator_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflow_id` int(11) NOT NULL,
  `foreign_key` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `workflow_id` (`workflow_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `workflows_all_validator_items_ibfk_1` FOREIGN KEY (`workflow_id`) REFERENCES `workflows` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `workflows_all_validator_items_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `workflows_approver_scopes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflow_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `custom_identifier` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `workflow_id` (`workflow_id`),
  KEY `scope_id` (`user_id`),
  CONSTRAINT `workflows_approver_scopes_ibfk_1` FOREIGN KEY (`workflow_id`) REFERENCES `workflows` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `workflows_approver_scopes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `workflows_approvers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `workflow_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `workflow_id` (`workflow_id`),
  CONSTRAINT `workflows_approvers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `workflows_approvers_ibfk_2` FOREIGN KEY (`workflow_id`) REFERENCES `workflows` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `workflows_custom_approvers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflow_id` int(11) NOT NULL,
  `custom_identifier` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `workflows_custom_validators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflow_id` int(11) NOT NULL,
  `custom_identifier` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `workflows_validator_scopes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflow_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `custom_identifier` varchar(255) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `workflow_id` (`workflow_id`),
  KEY `scope_id` (`user_id`),
  CONSTRAINT `workflows_validator_scopes_ibfk_1` FOREIGN KEY (`workflow_id`) REFERENCES `workflows` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `workflows_validator_scopes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `workflows_validators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `workflow_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `workflow_id` (`workflow_id`),
  CONSTRAINT `workflows_validators_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `workflows_validators_ibfk_2` FOREIGN KEY (`workflow_id`) REFERENCES `workflows` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




SET FOREIGN_KEY_CHECKS = @PREVIOUS_FOREIGN_KEY_CHECKS;


CREATE TRIGGER `user_fields_groups_after_delete` AFTER DELETE ON `user_fields_groups` FOR EACH ROW DELETE FROM `user_fields_objects` 
            WHERE 
                model = OLD.model
                AND foreign_key = OLD.foreign_key
                AND field = OLD.field
                AND object_id = OLD.group_id
                AND object_model LIKE 'Group';


CREATE TRIGGER `user_fields_groups_after_insert` AFTER INSERT ON `user_fields_groups` FOR EACH ROW INSERT INTO `user_fields_objects` 
            SET
                model = NEW.model,
                foreign_key = NEW.foreign_key,
                field = NEW.field,
                object_id = NEW.group_id,
                object_key = concat('Group-', NEW.group_id),
                object_model = 'Group',
                created = NEW.created,
                modified = NEW.modified;


CREATE TRIGGER `user_fields_users_after_delete` AFTER DELETE ON `user_fields_users` FOR EACH ROW DELETE FROM `user_fields_objects` 
            WHERE 
                model = OLD.model
                AND foreign_key = OLD.foreign_key
                AND field = OLD.field
                AND object_id = OLD.user_id
                AND object_model LIKE 'User';


CREATE TRIGGER `user_fields_users_after_insert` AFTER INSERT ON `user_fields_users` FOR EACH ROW INSERT INTO `user_fields_objects` 
            SET
                model = NEW.model,
                foreign_key = NEW.foreign_key,
                field = NEW.field,
                object_id = NEW.user_id,
                object_key = concat('User-', NEW.user_id),
                object_model = 'User',
                created = NEW.created,
                modified = NEW.modified;




SET @PREVIOUS_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;


LOCK TABLES `account_review_feeds` WRITE;
ALTER TABLE `account_review_feeds` DISABLE KEYS;
ALTER TABLE `account_review_feeds` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `account_review_feed_pulls` WRITE;
ALTER TABLE `account_review_feed_pulls` DISABLE KEYS;
ALTER TABLE `account_review_feed_pulls` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `account_review_feed_rows` WRITE;
ALTER TABLE `account_review_feed_rows` DISABLE KEYS;
ALTER TABLE `account_review_feed_rows` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `account_review_feed_row_roles` WRITE;
ALTER TABLE `account_review_feed_row_roles` DISABLE KEYS;
ALTER TABLE `account_review_feed_row_roles` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `account_review_feedbacks` WRITE;
ALTER TABLE `account_review_feedbacks` DISABLE KEYS;
ALTER TABLE `account_review_feedbacks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `account_review_feedback_roles` WRITE;
ALTER TABLE `account_review_feedback_roles` DISABLE KEYS;
ALTER TABLE `account_review_feedback_roles` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `account_review_findings` WRITE;
ALTER TABLE `account_review_findings` DISABLE KEYS;
ALTER TABLE `account_review_findings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `account_review_findings_feedbacks` WRITE;
ALTER TABLE `account_review_findings_feedbacks` DISABLE KEYS;
ALTER TABLE `account_review_findings_feedbacks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `account_reviews` WRITE;
ALTER TABLE `account_reviews` DISABLE KEYS;
ALTER TABLE `account_reviews` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `account_review_pulls` WRITE;
ALTER TABLE `account_review_pulls` DISABLE KEYS;
ALTER TABLE `account_review_pulls` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `account_reviews_assets` WRITE;
ALTER TABLE `account_reviews_assets` DISABLE KEYS;
ALTER TABLE `account_reviews_assets` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `acos` WRITE;
ALTER TABLE `acos` DISABLE KEYS;
INSERT INTO `acos` (`id`, `parent_id`, `model`, `foreign_key`, `alias`, `lft`, `rght`) VALUES 
	(1,NULL,NULL,NULL,'controllers',1,1904),
	(2,1,NULL,NULL,'Ajax',2,7),
	(3,2,NULL,NULL,'modalSidebarWidget',3,4),
	(5,1,NULL,NULL,'AssetClassifications',8,25),
	(6,5,NULL,NULL,'index',9,10),
	(7,5,NULL,NULL,'delete',11,12),
	(8,5,NULL,NULL,'add',13,14),
	(9,5,NULL,NULL,'edit',15,16),
	(12,1,NULL,NULL,'AssetLabels',26,41),
	(13,12,NULL,NULL,'index',27,28),
	(14,12,NULL,NULL,'delete',29,30),
	(15,12,NULL,NULL,'add',31,32),
	(16,12,NULL,NULL,'edit',33,34),
	(18,1,NULL,NULL,'AssetMediaTypes',42,57),
	(19,18,NULL,NULL,'index',43,44),
	(21,18,NULL,NULL,'add',45,46),
	(22,18,NULL,NULL,'delete',47,48),
	(24,1,NULL,NULL,'Assets',58,79),
	(25,24,NULL,NULL,'index',59,60),
	(26,24,NULL,NULL,'delete',61,62),
	(27,24,NULL,NULL,'add',63,64),
	(28,24,NULL,NULL,'edit',65,66),
	(32,1,NULL,NULL,'Attachments',80,95),
	(71,1,NULL,NULL,'BackupRestore',96,109),
	(75,1,NULL,NULL,'BusinessContinuities',110,137),
	(76,75,NULL,NULL,'index',111,112),
	(77,75,NULL,NULL,'delete',113,114),
	(78,75,NULL,NULL,'add',115,116),
	(79,75,NULL,NULL,'edit',117,118),
	(81,75,NULL,NULL,'getThreatsVulnerabilities',119,120),
	(84,1,NULL,NULL,'BusinessContinuityPlanAuditImprovements',138,147),
	(85,84,NULL,NULL,'delete',139,140),
	(86,84,NULL,NULL,'add',141,142),
	(87,84,NULL,NULL,'edit',143,144),
	(89,1,NULL,NULL,'BusinessContinuityPlanAudits',148,165),
	(90,89,NULL,NULL,'index',149,150),
	(91,89,NULL,NULL,'delete',151,152),
	(92,89,NULL,NULL,'edit',153,154),
	(94,1,NULL,NULL,'BusinessContinuityPlans',166,197),
	(95,94,NULL,NULL,'index',167,168),
	(96,94,NULL,NULL,'delete',169,170),
	(97,94,NULL,NULL,'acknowledge',171,172),
	(98,94,NULL,NULL,'acknowledgeItem',173,174),
	(99,94,NULL,NULL,'add',175,176),
	(100,94,NULL,NULL,'edit',177,178),
	(102,94,NULL,NULL,'auditCalendarFormEntry',179,180),
	(103,94,NULL,NULL,'export',181,182),
	(104,94,NULL,NULL,'exportAudits',183,184),
	(105,94,NULL,NULL,'exportTask',185,186),
	(106,94,NULL,NULL,'exportPdf',187,188),
	(108,1,NULL,NULL,'BusinessContinuityTasks',198,215),
	(109,108,NULL,NULL,'delete',199,200),
	(110,108,NULL,NULL,'add',201,202),
	(111,108,NULL,NULL,'edit',203,204),
	(113,1,NULL,NULL,'BusinessUnits',216,233),
	(114,113,NULL,NULL,'index',217,218),
	(115,113,NULL,NULL,'delete',219,220),
	(116,113,NULL,NULL,'add',221,222),
	(117,113,NULL,NULL,'edit',223,224),
	(119,1,NULL,NULL,'Comments',234,245),
	(153,1,NULL,NULL,'ComplianceExceptions',246,263),
	(154,153,NULL,NULL,'index',247,248),
	(155,153,NULL,NULL,'delete',249,250),
	(156,153,NULL,NULL,'add',251,252),
	(157,153,NULL,NULL,'edit',253,254),
	(167,1,NULL,NULL,'ComplianceManagements',264,281),
	(168,167,NULL,NULL,'index',265,266),
	(170,167,NULL,NULL,'add',267,268),
	(171,167,NULL,NULL,'edit',269,270),
	(175,1,NULL,NULL,'CompliancePackageItems',282,303),
	(176,175,NULL,NULL,'delete',283,284),
	(177,175,NULL,NULL,'add',285,286),
	(178,175,NULL,NULL,'edit',287,288),
	(180,1,NULL,NULL,'CompliancePackages',304,325),
	(181,180,NULL,NULL,'index',305,306),
	(182,180,NULL,NULL,'delete',307,308),
	(183,180,NULL,NULL,'add',309,310),
	(184,180,NULL,NULL,'edit',311,312),
	(185,180,NULL,NULL,'import',313,314),
	(191,1,NULL,NULL,'Cron',326,337),
	(199,1,NULL,NULL,'DataAssets',338,363),
	(200,199,NULL,NULL,'index',339,340),
	(201,199,NULL,NULL,'delete',341,342),
	(202,199,NULL,NULL,'add',343,344),
	(203,199,NULL,NULL,'edit',345,346),
	(206,1,NULL,NULL,'GoalAuditImprovements',364,373),
	(207,206,NULL,NULL,'delete',365,366),
	(208,206,NULL,NULL,'add',367,368),
	(209,206,NULL,NULL,'edit',369,370),
	(211,1,NULL,NULL,'GoalAudits',374,391),
	(212,211,NULL,NULL,'index',375,376),
	(213,211,NULL,NULL,'delete',377,378),
	(214,211,NULL,NULL,'edit',379,380),
	(216,1,NULL,NULL,'Goals',392,413),
	(217,216,NULL,NULL,'index',393,394),
	(218,216,NULL,NULL,'delete',395,396),
	(219,216,NULL,NULL,'add',397,398),
	(220,216,NULL,NULL,'edit',399,400),
	(221,216,NULL,NULL,'auditCalendarFormEntry',401,402),
	(222,216,NULL,NULL,'exportPdf',403,404),
	(224,1,NULL,NULL,'Groups',414,425),
	(225,224,NULL,NULL,'index',415,416),
	(226,224,NULL,NULL,'add',417,418),
	(227,224,NULL,NULL,'edit',419,420),
	(228,224,NULL,NULL,'delete',421,422),
	(230,1,NULL,NULL,'Issues',426,439),
	(231,230,NULL,NULL,'index',427,428),
	(232,230,NULL,NULL,'add',429,430),
	(233,230,NULL,NULL,'edit',431,432),
	(234,230,NULL,NULL,'delete',433,434),
	(236,1,NULL,NULL,'LdapConnectors',440,455),
	(237,236,NULL,NULL,'index',441,442),
	(238,236,NULL,NULL,'delete',443,444),
	(239,236,NULL,NULL,'add',445,446),
	(240,236,NULL,NULL,'edit',447,448),
	(242,236,NULL,NULL,'testLdap',449,450),
	(244,1,NULL,NULL,'Legals',456,473),
	(245,244,NULL,NULL,'index',457,458),
	(246,244,NULL,NULL,'delete',459,460),
	(247,244,NULL,NULL,'add',461,462),
	(248,244,NULL,NULL,'edit',463,464),
	(266,1,NULL,NULL,'Notifications',474,479),
	(267,266,NULL,NULL,'setNotificationsAsSeen',475,476),
	(269,1,NULL,NULL,'Pages',480,491),
	(271,269,NULL,NULL,'dashboard',481,482),
	(272,269,NULL,NULL,'about',483,484),
	(274,1,NULL,NULL,'Policy',492,513),
	(275,274,NULL,NULL,'login',493,494),
	(276,274,NULL,NULL,'guestLogin',495,496),
	(277,274,NULL,NULL,'logout',497,498),
	(278,274,NULL,NULL,'index',499,500),
	(279,274,NULL,NULL,'isGuest',501,502),
	(280,274,NULL,NULL,'document',503,504),
	(281,274,NULL,NULL,'documentDirect',505,506),
	(282,274,NULL,NULL,'documentPdf',507,508),
	(284,1,NULL,NULL,'PolicyExceptions',514,531),
	(285,284,NULL,NULL,'index',515,516),
	(286,284,NULL,NULL,'delete',517,518),
	(287,284,NULL,NULL,'add',519,520),
	(288,284,NULL,NULL,'edit',521,522),
	(291,1,NULL,NULL,'Processes',532,549),
	(292,291,NULL,NULL,'index',533,534),
	(293,291,NULL,NULL,'delete',535,536),
	(294,291,NULL,NULL,'add',537,538),
	(295,291,NULL,NULL,'edit',539,540),
	(297,1,NULL,NULL,'ProgramIssues',550,567),
	(298,297,NULL,NULL,'index',551,552),
	(299,297,NULL,NULL,'delete',553,554),
	(300,297,NULL,NULL,'add',555,556),
	(301,297,NULL,NULL,'edit',557,558),
	(304,1,NULL,NULL,'ProgramScopes',568,585),
	(305,304,NULL,NULL,'index',569,570),
	(306,304,NULL,NULL,'delete',571,572),
	(307,304,NULL,NULL,'add',573,574),
	(308,304,NULL,NULL,'edit',575,576),
	(311,1,NULL,NULL,'ProjectAchievements',586,603),
	(312,311,NULL,NULL,'index',587,588),
	(313,311,NULL,NULL,'delete',589,590),
	(314,311,NULL,NULL,'add',591,592),
	(315,311,NULL,NULL,'edit',593,594),
	(317,1,NULL,NULL,'ProjectExpenses',604,621),
	(318,317,NULL,NULL,'index',605,606),
	(319,317,NULL,NULL,'delete',607,608),
	(320,317,NULL,NULL,'add',609,610),
	(321,317,NULL,NULL,'edit',611,612),
	(323,1,NULL,NULL,'Projects',622,639),
	(324,323,NULL,NULL,'index',623,624),
	(325,323,NULL,NULL,'delete',625,626),
	(326,323,NULL,NULL,'add',627,628),
	(327,323,NULL,NULL,'edit',629,630),
	(334,1,NULL,NULL,'Reviews',640,661),
	(335,334,NULL,NULL,'index',641,642),
	(336,334,NULL,NULL,'add',643,644),
	(337,334,NULL,NULL,'edit',645,646),
	(338,334,NULL,NULL,'delete',647,648),
	(340,1,NULL,NULL,'RiskClassifications',662,677),
	(341,340,NULL,NULL,'index',663,664),
	(342,340,NULL,NULL,'delete',665,666),
	(343,340,NULL,NULL,'add',667,668),
	(344,340,NULL,NULL,'edit',669,670),
	(347,1,NULL,NULL,'RiskExceptions',678,695),
	(348,347,NULL,NULL,'index',679,680),
	(349,347,NULL,NULL,'delete',681,682),
	(350,347,NULL,NULL,'add',683,684),
	(351,347,NULL,NULL,'edit',685,686),
	(359,1,NULL,NULL,'Risks',696,723),
	(360,359,NULL,NULL,'index',697,698),
	(361,359,NULL,NULL,'delete',699,700),
	(362,359,NULL,NULL,'add',701,702),
	(363,359,NULL,NULL,'edit',703,704),
	(364,359,NULL,NULL,'calculateRiskScoreAjax',705,706),
	(365,359,NULL,NULL,'getThreatsVulnerabilities',707,708),
	(369,1,NULL,NULL,'Scopes',724,735),
	(370,369,NULL,NULL,'index',725,726),
	(371,369,NULL,NULL,'delete',727,728),
	(372,369,NULL,NULL,'add',729,730),
	(373,369,NULL,NULL,'edit',731,732),
	(379,1,NULL,NULL,'SecurityIncidentClassifications',736,747),
	(380,379,NULL,NULL,'index',737,738),
	(381,379,NULL,NULL,'delete',739,740),
	(382,379,NULL,NULL,'add',741,742),
	(383,379,NULL,NULL,'edit',743,744),
	(385,1,NULL,NULL,'SecurityIncidentStages',748,763),
	(386,385,NULL,NULL,'index',749,750),
	(387,385,NULL,NULL,'add',751,752),
	(388,385,NULL,NULL,'edit',753,754),
	(389,385,NULL,NULL,'delete',755,756),
	(392,1,NULL,NULL,'SecurityIncidents',764,791),
	(393,392,NULL,NULL,'index',765,766),
	(395,392,NULL,NULL,'delete',767,768),
	(396,392,NULL,NULL,'add',769,770),
	(397,392,NULL,NULL,'edit',771,772),
	(398,392,NULL,NULL,'getAssets',773,774),
	(399,392,NULL,NULL,'getThirdParties',775,776),
	(407,1,NULL,NULL,'SecurityPolicies',792,817),
	(408,407,NULL,NULL,'index',793,794),
	(409,407,NULL,NULL,'delete',795,796),
	(410,407,NULL,NULL,'add',797,798),
	(411,407,NULL,NULL,'edit',799,800),
	(412,407,NULL,NULL,'getDirectLink',801,802),
	(413,407,NULL,NULL,'duplicate',803,804),
	(414,407,NULL,NULL,'ldapGroups',805,806),
	(416,407,NULL,NULL,'sendNotifications',807,808),
	(418,1,NULL,NULL,'SecurityPolicyReviews',818,841),
	(419,418,NULL,NULL,'index',819,820),
	(420,418,NULL,NULL,'edit',821,822),
	(421,418,NULL,NULL,'delete',823,824),
	(423,1,NULL,NULL,'SecurityServiceAuditImprovements',842,851),
	(424,423,NULL,NULL,'delete',843,844),
	(425,423,NULL,NULL,'add',845,846),
	(426,423,NULL,NULL,'edit',847,848),
	(428,1,NULL,NULL,'SecurityServiceAudits',852,871),
	(429,428,NULL,NULL,'index',853,854),
	(430,428,NULL,NULL,'delete',855,856),
	(431,428,NULL,NULL,'edit',857,858),
	(433,1,NULL,NULL,'SecurityServiceMaintenances',872,889),
	(434,433,NULL,NULL,'index',873,874),
	(435,433,NULL,NULL,'delete',875,876),
	(436,433,NULL,NULL,'edit',877,878),
	(438,1,NULL,NULL,'SecurityServices',890,911),
	(439,438,NULL,NULL,'index',891,892),
	(440,438,NULL,NULL,'delete',893,894),
	(441,438,NULL,NULL,'add',895,896),
	(442,438,NULL,NULL,'edit',897,898),
	(444,438,NULL,NULL,'auditCalendarFormEntry',899,900),
	(450,1,NULL,NULL,'ServiceClassifications',912,923),
	(451,450,NULL,NULL,'index',913,914),
	(452,450,NULL,NULL,'delete',915,916),
	(453,450,NULL,NULL,'add',917,918),
	(454,450,NULL,NULL,'edit',919,920),
	(456,1,NULL,NULL,'ServiceContracts',924,941),
	(457,456,NULL,NULL,'index',925,926),
	(458,456,NULL,NULL,'delete',927,928),
	(459,456,NULL,NULL,'add',929,930),
	(460,456,NULL,NULL,'edit',931,932),
	(462,1,NULL,NULL,'Settings',942,1001),
	(463,462,NULL,NULL,'index',943,944),
	(464,462,NULL,NULL,'edit',945,946),
	(465,462,NULL,NULL,'logs',947,948),
	(466,462,NULL,NULL,'deleteLogs',949,950),
	(467,462,NULL,NULL,'testMailConnection',951,952),
	(468,462,NULL,NULL,'resetDashboards',953,954),
	(469,462,NULL,NULL,'customLogo',955,956),
	(470,462,NULL,NULL,'deleteCache',957,958),
	(471,462,NULL,NULL,'resetDatabase',959,960),
	(472,462,NULL,NULL,'systemHealth',961,962),
	(474,1,NULL,NULL,'SystemRecords',1002,1009),
	(475,474,NULL,NULL,'index',1003,1004),
	(476,474,NULL,NULL,'export',1005,1006),
	(478,1,NULL,NULL,'TeamRoles',1010,1027),
	(479,478,NULL,NULL,'index',1011,1012),
	(480,478,NULL,NULL,'delete',1013,1014),
	(481,478,NULL,NULL,'add',1015,1016),
	(482,478,NULL,NULL,'edit',1017,1018),
	(485,1,NULL,NULL,'ThirdParties',1028,1045),
	(486,485,NULL,NULL,'index',1029,1030),
	(487,485,NULL,NULL,'delete',1031,1032),
	(488,485,NULL,NULL,'add',1033,1034),
	(489,485,NULL,NULL,'edit',1035,1036),
	(491,1,NULL,NULL,'ThirdPartyRisks',1046,1069),
	(492,491,NULL,NULL,'index',1047,1048),
	(493,491,NULL,NULL,'delete',1049,1050),
	(494,491,NULL,NULL,'add',1051,1052),
	(495,491,NULL,NULL,'edit',1053,1054),
	(500,1,NULL,NULL,'Threats',1070,1085),
	(501,500,NULL,NULL,'index',1071,1072),
	(503,500,NULL,NULL,'add',1073,1074),
	(504,500,NULL,NULL,'delete',1075,1076),
	(506,1,NULL,NULL,'Users',1086,1119),
	(507,506,NULL,NULL,'index',1087,1088),
	(508,506,NULL,NULL,'add',1089,1090),
	(509,506,NULL,NULL,'edit',1091,1092),
	(510,506,NULL,NULL,'delete',1093,1094),
	(511,506,NULL,NULL,'profile',1095,1096),
	(512,506,NULL,NULL,'resetpassword',1097,1098),
	(513,506,NULL,NULL,'useticket',1099,1100),
	(514,506,NULL,NULL,'login',1101,1102),
	(515,506,NULL,NULL,'logout',1103,1104),
	(518,1,NULL,NULL,'Vulnerabilities',1120,1135),
	(519,518,NULL,NULL,'index',1121,1122),
	(521,518,NULL,NULL,'add',1123,1124),
	(522,518,NULL,NULL,'delete',1125,1126),
	(524,1,NULL,NULL,'Workflows',1136,1179),
	(658,269,NULL,NULL,'license',485,486),
	(696,506,NULL,NULL,'changeLanguage',1105,1106),
	(733,108,NULL,NULL,'index',205,206),
	(961,269,NULL,NULL,'welcome',487,488),
	(1042,506,NULL,NULL,'unblock',1107,1108),
	(1083,392,NULL,NULL,'reloadLifecycle',777,778),
	(1124,1,NULL,NULL,'Acl',1180,1241),
	(1125,1124,NULL,NULL,'Acl',1181,1188),
	(1126,1125,NULL,NULL,'index',1182,1183),
	(1127,1125,NULL,NULL,'admin_index',1184,1185),
	(1130,1124,NULL,NULL,'Acos',1189,1202),
	(1131,1130,NULL,NULL,'admin_index',1190,1191),
	(1132,1130,NULL,NULL,'admin_empty_acos',1192,1193),
	(1133,1130,NULL,NULL,'admin_build_acl',1194,1195),
	(1134,1130,NULL,NULL,'admin_prune_acos',1196,1197),
	(1135,1130,NULL,NULL,'admin_synchronize',1198,1199),
	(1138,1124,NULL,NULL,'Aros',1203,1240),
	(1139,1138,NULL,NULL,'admin_index',1204,1205),
	(1140,1138,NULL,NULL,'admin_check',1206,1207),
	(1141,1138,NULL,NULL,'admin_users',1208,1209),
	(1142,1138,NULL,NULL,'admin_update_user_role',1210,1211),
	(1143,1138,NULL,NULL,'admin_ajax_role_permissions',1212,1213),
	(1144,1138,NULL,NULL,'admin_role_permissions',1214,1215),
	(1145,1138,NULL,NULL,'admin_user_permissions',1216,1217),
	(1146,1138,NULL,NULL,'admin_empty_permissions',1218,1219),
	(1147,1138,NULL,NULL,'admin_clear_user_specific_permissions',1220,1221),
	(1148,1138,NULL,NULL,'admin_grant_all_controllers',1222,1223),
	(1149,1138,NULL,NULL,'admin_deny_all_controllers',1224,1225),
	(1150,1138,NULL,NULL,'admin_get_role_controller_permission',1226,1227),
	(1151,1138,NULL,NULL,'admin_grant_role_permission',1228,1229),
	(1152,1138,NULL,NULL,'admin_deny_role_permission',1230,1231),
	(1153,1138,NULL,NULL,'admin_get_user_controller_permission',1232,1233),
	(1154,1138,NULL,NULL,'admin_grant_user_permission',1234,1235),
	(1155,1138,NULL,NULL,'admin_deny_user_permission',1236,1237),
	(1158,1,NULL,NULL,'DebugKit',1242,1251),
	(1159,1158,NULL,NULL,'ToolbarAccess',1243,1250),
	(1160,1159,NULL,NULL,'history_state',1244,1245),
	(1161,1159,NULL,NULL,'sql_explain',1246,1247),
	(1303,1,NULL,NULL,'News',1252,1259),
	(1368,1,NULL,NULL,'RiskCalculations',1260,1275),
	(1369,1368,NULL,NULL,'warning',1261,1262),
	(1370,1368,NULL,NULL,'edit',1263,1264),
	(1429,428,NULL,NULL,'getIndexUrlFromComponent',859,860),
	(1475,1,NULL,NULL,'Updates',1276,1281),
	(1476,1475,NULL,NULL,'index',1277,1278),
	(1484,506,NULL,NULL,'searchLdapUsers',1109,1110),
	(1549,167,NULL,NULL,'getPolicies',271,272),
	(1551,392,NULL,NULL,'getControls',779,780),
	(1552,392,NULL,NULL,'getRiskProcedures',781,782),
	(1553,462,NULL,NULL,'getTimeByTimezone',963,964),
	(1554,75,NULL,NULL,'getPolicies',121,122),
	(1559,359,NULL,NULL,'getPolicies',709,710),
	(1561,491,NULL,NULL,'getPolicies',1055,1056),
	(1562,1,NULL,NULL,'ImportTool',1282,1293),
	(1563,1562,NULL,NULL,'ImportTool',1283,1292),
	(1565,1563,NULL,NULL,'downloadTemplate',1284,1285),
	(1566,1563,NULL,NULL,'preview',1286,1287),
	(1573,24,NULL,NULL,'getLegals',67,68),
	(1575,1,NULL,NULL,'AwarenessProgramUsers',1294,1299),
	(1576,1575,NULL,NULL,'index',1295,1296),
	(1585,1,NULL,NULL,'AwarenessReminders',1300,1305),
	(1586,1585,NULL,NULL,'index',1301,1302),
	(1593,1,NULL,NULL,'AwarenessTrainings',1306,1311),
	(1594,1593,NULL,NULL,'index',1307,1308),
	(1601,175,NULL,NULL,'index',289,290),
	(1915,180,NULL,NULL,'duplicate',315,316),
	(1947,274,NULL,NULL,'downloadAttachment',509,510),
	(1966,1,NULL,NULL,'Queue',1312,1319),
	(1967,1966,NULL,NULL,'index',1313,1314),
	(1968,1966,NULL,NULL,'delete',1315,1316),
	(2021,462,NULL,NULL,'downloadLogs',965,966),
	(2022,462,NULL,NULL,'getLogo',967,968),
	(2047,71,NULL,NULL,'BackupRestore',97,108),
	(2048,2047,NULL,NULL,'index',98,99),
	(2049,2047,NULL,NULL,'getBackup',100,101),
	(2060,1,NULL,NULL,'BulkActions',1320,1329),
	(2061,2060,NULL,NULL,'BulkActions',1321,1328),
	(2062,2061,NULL,NULL,'apply',1322,1323),
	(2063,2061,NULL,NULL,'submit',1324,1325),
	(2082,1,NULL,NULL,'ObjectVersion',1330,1339),
	(2083,2082,NULL,NULL,'ObjectVersion',1331,1338),
	(2084,2083,NULL,NULL,'history',1332,1333),
	(2085,2083,NULL,NULL,'restore',1334,1335),
	(2104,NULL,NULL,NULL,'visualisation',1905,2020),
	(2105,2104,NULL,NULL,'models',1906,2015),
	(2106,2104,NULL,NULL,'objects',2016,2019),
	(2107,2105,'CompliancePackageRegulator',NULL,'CompliancePackageRegulator::',1907,1912),
	(2108,2105,'Asset',NULL,'Asset::',1913,1920),
	(2109,2108,'AssetReview',NULL,'AssetReview::',1914,1915),
	(2110,2105,'Risk',NULL,'Risk::',1921,1924),
	(2111,2105,'ThirdPartyRisk',NULL,'ThirdPartyRisk::',1925,1928),
	(2112,2105,'BusinessContinuity',NULL,'BusinessContinuity::',1929,1932),
	(2113,2110,'RiskReview',NULL,'RiskReview::',1922,1923),
	(2114,2111,'ThirdPartyRiskReview',NULL,'ThirdPartyRiskReview::',1926,1927),
	(2115,2112,'BusinessContinuityReview',NULL,'BusinessContinuityReview::',1930,1931),
	(2116,2105,'SecurityPolicy',NULL,'SecurityPolicy::',1933,1936),
	(2117,2116,'SecurityPolicyReview',NULL,'SecurityPolicyReview::',1934,1935),
	(2118,2105,'SecurityService',NULL,'SecurityService::',1937,1944),
	(2119,2118,'SecurityServiceAudit',NULL,'SecurityServiceAudit::',1938,1939),
	(2120,2118,'SecurityServiceMaintenance',NULL,'SecurityServiceMaintenance::',1940,1941),
	(2121,2105,'ComplianceException',NULL,'ComplianceException::',1945,1946),
	(2122,2105,'ComplianceAudit',NULL,'ComplianceAudit::',1947,1952),
	(2123,2105,'ComplianceAnalysisFinding',NULL,'ComplianceAnalysisFinding::',1953,1954),
	(2124,2122,'ComplianceAuditSetting',NULL,'ComplianceAuditSetting::',1948,1949),
	(2125,2122,'ComplianceFinding',NULL,'ComplianceFinding::',1950,1951),
	(2126,2105,'BusinessUnit',NULL,'BusinessUnit::',1955,1958),
	(2127,2105,'AwarenessProgram',NULL,'AwarenessProgram::',1959,1960),
	(2128,2105,'BusinessContinuityPlan',NULL,'BusinessContinuityPlan::',1961,1966),
	(2129,2128,'BusinessContinuityPlanAudit',NULL,'BusinessContinuityPlanAudit::',1962,1963),
	(2130,2108,'DataAssetInstance',NULL,'DataAssetInstance::',1916,1919),
	(2131,2130,'DataAsset',NULL,'DataAsset::',1917,1918),
	(2132,2105,'Goal',NULL,'Goal::',1967,1970),
	(2133,2105,'Legal',NULL,'Legal::',1971,1972),
	(2134,2105,'PolicyException',NULL,'PolicyException::',1973,1974),
	(2135,2126,'Process',NULL,'Process::',1956,1957),
	(2136,2105,'ProgramIssue',NULL,'ProgramIssue::',1975,1976),
	(2137,2105,'ProgramScope',NULL,'ProgramScope::',1977,1978),
	(2138,2105,'Project',NULL,'Project::',1979,1984),
	(2139,2138,'ProjectAchievement',NULL,'ProjectAchievement::',1980,1981),
	(2140,2138,'ProjectExpense',NULL,'ProjectExpense::',1982,1983),
	(2141,2105,'RiskException',NULL,'RiskException::',1985,1986),
	(2142,2105,'SecurityIncident',NULL,'SecurityIncident::',1987,1988),
	(2143,2105,'ThirdParty',NULL,'ThirdParty::',1989,1990),
	(2144,2105,'VendorAssessment',NULL,'VendorAssessment::',1991,1996),
	(2145,2144,'VendorAssessmentFinding',NULL,'VendorAssessmentFinding::',1992,1993),
	(2146,2105,'AccountReview',NULL,'AccountReview::',1997,2004),
	(2147,2146,'AccountReviewPull',NULL,'AccountReviewPull::',1998,2003),
	(2148,2147,'AccountReviewFeedback',NULL,'AccountReviewFeedback::',1999,2000),
	(2149,2147,'AccountReviewFinding',NULL,'AccountReviewFinding::',2001,2002),
	(2150,2107,'ComplianceManagement',NULL,'ComplianceManagement::',1908,1909),
	(2151,2105,'ServiceContract',NULL,'ServiceContract::',2005,2006),
	(2152,2105,'TeamRole',NULL,'TeamRole::',2007,2008),
	(2153,2118,'SecurityServiceIssue',NULL,'SecurityServiceIssue::',1942,1943),
	(2154,2105,'CompliancePackage',NULL,'CompliancePackage::',2009,2010),
	(2155,2105,'DataAssetSetting',NULL,'DataAssetSetting::',2011,2012),
	(2156,2132,'GoalAudit',NULL,'GoalAudit::',1968,1969),
	(2157,2128,'BusinessContinuityTask',NULL,'BusinessContinuityTask::',1964,1965),
	(2158,2107,'CompliancePackageItem',NULL,'CompliancePackageItem::',1910,1911),
	(2159,2,NULL,NULL,'downloadAttachment',5,6),
	(2160,5,NULL,NULL,'history',17,18),
	(2161,5,NULL,NULL,'restore',19,20),
	(2162,5,NULL,NULL,'getCriteria',21,22),
	(2163,5,NULL,NULL,'downloadAttachment',23,24),
	(2164,12,NULL,NULL,'history',35,36),
	(2165,12,NULL,NULL,'restore',37,38),
	(2166,12,NULL,NULL,'downloadAttachment',39,40),
	(2167,18,NULL,NULL,'edit',49,50),
	(2168,18,NULL,NULL,'history',51,52),
	(2169,18,NULL,NULL,'restore',53,54),
	(2170,18,NULL,NULL,'downloadAttachment',55,56),
	(2171,1,NULL,NULL,'AssetReviews',1340,1359),
	(2172,2171,NULL,NULL,'listArgs',1341,1342),
	(2173,2171,NULL,NULL,'index',1343,1344),
	(2174,2171,NULL,NULL,'add',1345,1346),
	(2175,2171,NULL,NULL,'edit',1347,1348),
	(2176,2171,NULL,NULL,'delete',1349,1350),
	(2177,2171,NULL,NULL,'trash',1351,1352),
	(2178,2171,NULL,NULL,'history',1353,1354),
	(2179,2171,NULL,NULL,'restore',1355,1356),
	(2180,2171,NULL,NULL,'downloadAttachment',1357,1358),
	(2181,24,NULL,NULL,'trash',69,70),
	(2182,24,NULL,NULL,'history',71,72),
	(2183,24,NULL,NULL,'restore',73,74),
	(2184,24,NULL,NULL,'beforeAddEditRender',75,76),
	(2185,24,NULL,NULL,'downloadAttachment',77,78),
	(2187,1,NULL,NULL,'AwarenessProgramActiveUsers',1360,1365),
	(2188,2187,NULL,NULL,'index',1361,1362),
	(2189,2187,NULL,NULL,'downloadAttachment',1363,1364),
	(2190,1,NULL,NULL,'AwarenessProgramCompliantUsers',1366,1371),
	(2191,2190,NULL,NULL,'index',1367,1368),
	(2192,2190,NULL,NULL,'downloadAttachment',1369,1370),
	(2193,1,NULL,NULL,'AwarenessProgramIgnoredUsers',1372,1377),
	(2194,2193,NULL,NULL,'index',1373,1374),
	(2195,2193,NULL,NULL,'downloadAttachment',1375,1376),
	(2196,1,NULL,NULL,'AwarenessProgramNotCompliantUsers',1378,1383),
	(2197,2196,NULL,NULL,'index',1379,1380),
	(2198,2196,NULL,NULL,'downloadAttachment',1381,1382),
	(2199,1575,NULL,NULL,'downloadAttachment',1297,1298),
	(2206,1585,NULL,NULL,'downloadAttachment',1303,1304),
	(2207,1593,NULL,NULL,'downloadAttachment',1309,1310),
	(2208,75,NULL,NULL,'trash',123,124),
	(2209,75,NULL,NULL,'processClassifications',125,126),
	(2210,75,NULL,NULL,'getProcesses',127,128),
	(2211,75,NULL,NULL,'initOptions',129,130),
	(2212,75,NULL,NULL,'history',131,132),
	(2213,75,NULL,NULL,'restore',133,134),
	(2214,75,NULL,NULL,'downloadAttachment',135,136),
	(2215,84,NULL,NULL,'downloadAttachment',145,146),
	(2216,89,NULL,NULL,'add',155,156),
	(2217,89,NULL,NULL,'history',157,158),
	(2218,89,NULL,NULL,'restore',159,160),
	(2219,89,NULL,NULL,'trash',161,162),
	(2220,89,NULL,NULL,'downloadAttachment',163,164),
	(2221,94,NULL,NULL,'trash',189,190),
	(2222,94,NULL,NULL,'history',191,192),
	(2223,94,NULL,NULL,'restore',193,194),
	(2224,94,NULL,NULL,'downloadAttachment',195,196),
	(2225,1,NULL,NULL,'BusinessContinuityReviews',1384,1403),
	(2226,2225,NULL,NULL,'listArgs',1385,1386),
	(2227,2225,NULL,NULL,'index',1387,1388),
	(2228,2225,NULL,NULL,'add',1389,1390),
	(2229,2225,NULL,NULL,'edit',1391,1392),
	(2230,2225,NULL,NULL,'delete',1393,1394),
	(2231,2225,NULL,NULL,'trash',1395,1396),
	(2232,2225,NULL,NULL,'history',1397,1398),
	(2233,2225,NULL,NULL,'restore',1399,1400),
	(2234,2225,NULL,NULL,'downloadAttachment',1401,1402),
	(2235,108,NULL,NULL,'history',207,208),
	(2236,108,NULL,NULL,'restore',209,210),
	(2237,108,NULL,NULL,'trash',211,212),
	(2238,108,NULL,NULL,'downloadAttachment',213,214),
	(2239,113,NULL,NULL,'trash',225,226),
	(2240,113,NULL,NULL,'history',227,228),
	(2241,113,NULL,NULL,'restore',229,230),
	(2242,113,NULL,NULL,'downloadAttachment',231,232),
	(2243,1,NULL,NULL,'ComplianceAnalysisFindings',1404,1425),
	(2244,2243,NULL,NULL,'index',1405,1406),
	(2245,2243,NULL,NULL,'delete',1407,1408),
	(2246,2243,NULL,NULL,'trash',1409,1410),
	(2247,2243,NULL,NULL,'add',1411,1412),
	(2248,2243,NULL,NULL,'edit',1413,1414),
	(2249,2243,NULL,NULL,'loadPackageItems',1415,1416),
	(2250,2243,NULL,NULL,'initPackageItems',1417,1418),
	(2252,2243,NULL,NULL,'history',1419,1420),
	(2253,2243,NULL,NULL,'restore',1421,1422),
	(2254,2243,NULL,NULL,'downloadAttachment',1423,1424),
	(2263,153,NULL,NULL,'trash',255,256),
	(2264,153,NULL,NULL,'history',257,258),
	(2265,153,NULL,NULL,'restore',259,260),
	(2266,153,NULL,NULL,'downloadAttachment',261,262),
	(2270,167,NULL,NULL,'delete',273,274),
	(2271,167,NULL,NULL,'history',275,276),
	(2272,167,NULL,NULL,'restore',277,278),
	(2273,167,NULL,NULL,'downloadAttachment',279,280),
	(2274,1,NULL,NULL,'CompliancePackageInstances',1426,1429),
	(2275,2274,NULL,NULL,'downloadAttachment',1427,1428),
	(2276,175,NULL,NULL,'loadPackages',291,292),
	(2277,175,NULL,NULL,'loadPackageFormFields',293,294),
	(2278,175,NULL,NULL,'history',295,296),
	(2279,175,NULL,NULL,'restore',297,298),
	(2280,175,NULL,NULL,'trash',299,300),
	(2281,175,NULL,NULL,'downloadAttachment',301,302),
	(2282,1,NULL,NULL,'CompliancePackageRegulators',1430,1447),
	(2283,2282,NULL,NULL,'index',1431,1432),
	(2284,2282,NULL,NULL,'delete',1433,1434),
	(2285,2282,NULL,NULL,'trash',1435,1436),
	(2286,2282,NULL,NULL,'add',1437,1438),
	(2287,2282,NULL,NULL,'edit',1439,1440),
	(2288,2282,NULL,NULL,'history',1441,1442),
	(2289,2282,NULL,NULL,'restore',1443,1444),
	(2290,2282,NULL,NULL,'downloadAttachment',1445,1446),
	(2291,180,NULL,NULL,'trash',317,318),
	(2292,180,NULL,NULL,'history',319,320),
	(2293,180,NULL,NULL,'restore',321,322),
	(2294,180,NULL,NULL,'downloadAttachment',323,324),
	(2295,1,NULL,NULL,'DataAssetGdpr',1448,1451),
	(2296,2295,NULL,NULL,'downloadAttachment',1449,1450),
	(2297,1,NULL,NULL,'DataAssetInstances',1452,1457),
	(2298,2297,NULL,NULL,'index',1453,1454),
	(2299,2297,NULL,NULL,'downloadAttachment',1455,1456),
	(2300,1,NULL,NULL,'DataAssetSettings',1458,1469),
	(2301,2300,NULL,NULL,'add',1459,1460),
	(2302,2300,NULL,NULL,'edit',1461,1462),
	(2303,2300,NULL,NULL,'history',1463,1464),
	(2304,2300,NULL,NULL,'restore',1465,1466),
	(2305,2300,NULL,NULL,'downloadAttachment',1467,1468),
	(2306,199,NULL,NULL,'trash',347,348),
	(2307,199,NULL,NULL,'getAssociatedRiskData',349,350),
	(2308,199,NULL,NULL,'getAssociatedThirdPartyRiskData',351,352),
	(2309,199,NULL,NULL,'getAssociatedBusinessContinuityData',353,354),
	(2310,199,NULL,NULL,'getAssociatedSecurityServices',355,356),
	(2311,199,NULL,NULL,'history',357,358),
	(2312,199,NULL,NULL,'restore',359,360),
	(2313,199,NULL,NULL,'downloadAttachment',361,362),
	(2314,206,NULL,NULL,'downloadAttachment',371,372),
	(2315,211,NULL,NULL,'add',381,382),
	(2316,211,NULL,NULL,'history',383,384),
	(2317,211,NULL,NULL,'restore',385,386),
	(2318,211,NULL,NULL,'trash',387,388),
	(2319,211,NULL,NULL,'downloadAttachment',389,390),
	(2320,216,NULL,NULL,'trash',405,406),
	(2321,216,NULL,NULL,'history',407,408),
	(2322,216,NULL,NULL,'restore',409,410),
	(2323,216,NULL,NULL,'downloadAttachment',411,412),
	(2324,224,NULL,NULL,'downloadAttachment',423,424),
	(2325,230,NULL,NULL,'listArgs',435,436),
	(2326,230,NULL,NULL,'downloadAttachment',437,438),
	(2327,1,NULL,NULL,'LdapConnectorAuthentications',1470,1475),
	(2328,2327,NULL,NULL,'edit',1471,1472),
	(2329,2327,NULL,NULL,'downloadAttachment',1473,1474),
	(2330,236,NULL,NULL,'testLdapForm',451,452),
	(2331,236,NULL,NULL,'downloadAttachment',453,454),
	(2332,244,NULL,NULL,'history',465,466),
	(2333,244,NULL,NULL,'restore',467,468),
	(2334,244,NULL,NULL,'trash',469,470),
	(2335,244,NULL,NULL,'downloadAttachment',471,472),
	(2337,266,NULL,NULL,'downloadAttachment',477,478),
	(2338,1,NULL,NULL,'OauthConnectors',1476,1487),
	(2339,2338,NULL,NULL,'index',1477,1478),
	(2340,2338,NULL,NULL,'add',1479,1480),
	(2341,2338,NULL,NULL,'edit',1481,1482),
	(2342,2338,NULL,NULL,'delete',1483,1484),
	(2343,2338,NULL,NULL,'downloadAttachment',1485,1486),
	(2344,269,NULL,NULL,'downloadAttachment',489,490),
	(2345,274,NULL,NULL,'appDocument',511,512),
	(2346,284,NULL,NULL,'trash',523,524),
	(2347,284,NULL,NULL,'history',525,526),
	(2348,284,NULL,NULL,'restore',527,528),
	(2349,284,NULL,NULL,'downloadAttachment',529,530),
	(2350,291,NULL,NULL,'trash',541,542),
	(2351,291,NULL,NULL,'history',543,544),
	(2352,291,NULL,NULL,'restore',545,546),
	(2353,291,NULL,NULL,'downloadAttachment',547,548),
	(2354,297,NULL,NULL,'trash',559,560),
	(2355,297,NULL,NULL,'history',561,562),
	(2356,297,NULL,NULL,'restore',563,564),
	(2357,297,NULL,NULL,'downloadAttachment',565,566),
	(2358,304,NULL,NULL,'trash',577,578),
	(2359,304,NULL,NULL,'history',579,580),
	(2360,304,NULL,NULL,'restore',581,582),
	(2361,304,NULL,NULL,'downloadAttachment',583,584),
	(2362,311,NULL,NULL,'trash',595,596),
	(2363,311,NULL,NULL,'history',597,598),
	(2364,311,NULL,NULL,'restore',599,600),
	(2365,311,NULL,NULL,'downloadAttachment',601,602),
	(2366,317,NULL,NULL,'trash',613,614),
	(2367,317,NULL,NULL,'history',615,616),
	(2368,317,NULL,NULL,'restore',617,618),
	(2369,317,NULL,NULL,'downloadAttachment',619,620),
	(2370,323,NULL,NULL,'trash',631,632),
	(2371,323,NULL,NULL,'history',633,634),
	(2372,323,NULL,NULL,'restore',635,636),
	(2373,323,NULL,NULL,'downloadAttachment',637,638),
	(2374,1966,NULL,NULL,'downloadAttachment',1317,1318),
	(2375,334,NULL,NULL,'getReviewModel',649,650),
	(2376,334,NULL,NULL,'getRelatedModel',651,652),
	(2377,334,NULL,NULL,'trash',653,654),
	(2378,334,NULL,NULL,'history',655,656),
	(2379,334,NULL,NULL,'restore',657,658),
	(2380,334,NULL,NULL,'downloadAttachment',659,660),
	(2381,1,NULL,NULL,'RiskAppetites',1488,1497),
	(2382,2381,NULL,NULL,'index',1489,1490),
	(2383,2381,NULL,NULL,'edit',1491,1492),
	(2384,2381,NULL,NULL,'thresholdItem',1493,1494),
	(2385,2381,NULL,NULL,'downloadAttachment',1495,1496),
	(2386,1368,NULL,NULL,'index',1265,1266),
	(2387,1368,NULL,NULL,'add',1267,1268),
	(2388,1368,NULL,NULL,'delete',1269,1270),
	(2389,1368,NULL,NULL,'trash',1271,1272),
	(2390,1368,NULL,NULL,'downloadAttachment',1273,1274),
	(2391,340,NULL,NULL,'history',671,672),
	(2392,340,NULL,NULL,'restore',673,674),
	(2393,340,NULL,NULL,'downloadAttachment',675,676),
	(2394,347,NULL,NULL,'trash',687,688),
	(2395,347,NULL,NULL,'history',689,690),
	(2396,347,NULL,NULL,'restore',691,692),
	(2397,347,NULL,NULL,'downloadAttachment',693,694),
	(2398,1,NULL,NULL,'RiskReviews',1498,1517),
	(2399,2398,NULL,NULL,'listArgs',1499,1500),
	(2400,2398,NULL,NULL,'index',1501,1502),
	(2401,2398,NULL,NULL,'add',1503,1504),
	(2402,2398,NULL,NULL,'edit',1505,1506),
	(2403,2398,NULL,NULL,'delete',1507,1508),
	(2404,2398,NULL,NULL,'trash',1509,1510),
	(2405,2398,NULL,NULL,'history',1511,1512),
	(2406,2398,NULL,NULL,'restore',1513,1514),
	(2407,2398,NULL,NULL,'downloadAttachment',1515,1516),
	(2408,359,NULL,NULL,'trash',711,712),
	(2409,359,NULL,NULL,'processClassifications',713,714),
	(2410,359,NULL,NULL,'initOptions',715,716),
	(2411,359,NULL,NULL,'history',717,718),
	(2412,359,NULL,NULL,'restore',719,720),
	(2413,359,NULL,NULL,'downloadAttachment',721,722),
	(2414,369,NULL,NULL,'downloadAttachment',733,734),
	(2415,379,NULL,NULL,'downloadAttachment',745,746),
	(2416,385,NULL,NULL,'history',757,758),
	(2417,385,NULL,NULL,'restore',759,760),
	(2418,385,NULL,NULL,'downloadAttachment',761,762),
	(2419,1,NULL,NULL,'SecurityIncidentStagesSecurityIncidents',1518,1525),
	(2420,2419,NULL,NULL,'index',1519,1520),
	(2421,2419,NULL,NULL,'edit',1521,1522),
	(2422,2419,NULL,NULL,'downloadAttachment',1523,1524),
	(2423,392,NULL,NULL,'trash',783,784),
	(2424,392,NULL,NULL,'history',785,786),
	(2425,392,NULL,NULL,'restore',787,788),
	(2426,392,NULL,NULL,'downloadAttachment',789,790),
	(2427,407,NULL,NULL,'trash',809,810),
	(2428,407,NULL,NULL,'history',811,812),
	(2429,407,NULL,NULL,'restore',813,814),
	(2430,407,NULL,NULL,'downloadAttachment',815,816),
	(2431,1,NULL,NULL,'SecurityPolicyDocumentTypes',1526,1541),
	(2432,2431,NULL,NULL,'index',1527,1528),
	(2433,2431,NULL,NULL,'add',1529,1530),
	(2434,2431,NULL,NULL,'edit',1531,1532),
	(2435,2431,NULL,NULL,'delete',1533,1534),
	(2436,2431,NULL,NULL,'history',1535,1536),
	(2437,2431,NULL,NULL,'restore',1537,1538),
	(2438,2431,NULL,NULL,'downloadAttachment',1539,1540),
	(2439,418,NULL,NULL,'add',825,826),
	(2440,418,NULL,NULL,'review',827,828),
	(2441,418,NULL,NULL,'reviewPdf',829,830),
	(2442,418,NULL,NULL,'listArgs',831,832),
	(2443,418,NULL,NULL,'trash',833,834),
	(2444,418,NULL,NULL,'history',835,836),
	(2445,418,NULL,NULL,'restore',837,838),
	(2446,418,NULL,NULL,'downloadAttachment',839,840),
	(2447,423,NULL,NULL,'downloadAttachment',849,850),
	(2448,428,NULL,NULL,'trash',861,862),
	(2449,428,NULL,NULL,'add',863,864),
	(2450,428,NULL,NULL,'history',865,866),
	(2451,428,NULL,NULL,'restore',867,868),
	(2452,428,NULL,NULL,'downloadAttachment',869,870),
	(2453,1,NULL,NULL,'SecurityServiceIssues',1542,1555),
	(2454,2453,NULL,NULL,'listArgs',1543,1544),
	(2455,2453,NULL,NULL,'index',1545,1546),
	(2456,2453,NULL,NULL,'add',1547,1548),
	(2457,2453,NULL,NULL,'edit',1549,1550),
	(2458,2453,NULL,NULL,'delete',1551,1552),
	(2459,2453,NULL,NULL,'downloadAttachment',1553,1554),
	(2460,433,NULL,NULL,'trash',879,880),
	(2461,433,NULL,NULL,'add',881,882),
	(2462,433,NULL,NULL,'history',883,884),
	(2463,433,NULL,NULL,'restore',885,886),
	(2464,433,NULL,NULL,'downloadAttachment',887,888),
	(2465,438,NULL,NULL,'trash',901,902),
	(2466,438,NULL,NULL,'history',903,904),
	(2467,438,NULL,NULL,'restore',905,906),
	(2468,438,NULL,NULL,'downloadAttachment',907,908),
	(2469,450,NULL,NULL,'downloadAttachment',921,922),
	(2470,456,NULL,NULL,'trash',933,934),
	(2471,456,NULL,NULL,'history',935,936),
	(2472,456,NULL,NULL,'restore',937,938),
	(2473,456,NULL,NULL,'downloadAttachment',939,940),
	(2474,462,NULL,NULL,'zipErrorLogFiles',969,970),
	(2475,462,NULL,NULL,'residualRisk',971,972),
	(2476,462,NULL,NULL,'testPdf',973,974),
	(2477,462,NULL,NULL,'downloadTestPdf',975,976),
	(2478,462,NULL,NULL,'downloadAttachment',977,978),
	(2479,474,NULL,NULL,'downloadAttachment',1007,1008),
	(2480,478,NULL,NULL,'trash',1019,1020),
	(2481,478,NULL,NULL,'history',1021,1022),
	(2482,478,NULL,NULL,'restore',1023,1024),
	(2483,478,NULL,NULL,'downloadAttachment',1025,1026),
	(2484,485,NULL,NULL,'trash',1037,1038),
	(2485,485,NULL,NULL,'history',1039,1040),
	(2486,485,NULL,NULL,'restore',1041,1042),
	(2487,485,NULL,NULL,'downloadAttachment',1043,1044),
	(2488,1,NULL,NULL,'ThirdPartyRiskReviews',1556,1575),
	(2489,2488,NULL,NULL,'listArgs',1557,1558),
	(2490,2488,NULL,NULL,'index',1559,1560),
	(2491,2488,NULL,NULL,'add',1561,1562),
	(2492,2488,NULL,NULL,'edit',1563,1564),
	(2493,2488,NULL,NULL,'delete',1565,1566),
	(2494,2488,NULL,NULL,'trash',1567,1568),
	(2495,2488,NULL,NULL,'history',1569,1570),
	(2496,2488,NULL,NULL,'restore',1571,1572),
	(2497,2488,NULL,NULL,'downloadAttachment',1573,1574),
	(2498,491,NULL,NULL,'trash',1057,1058),
	(2499,491,NULL,NULL,'processClassifications',1059,1060),
	(2500,491,NULL,NULL,'initOptions',1061,1062),
	(2501,491,NULL,NULL,'history',1063,1064),
	(2502,491,NULL,NULL,'restore',1065,1066),
	(2503,491,NULL,NULL,'downloadAttachment',1067,1068),
	(2504,500,NULL,NULL,'edit',1077,1078),
	(2505,500,NULL,NULL,'history',1079,1080),
	(2506,500,NULL,NULL,'restore',1081,1082),
	(2507,500,NULL,NULL,'downloadAttachment',1083,1084),
	(2508,1,NULL,NULL,'UpdateProcess',1576,1581),
	(2509,2508,NULL,NULL,'update',1577,1578),
	(2510,2508,NULL,NULL,'syncAcl',1579,1580),
	(2511,1475,NULL,NULL,'downloadAttachment',1279,1280),
	(2512,1,NULL,NULL,'UserSystemLogs',1582,1587),
	(2513,2512,NULL,NULL,'index',1583,1584),
	(2514,2512,NULL,NULL,'downloadAttachment',1585,1586),
	(2515,506,NULL,NULL,'changeDefaultPassword',1111,1112),
	(2516,506,NULL,NULL,'checkConflicts',1113,1114),
	(2517,506,NULL,NULL,'downloadAttachment',1115,1116),
	(2518,518,NULL,NULL,'edit',1127,1128),
	(2519,518,NULL,NULL,'history',1129,1130),
	(2520,518,NULL,NULL,'restore',1131,1132),
	(2521,518,NULL,NULL,'downloadAttachment',1133,1134),
	(2567,1125,NULL,NULL,'downloadAttachment',1186,1187),
	(2568,1130,NULL,NULL,'downloadAttachment',1200,1201),
	(2569,1138,NULL,NULL,'downloadAttachment',1238,1239),
	(2570,1,NULL,NULL,'AclExtras',1588,1589),
	(2571,1,NULL,NULL,'AdvancedFilters',1590,1617),
	(2572,2571,NULL,NULL,'AdvancedFilterUserParams',1591,1596),
	(2573,2572,NULL,NULL,'save',1592,1593),
	(2574,2572,NULL,NULL,'downloadAttachment',1594,1595),
	(2575,2571,NULL,NULL,'AdvancedFilters',1597,1616),
	(2576,2575,NULL,NULL,'add',1598,1599),
	(2577,2575,NULL,NULL,'edit',1600,1601),
	(2578,2575,NULL,NULL,'delete',1602,1603),
	(2580,2575,NULL,NULL,'redirectAdvancedFilter',1604,1605),
	(2584,2575,NULL,NULL,'exportCsvAll',1606,1607),
	(2586,2575,NULL,NULL,'exportDailyCountResults',1608,1609),
	(2587,2575,NULL,NULL,'exportDailyDataResults',1610,1611),
	(2588,2575,NULL,NULL,'downloadAttachment',1612,1613),
	(2589,1,NULL,NULL,'AdvancedQuery',1618,1619),
	(2590,1,NULL,NULL,'AppNotification',1620,1627),
	(2591,1,NULL,NULL,'AssociativeDelete',1628,1629),
	(2592,32,NULL,NULL,'Attachments',81,94),
	(2593,2592,NULL,NULL,'index',82,83),
	(2594,2592,NULL,NULL,'indexTmp',84,85),
	(2595,2592,NULL,NULL,'add',86,87),
	(2596,2592,NULL,NULL,'addTmp',88,89),
	(2597,2592,NULL,NULL,'delete',90,91),
	(2598,2592,NULL,NULL,'downloadAttachment',92,93),
	(2599,1,NULL,NULL,'AuditLog',1630,1631),
	(2600,1,NULL,NULL,'AutoComplete',1632,1633),
	(2601,2047,NULL,NULL,'prepareFiles',102,103),
	(2602,2047,NULL,NULL,'downloadFile',104,105),
	(2603,2047,NULL,NULL,'downloadAttachment',106,107),
	(2604,1,NULL,NULL,'BruteForce',1634,1635),
	(2605,2061,NULL,NULL,'downloadAttachment',1326,1327),
	(2606,1,NULL,NULL,'CakePdf',1636,1637),
	(2607,119,NULL,NULL,'Comments',235,244),
	(2608,2607,NULL,NULL,'index',236,237),
	(2609,2607,NULL,NULL,'add',238,239),
	(2610,2607,NULL,NULL,'delete',240,241),
	(2611,2607,NULL,NULL,'downloadAttachment',242,243),
	(2612,1,NULL,NULL,'ConcurrentEdit',1638,1645),
	(2613,2612,NULL,NULL,'ConcurrentEdit',1639,1644),
	(2614,2613,NULL,NULL,'echo',1640,1641),
	(2615,2613,NULL,NULL,'downloadAttachment',1642,1643),
	(2616,191,NULL,NULL,'Cron',327,336),
	(2617,2616,NULL,NULL,'task',328,329),
	(2618,2616,NULL,NULL,'job',330,331),
	(2619,2616,NULL,NULL,'index',332,333),
	(2621,2616,NULL,NULL,'downloadAttachment',334,335),
	(2622,1,NULL,NULL,'Crud',1646,1647),
	(2623,1,NULL,NULL,'CsvView',1648,1649),
	(2627,1,NULL,NULL,'CustomRoles',1650,1651),
	(2628,1,NULL,NULL,'CustomValidator',1652,1659),
	(2629,2628,NULL,NULL,'CustomValidator',1653,1658),
	(2630,2629,NULL,NULL,'setup',1654,1655),
	(2631,2629,NULL,NULL,'downloadAttachment',1656,1657),
	(2632,1,NULL,NULL,'Dashboard',1660,1693),
	(2633,2632,NULL,NULL,'DashboardCalendarEvents',1661,1666),
	(2634,2633,NULL,NULL,'index',1662,1663),
	(2635,2633,NULL,NULL,'downloadAttachment',1664,1665),
	(2636,2632,NULL,NULL,'DashboardKpis',1667,1692),
	(2637,2636,NULL,NULL,'store_logs',1668,1669),
	(2638,2636,NULL,NULL,'recalculate_values',1670,1671),
	(2639,2636,NULL,NULL,'export_values',1672,1673),
	(2640,2636,NULL,NULL,'export_logs',1674,1675),
	(2641,2636,NULL,NULL,'user',1676,1677),
	(2642,2636,NULL,NULL,'admin',1678,1679),
	(2643,2636,NULL,NULL,'add',1680,1681),
	(2644,2636,NULL,NULL,'edit',1682,1683),
	(2645,2636,NULL,NULL,'thresholdItem',1684,1685),
	(2646,2636,NULL,NULL,'delete',1686,1687),
	(2647,2636,NULL,NULL,'sync',1688,1689),
	(2648,2636,NULL,NULL,'downloadAttachment',1690,1691),
	(2649,1159,NULL,NULL,'downloadAttachment',1248,1249),
	(2650,1,NULL,NULL,'EventManager',1694,1695),
	(2651,1,NULL,NULL,'FieldData',1696,1697),
	(2652,1,NULL,NULL,'HtmlPurifier',1698,1699),
	(2653,1563,NULL,NULL,'upload',1288,1289),
	(2654,1563,NULL,NULL,'downloadAttachment',1290,1291),
	(2655,1,NULL,NULL,'InlineEdit',1700,1701),
	(2656,1,NULL,NULL,'InspectLog',1702,1703),
	(2657,1,NULL,NULL,'ItemData',1704,1705),
	(2658,1,NULL,NULL,'LimitlessTheme',1706,1707),
	(2659,1,NULL,NULL,'Macros',1708,1709),
	(2660,1,NULL,NULL,'Migrations',1710,1711),
	(2661,1,NULL,NULL,'Modals',1712,1713),
	(2662,1,NULL,NULL,'ModuleSettings',1714,1715),
	(2692,1,NULL,NULL,'ObjectRenderer',1716,1717),
	(2693,1,NULL,NULL,'ObjectStatus',1718,1719),
	(2694,2083,NULL,NULL,'downloadAttachment',1336,1337),
	(2695,1,NULL,NULL,'QuickAdd',1720,1721),
	(2743,1,NULL,NULL,'ReviewsPlanner',1722,1743),
	(2744,2743,NULL,NULL,'ReviewsPlanner',1723,1742),
	(2745,2744,NULL,NULL,'listArgs',1724,1725),
	(2746,2744,NULL,NULL,'index',1726,1727),
	(2747,2744,NULL,NULL,'add',1728,1729),
	(2748,2744,NULL,NULL,'edit',1730,1731),
	(2749,2744,NULL,NULL,'delete',1732,1733),
	(2750,2744,NULL,NULL,'trash',1734,1735),
	(2751,2744,NULL,NULL,'history',1736,1737),
	(2752,2744,NULL,NULL,'restore',1738,1739),
	(2753,2744,NULL,NULL,'downloadAttachment',1740,1741),
	(2754,1,NULL,NULL,'Search',1744,1745),
	(2755,1,NULL,NULL,'SystemLogs',1746,1753),
	(2756,2755,NULL,NULL,'SystemLogs',1747,1752),
	(2757,2756,NULL,NULL,'index',1748,1749),
	(2758,2756,NULL,NULL,'downloadAttachment',1750,1751),
	(2759,1,NULL,NULL,'Taggable',1754,1755),
	(2760,1,NULL,NULL,'ThirdPartyAudits',1756,1775),
	(2761,2760,NULL,NULL,'ThirdPartyAudits',1757,1774),
	(2762,2761,NULL,NULL,'login',1758,1759),
	(2763,2761,NULL,NULL,'logout',1760,1761),
	(2764,2761,NULL,NULL,'index',1762,1763),
	(2765,2761,NULL,NULL,'analyze',1764,1765),
	(2766,2761,NULL,NULL,'auditeeFeedbackStats',1766,1767),
	(2767,2761,NULL,NULL,'auditeeFeedback',1768,1769),
	(2768,2761,NULL,NULL,'auditeeExportFindings',1770,1771),
	(2769,2761,NULL,NULL,'downloadAttachment',1772,1773),
	(2770,1,NULL,NULL,'Tooltips',1776,1785),
	(2771,2770,NULL,NULL,'Tooltips',1777,1784),
	(2772,2771,NULL,NULL,'tooltip',1778,1779),
	(2773,2771,NULL,NULL,'saveLog',1780,1781),
	(2774,2771,NULL,NULL,'downloadAttachment',1782,1783),
	(2775,1,NULL,NULL,'Trash',1786,1787),
	(2776,1,NULL,NULL,'Uploader',1788,1789),
	(2777,1,NULL,NULL,'UserFields',1790,1791),
	(2778,1,NULL,NULL,'Utils',1792,1793),
	(2826,1,NULL,NULL,'Visualisation',1794,1817),
	(2827,2826,NULL,NULL,'Visualisation',1795,1806),
	(2828,2827,NULL,NULL,'redirectGateway',1796,1797),
	(2829,2827,NULL,NULL,'share',1798,1799),
	(2830,2827,NULL,NULL,'share_old2',1800,1801),
	(2831,2827,NULL,NULL,'share_old',1802,1803),
	(2832,2827,NULL,NULL,'downloadAttachment',1804,1805),
	(2833,2826,NULL,NULL,'VisualisationSettings',1807,1816),
	(2834,2833,NULL,NULL,'index',1808,1809),
	(2835,2833,NULL,NULL,'edit',1810,1811),
	(2836,2833,NULL,NULL,'sync',1812,1813),
	(2837,2833,NULL,NULL,'downloadAttachment',1814,1815),
	(2838,1,NULL,NULL,'Widget',1818,1827),
	(2839,2838,NULL,NULL,'Widget',1819,1826),
	(2840,2839,NULL,NULL,'index',1820,1821),
	(2841,2839,NULL,NULL,'downloadAttachment',1822,1823),
	(2842,524,NULL,NULL,'WorkflowInstances',1137,1146),
	(2843,2842,NULL,NULL,'manage',1138,1139),
	(2844,2842,NULL,NULL,'handleRequest',1140,1141),
	(2845,2842,NULL,NULL,'forceStageForm',1142,1143),
	(2846,2842,NULL,NULL,'downloadAttachment',1144,1145),
	(2847,524,NULL,NULL,'WorkflowSettings',1147,1152),
	(2848,2847,NULL,NULL,'edit',1148,1149),
	(2849,2847,NULL,NULL,'downloadAttachment',1150,1151),
	(2850,524,NULL,NULL,'WorkflowStageSteps',1153,1166),
	(2851,2850,NULL,NULL,'delete',1154,1155),
	(2852,2850,NULL,NULL,'add',1156,1157),
	(2853,2850,NULL,NULL,'edit',1158,1159),
	(2854,2850,NULL,NULL,'addCondition',1160,1161),
	(2855,2850,NULL,NULL,'addConditionValue',1162,1163),
	(2856,2850,NULL,NULL,'downloadAttachment',1164,1165),
	(2857,524,NULL,NULL,'WorkflowStages',1167,1178),
	(2858,2857,NULL,NULL,'index',1168,1169),
	(2859,2857,NULL,NULL,'delete',1170,1171),
	(2860,2857,NULL,NULL,'add',1172,1173),
	(2861,2857,NULL,NULL,'edit',1174,1175),
	(2862,2857,NULL,NULL,'downloadAttachment',1176,1177),
	(2863,1,NULL,NULL,'YoonityJSConnector',1828,1829),
	(2864,2144,'VendorAssessmentFeedback',NULL,'VendorAssessmentFeedback::',1994,1995),
	(2865,438,NULL,NULL,'getRecurrenceDatesCount',909,910),
	(2866,506,NULL,NULL,'prepareAccount',1117,1118),
	(2867,2575,NULL,NULL,'exportCsvAllQuery',1614,1615),
	(2868,1,NULL,NULL,'CustomLabels',1830,1837),
	(2869,2868,NULL,NULL,'CustomLabels',1831,1836),
	(2870,2869,NULL,NULL,'edit',1832,1833),
	(2871,2869,NULL,NULL,'downloadAttachment',1834,1835),
	(2872,1,NULL,NULL,'LdapSync',1838,1859),
	(2873,2872,NULL,NULL,'LdapSynchronizationSystemLogs',1839,1844),
	(2874,2873,NULL,NULL,'index',1840,1841),
	(2875,2873,NULL,NULL,'downloadAttachment',1842,1843),
	(2876,2872,NULL,NULL,'LdapSynchronizations',1845,1858),
	(2877,2876,NULL,NULL,'add',1846,1847),
	(2878,2876,NULL,NULL,'edit',1848,1849),
	(2879,2876,NULL,NULL,'delete',1850,1851),
	(2880,2876,NULL,NULL,'forceSync',1852,1853),
	(2881,2876,NULL,NULL,'simulateSync',1854,1855),
	(2882,2876,NULL,NULL,'downloadAttachment',1856,1857),
	(2883,1,NULL,NULL,'Translations',1860,1877),
	(2884,2883,NULL,NULL,'Translations',1861,1876),
	(2885,2884,NULL,NULL,'index',1862,1863),
	(2886,2884,NULL,NULL,'add',1864,1865),
	(2887,2884,NULL,NULL,'edit',1866,1867),
	(2888,2884,NULL,NULL,'delete',1868,1869),
	(2889,2884,NULL,NULL,'downloadTemplate',1870,1871),
	(2890,2884,NULL,NULL,'download',1872,1873),
	(2891,2884,NULL,NULL,'downloadAttachment',1874,1875),
	(2905,2105,'User',NULL,'User::',2013,2014),
	(2906,2106,'User',1,'User::1',2017,2018),
	(2907,1,NULL,NULL,'SamlConnectors',1878,1895),
	(2908,2907,NULL,NULL,'index',1879,1880),
	(2909,2907,NULL,NULL,'add',1881,1882),
	(2910,2907,NULL,NULL,'edit',1883,1884),
	(2911,2907,NULL,NULL,'delete',1885,1886),
	(2912,2907,NULL,NULL,'getMetadata',1887,1888),
	(2913,2907,NULL,NULL,'singleSingOn',1889,1890),
	(2914,2907,NULL,NULL,'singleLogout',1891,1892),
	(2915,2907,NULL,NULL,'downloadAttachment',1893,1894),
	(2916,462,NULL,NULL,'backup',979,980),
	(2917,462,NULL,NULL,'debug',981,982),
	(2918,462,NULL,NULL,'currency',983,984),
	(2919,462,NULL,NULL,'timezone',985,986),
	(2920,462,NULL,NULL,'csv',987,988),
	(2921,462,NULL,NULL,'email',989,990),
	(2922,462,NULL,NULL,'bruteForceProtection',991,992),
	(2923,462,NULL,NULL,'sslOffload',993,994),
	(2924,462,NULL,NULL,'enterpriseUser',995,996),
	(2925,462,NULL,NULL,'crontab',997,998),
	(2926,462,NULL,NULL,'pdf',999,1000),
	(2927,2590,NULL,NULL,'AppNotifications',1621,1626),
	(2928,2927,NULL,NULL,'list',1622,1623),
	(2929,2927,NULL,NULL,'downloadAttachment',1624,1625),
	(2930,1303,NULL,NULL,'News',1253,1258),
	(2931,2930,NULL,NULL,'view',1254,1255),
	(2932,2930,NULL,NULL,'downloadAttachment',1256,1257),
	(2933,1,NULL,NULL,'SectionInfo',1896,1903),
	(2934,2933,NULL,NULL,'SectionInfo',1897,1902),
	(2935,2934,NULL,NULL,'info',1898,1899),
	(2936,2934,NULL,NULL,'downloadAttachment',1900,1901),
	(2937,2839,NULL,NULL,'story',1824,1825);
ALTER TABLE `acos` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `advanced_filters` WRITE;
ALTER TABLE `advanced_filters` DISABLE KEYS;
INSERT INTO `advanced_filters` (`id`, `user_id`, `name`, `slug`, `description`, `model`, `private`, `log_result_count`, `log_result_data`, `system_filter`, `deleted`, `deleted_date`, `created`, `modified`) VALUES 
	(742,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','Legal',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(743,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','Legal',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(744,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','Legal',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(745,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','Legal',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(746,1,'All Items','all-items','Filter that shows everything','Legal',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(747,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','ThirdParty',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(748,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','ThirdParty',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(749,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','ThirdParty',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(750,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','ThirdParty',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(751,1,'All Items','all-items','Filter that shows everything','ThirdParty',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(752,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','SecurityService',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(753,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','SecurityService',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(754,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','SecurityService',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(755,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','SecurityService',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(756,1,'All Items','all-items','Filter that shows everything','SecurityService',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(757,1,'Controls with Issues','with-issues','This filter shows controls which currently have one or more ongoing issue','SecurityService',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(758,1,'Controls with Missing Audits','missing-audits','This filter shows controls which currently miss one or more audits','SecurityService',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(759,1,'Controls with Missing Maintenances','missing-maintenances','This filter shows controls which currently miss one or more Maintenances','SecurityService',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(760,1,'Controls with Failed Maintenances','failed-maintenances','This filter shows controls which currently have failed Maintenances','SecurityService',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(761,1,'Controls with Failed Audits','failed-audits','This filter shows controls which currently have failed Audits','SecurityService',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(762,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','SecurityServiceAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(763,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','SecurityServiceAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(764,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','SecurityServiceAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(765,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','SecurityServiceAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(766,1,'All Items','all-items','Filter that shows everything','SecurityServiceAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(767,1,'Audits due in 14 Days','due-in-14-days','This is the list of audits due in the coming 14 Days','SecurityServiceAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(768,1,'Expired Audits','expired','This filter shows all expired audits','SecurityServiceAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(769,1,'Failed Audits','failed','This filter shows all audits which have failed','SecurityServiceAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(770,1,'Pass Audits','pass','This filter shows all audits which have passed','SecurityServiceAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(771,1,'Completed Audits','completed','This filter shows all completed (Fail and Pass) audits','SecurityServiceAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(772,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','SecurityServiceMaintenance',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(773,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','SecurityServiceMaintenance',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(774,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','SecurityServiceMaintenance',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(775,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','SecurityServiceMaintenance',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(776,1,'All Items','all-items','Filter that shows everything','SecurityServiceMaintenance',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(777,1,'Maintenances due in 14 Days','due-in-14-audits','This is the list of maintenances due in the coming 14 Days','SecurityServiceMaintenance',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(778,1,'Expired Maintenances','expired','This filter shows all expired mantainances','SecurityServiceMaintenance',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(779,1,'Failed Maintenances','failed','This filter shows all mantainances which have failed','SecurityServiceMaintenance',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(780,1,'Pass Maintenances','pass','This filter shows all mantainances which have passed','SecurityServiceMaintenance',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(781,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','SecurityPolicy',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(782,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','SecurityPolicy',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(783,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','SecurityPolicy',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(784,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','SecurityPolicy',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(785,1,'All Items','all-items','Filter that shows everything','SecurityPolicy',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(786,1,'Policies with Missing Reviews','missing-reviews','This filter shows all policies that are published and currently miss one or more reviews','SecurityPolicy',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(787,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','SecurityPolicyReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(788,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','SecurityPolicyReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(789,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','SecurityPolicyReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(790,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','SecurityPolicyReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(791,1,'All Items','all-items','Filter that shows everything','SecurityPolicyReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(792,1,'Security Policy Reviews due in 14 Days','due-in-14-days','This is the list of reviews due in the coming 14 Days','SecurityPolicyReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(793,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','Risk',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(794,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','Risk',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(795,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','Risk',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(796,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','Risk',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(797,1,'All Items','all-items','Filter that shows everything','Risk',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(798,1,'Risk with Expired Reviews','expired-reviews','Lists of risks with expired reviews','Risk',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(799,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','Asset',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(800,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','Asset',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(801,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','Asset',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(802,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','Asset',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(803,1,'All Items','all-items','Filter that shows everything','Asset',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(804,1,'Assets with Missing Reviews','missing-reviews','This filter shows all assets that are published and currently miss one or more reviews','Asset',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(805,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','AssetReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(806,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','AssetReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(807,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','AssetReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(808,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','AssetReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(809,1,'All Items','all-items','Filter that shows everything','AssetReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(810,1,'Asset Reviews due in 14 Days','due-in-14-days','This is the list of reviews due in the coming 14 Days','AssetReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(811,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','RiskReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(812,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','RiskReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(813,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','RiskReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(814,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','RiskReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(815,1,'All Items','all-items','Filter that shows everything','RiskReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(816,1,'Risk Reviews due in 14 Days','due-in-14-days','This is the list of reviews due in the coming 14 Days','RiskReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(817,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','ThirdPartyRiskReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(818,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','ThirdPartyRiskReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(819,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','ThirdPartyRiskReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(820,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','ThirdPartyRiskReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(821,1,'All Items','all-items','Filter that shows everything','ThirdPartyRiskReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(822,1,'Risk Reviews due in 14 Days','due-in-14-days','This is the list of reviews due in the coming 14 Days','ThirdPartyRiskReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(823,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','BusinessContinuityReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(824,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','BusinessContinuityReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(825,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','BusinessContinuityReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(826,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','BusinessContinuityReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(827,1,'All Items','all-items','Filter that shows everything','BusinessContinuityReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(828,1,'Risk Reviews due in 14 Days','due-in-14-days','This is the list of reviews due in the coming 14 Days','BusinessContinuityReview',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(829,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','ThirdPartyRisk',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(830,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','ThirdPartyRisk',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(831,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','ThirdPartyRisk',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(832,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','ThirdPartyRisk',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(833,1,'All Items','all-items','Filter that shows everything','ThirdPartyRisk',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(834,1,'Risk with Expired Reviews','expired-reviews','Lists of risks with expired reviews','ThirdPartyRisk',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(835,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','BusinessContinuity',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(836,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','BusinessContinuity',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(837,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','BusinessContinuity',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(838,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','BusinessContinuity',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(839,1,'All Items','all-items','Filter that shows everything','BusinessContinuity',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(840,1,'Risk with Expired Reviews','expired-reviews','Lists of risks with expired reviews','BusinessContinuity',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(841,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','BusinessUnit',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(842,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','BusinessUnit',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(843,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','BusinessUnit',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(844,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','BusinessUnit',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(845,1,'All Items','all-items','Filter that shows everything','BusinessUnit',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(846,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','Process',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(847,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','Process',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(848,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','Process',1,0,0,1,0,NULL,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(849,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','Process',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(850,1,'All Items','all-items','Filter that shows everything','Process',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(851,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','ServiceContract',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(852,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','ServiceContract',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(853,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','ServiceContract',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(854,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','ServiceContract',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(855,1,'All Items','all-items','Filter that shows everything','ServiceContract',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(856,1,'Contracts due in the next 14 Days','due-in-14-days','This is the list of contracts that expire in the next couple of weeks','ServiceContract',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(857,1,'Expired Contracts','expired','This is the list of contracts that have an end date in the past','ServiceContract',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(858,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','RiskException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(859,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','RiskException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(860,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','RiskException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(861,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','RiskException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(862,1,'All Items','all-items','Filter that shows everything','RiskException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(863,1,'Exceptions due in the next 14 days','due-in-14-days','This is the list of exceptions expiring in the next 14 days','RiskException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(864,1,'Expired Exceptions','expired','This is the list of exceptions which have already expired','RiskException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(865,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','PolicyException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(866,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','PolicyException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(867,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','PolicyException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(868,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','PolicyException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(869,1,'All Items','all-items','Filter that shows everything','PolicyException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(870,1,'Exceptions due in the next 14 days','due-in-14-days','This is the list of exceptions expiring in the next 14 days','PolicyException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(871,1,'Expired Exceptions','expired','This is the list of exceptions which have already expired','PolicyException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(872,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','Project',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(873,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','Project',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(874,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','Project',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(875,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','Project',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(876,1,'All Items','all-items','Filter that shows everything','Project',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(877,1,'Projects with Expired Tasks','expired-task','This is the list of projects that are ongoing and contain one or more expired tasks','Project',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(878,1,'Expired Projects','expired','This is the list of projects that are ongoing and contain a due date in the past','Project',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(879,1,'Projects without updates in the last two weeks','no-updates','This is the list of ongoing projects that have not been updated in the last couple of weeks','Project',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(880,1,'Ongoing Projects','ongoing-projects','This is the list of ongoing projects','Project',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(881,1,'Closed Projects','completed','This is the list of closed projects','Project',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(882,1,'Planned Projects','planned','This is the list of planned projects','Project',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(883,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','ProjectAchievement',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(884,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','ProjectAchievement',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(885,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','ProjectAchievement',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(886,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','ProjectAchievement',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(887,1,'All Items','all-items','Filter that shows everything','ProjectAchievement',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(888,1,'Pending Tasks','pending','Tasks which are not 100% completed','ProjectAchievement',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(889,1,'Expired Tasks','expired','Tasks which have a deadline set in the past','ProjectAchievement',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(890,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','ProjectExpense',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(891,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','ProjectExpense',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(892,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','ProjectExpense',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(893,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','ProjectExpense',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(894,1,'All Items','all-items','Filter that shows everything','ProjectExpense',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(895,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','SecurityServiceIssue',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(896,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','SecurityServiceIssue',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(897,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','SecurityServiceIssue',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(898,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','SecurityServiceIssue',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(899,1,'All Items','all-items','Filter that shows everything','SecurityServiceIssue',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(900,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','ProgramScope',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(901,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','ProgramScope',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(902,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','ProgramScope',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(903,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','ProgramScope',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(904,1,'All Items','all-items','Filter that shows everything','ProgramScope',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(905,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','ProgramIssue',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(906,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','ProgramIssue',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(907,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','ProgramIssue',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(908,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','ProgramIssue',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(909,1,'All Items','all-items','Filter that shows everything','ProgramIssue',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(910,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','TeamRole',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(911,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','TeamRole',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(912,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','TeamRole',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(913,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','TeamRole',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(914,1,'All Items','all-items','Filter that shows everything','TeamRole',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(915,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','ComplianceException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(916,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','ComplianceException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(917,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','ComplianceException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(918,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','ComplianceException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(919,1,'All Items','all-items','Filter that shows everything','ComplianceException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(920,1,'Exceptions due in the next 14 days','due-in-14-days','This is the list of exceptions expiring in the next 14 days','ComplianceException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(921,1,'Expired Exceptions','expired','This is the list of exceptions which have already expired','ComplianceException',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(922,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','CompliancePackageRegulator',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(923,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','CompliancePackageRegulator',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(924,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','CompliancePackageRegulator',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(925,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','CompliancePackageRegulator',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(926,1,'All Items','all-items','Filter that shows everything','CompliancePackageRegulator',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(927,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','CompliancePackage',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(928,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','CompliancePackage',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(929,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','CompliancePackage',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(930,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','CompliancePackage',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(931,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','ComplianceManagement',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(932,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','ComplianceManagement',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(933,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','ComplianceManagement',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(934,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','ComplianceManagement',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(935,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','ComplianceAnalysisFinding',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(936,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','ComplianceAnalysisFinding',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(937,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','ComplianceAnalysisFinding',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(938,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','ComplianceAnalysisFinding',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(939,1,'All Items','all-items','Filter that shows everything','ComplianceAnalysisFinding',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(940,1,'Compliance Findings due in 14 Days','due-in-14-days','This is the list of compliance findings due in the next 14 days','ComplianceAnalysisFinding',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(941,1,'Expired Compliance Findings','expired','This is the list of compliance analysis findings that have a due date in the past and are still open','ComplianceAnalysisFinding',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(942,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','Goal',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(943,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','Goal',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(944,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','Goal',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(945,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','Goal',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(946,1,'All Items','all-items','Filter that shows everything','Goal',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(947,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','GoalAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(948,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','GoalAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(949,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','GoalAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(950,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','GoalAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(951,1,'All Items','all-items','Filter that shows everything','GoalAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(952,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','SecurityIncident',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(953,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','SecurityIncident',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(954,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','SecurityIncident',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(955,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','SecurityIncident',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(956,1,'All Items','all-items','Filter that shows everything','SecurityIncident',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(957,1,'Ongoing Incidents','ongoing','This is the list of all ongoing incidents','SecurityIncident',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(958,1,'Closed Incidents','closed','This is the list of all closed incidents','SecurityIncident',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(959,1,'Incidents with missing analysis','missing-analysis','This is the list of all ongoing incidents that have one or more incomplete analysis','SecurityIncident',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(960,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','SecurityIncidentStagesSecurityIncident',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(961,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','SecurityIncidentStagesSecurityIncident',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(962,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','SecurityIncidentStagesSecurityIncident',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(963,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','SecurityIncidentStagesSecurityIncident',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(964,1,'All Items','all-items','Filter that shows everything','SecurityIncidentStagesSecurityIncident',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(965,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','BusinessContinuityPlan',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(966,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','BusinessContinuityPlan',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(967,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','BusinessContinuityPlan',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(968,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','BusinessContinuityPlan',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(969,1,'All Items','all-items','Filter that shows everything','BusinessContinuityPlan',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(970,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','BusinessContinuityPlanAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(971,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','BusinessContinuityPlanAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(972,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','BusinessContinuityPlanAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(973,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','BusinessContinuityPlanAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(974,1,'All Items','all-items','Filter that shows everything','BusinessContinuityPlanAudit',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(975,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','BusinessContinuityTask',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(976,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','BusinessContinuityTask',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(977,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','BusinessContinuityTask',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(978,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','BusinessContinuityTask',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(979,1,'All Items','all-items','Filter that shows everything','BusinessContinuityTask',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(980,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','User',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(981,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','User',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(982,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','User',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(983,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','User',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(984,1,'All Items','all-items','Filter that shows everything','User',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(985,1,'All Items','all-items','Filter that shows everything','UserSystemLog',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(986,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','Group',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(987,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','Group',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(988,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','Group',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(989,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','Group',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(990,1,'All Items','all-items','Filter that shows everything','Group',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(991,1,'Sent Emails','sent-emails','Filter shows sent emails','Queue',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(992,1,'Pending Emails','pending-emails','Filter show emails still pending to be sent','Queue',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(993,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','Cron',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(994,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','Cron',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(995,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','Cron',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(996,1,'All Items','all-items','Filter that shows everything','Cron',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(997,1,'Failed CRONs','open','This filter shows CRONs with error','Cron',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(998,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','OauthConnector',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(999,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','OauthConnector',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1000,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','OauthConnector',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1001,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','OauthConnector',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1002,1,'All Items','all-items','Filter that shows everything','OauthConnector',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1003,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','LdapConnector',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1004,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','LdapConnector',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1005,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','LdapConnector',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1006,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','LdapConnector',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1007,1,'All Items','all-items','Filter that shows everything','LdapConnector',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1008,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','DataAsset',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1009,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','DataAsset',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1010,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','DataAsset',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1011,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','DataAsset',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1012,1,'All Items','all-items','Filter that shows everything','DataAsset',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1013,1,'Collected Stage Flows','status-1','This filter shows all flows that are assigned to the "Collected" stage','DataAsset',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1014,1,'Modified Stage Flows','status-2','This filter shows all flows that are assigned to the "Modified" stage','DataAsset',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1015,1,'Stored Stage Flows','status-3','This filter shows all flows that are assigned to the "Stored" stage','DataAsset',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1016,1,'Transit Stage Flows','status-4','This filter shows all flows that are assigned to the "Transit" stage','DataAsset',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1017,1,'Deleted Stage Flows','status-5','This filter shows all flows that are assigned to the "Deleted" stage','DataAsset',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1018,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','DataAssetInstance',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1019,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','DataAssetInstance',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1020,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','DataAssetInstance',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1021,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','DataAssetInstance',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1022,1,'All Items','all-items','Filter that shows everything','DataAssetInstance',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1023,1,'GDPR Scope Assets','gdpr-enabled','This is the list of all assets in the scope of GDPR','DataAssetInstance',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1024,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','AwarenessProgram',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1025,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','AwarenessProgram',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1026,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','AwarenessProgram',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1027,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','AwarenessProgram',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1028,1,'All Items','all-items','Filter that shows everything','AwarenessProgram',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1029,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','AwarenessProgramActiveUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1030,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','AwarenessProgramActiveUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1031,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','AwarenessProgramActiveUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1032,1,'All Items','all-items','Lists all participants for awareness trainings which are currently started','AwarenessProgramActiveUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1033,1,'Last Modified','last-modified','Filter that shows last 10 modified items','AwarenessProgramActiveUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1034,1,'Last Created','last-created','Filter that shows last 10 created items','AwarenessProgramActiveUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1035,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','AwarenessProgramIgnoredUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1036,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','AwarenessProgramIgnoredUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1037,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','AwarenessProgramIgnoredUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1038,1,'All Items','all-items','Lists all ignored participants for awareness trainings which are currently started','AwarenessProgramIgnoredUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1039,1,'Last Modified','last-modified','Filter that shows last 10 modified items','AwarenessProgramIgnoredUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1040,1,'Last Created','last-created','Filter that shows last 10 created items','AwarenessProgramIgnoredUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1041,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','AwarenessProgramCompliantUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1042,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','AwarenessProgramCompliantUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1043,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','AwarenessProgramCompliantUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1044,1,'All Items','all-items','Lists all compliant participants for awareness trainings which are currently started','AwarenessProgramCompliantUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1045,1,'Last Modified','last-modified','Filter that shows last 10 modified items','AwarenessProgramCompliantUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1046,1,'Last Created','last-created','Filter that shows last 10 created items','AwarenessProgramCompliantUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1047,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','AwarenessProgramNotCompliantUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1048,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','AwarenessProgramNotCompliantUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1049,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','AwarenessProgramNotCompliantUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1050,1,'All Items','all-items','Lists all non-compliant participants for awareness trainings which are currently started','AwarenessProgramNotCompliantUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1051,1,'Last Modified','last-modified','Filter that shows last 10 modified items','AwarenessProgramNotCompliantUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1052,1,'Last Created','last-created','Filter that shows last 10 created items','AwarenessProgramNotCompliantUser',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1053,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','AwarenessReminder',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1054,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','AwarenessReminder',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1055,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','AwarenessReminder',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1056,1,'All Items','all-items','Filter that shows everything','AwarenessReminder',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1057,1,'Last Modified','last-modified','Filter that shows last 10 modified items','AwarenessReminder',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1058,1,'Last Created','last-created','Filter that shows last 10 created items','AwarenessReminder',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1059,1,'All Items','all-items','Filter that shows everything','LdapSynchronizationSystemLog',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1060,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','Translation',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1061,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','Translation',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1062,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','Translation',1,0,0,1,0,NULL,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1063,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','Translation',1,0,0,1,0,NULL,'2019-10-18 16:27:37','2019-10-18 16:27:37'),
	(1064,1,'All Items','all-items','Filter that shows everything','Translation',1,0,0,1,0,NULL,'2019-10-18 16:27:37','2019-10-18 16:27:37'),
	(1065,1,'Items with new comments (Since Yesterday)','new-comment','This is the list of items that have received comments since yesterday','SamlConnector',1,0,0,1,0,NULL,'2019-10-18 16:27:37','2019-10-18 16:27:37'),
	(1066,1,'Items with new attachments (Since Yesterday)','new-attachment','This is the list of items that have received attachments since yesterday','SamlConnector',1,0,0,1,0,NULL,'2019-10-18 16:27:37','2019-10-18 16:27:37'),
	(1067,1,'Updated items (Since Yesterday)','modified-items','This is the list of items that received updates yesterday','SamlConnector',1,0,0,1,0,NULL,'2019-10-18 16:27:37','2019-10-18 16:27:37'),
	(1068,1,'New items (Since Yesterday)','created-items','This is the list of new items since yesterday','SamlConnector',1,0,0,1,0,NULL,'2019-10-18 16:27:37','2019-10-18 16:27:37'),
	(1069,1,'All Items','all-items','Filter that shows everything','SamlConnector',1,0,0,1,0,NULL,'2019-10-18 16:27:37','2019-10-18 16:27:37');
ALTER TABLE `advanced_filters` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `advanced_filter_crons` WRITE;
ALTER TABLE `advanced_filter_crons` DISABLE KEYS;
ALTER TABLE `advanced_filter_crons` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `advanced_filter_cron_result_items` WRITE;
ALTER TABLE `advanced_filter_cron_result_items` DISABLE KEYS;
ALTER TABLE `advanced_filter_cron_result_items` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `advanced_filter_user_params` WRITE;
ALTER TABLE `advanced_filter_user_params` DISABLE KEYS;
ALTER TABLE `advanced_filter_user_params` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `advanced_filter_user_settings` WRITE;
ALTER TABLE `advanced_filter_user_settings` DISABLE KEYS;
INSERT INTO `advanced_filter_user_settings` (`id`, `advanced_filter_id`, `user_id`, `default_index`, `limit`, `created`, `modified`) VALUES 
	(742,742,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(743,743,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(744,744,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(745,745,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(746,746,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(747,747,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(748,748,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(749,749,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(750,750,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(751,751,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(752,752,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(753,753,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(754,754,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(755,755,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(756,756,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(757,757,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(758,758,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(759,759,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(760,760,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(761,761,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(762,762,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(763,763,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(764,764,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(765,765,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(766,766,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(767,767,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(768,768,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(769,769,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(770,770,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(771,771,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(772,772,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(773,773,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(774,774,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(775,775,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(776,776,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(777,777,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(778,778,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(779,779,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(780,780,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(781,781,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(782,782,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(783,783,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(784,784,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(785,785,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(786,786,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(787,787,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(788,788,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(789,789,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(790,790,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(791,791,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(792,792,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(793,793,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(794,794,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(795,795,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(796,796,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(797,797,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(798,798,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(799,799,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(800,800,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(801,801,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(802,802,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(803,803,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(804,804,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(805,805,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(806,806,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(807,807,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(808,808,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(809,809,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(810,810,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(811,811,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(812,812,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(813,813,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(814,814,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(815,815,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(816,816,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(817,817,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(818,818,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(819,819,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(820,820,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(821,821,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(822,822,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(823,823,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(824,824,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(825,825,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(826,826,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(827,827,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(828,828,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(829,829,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(830,830,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(831,831,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(832,832,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(833,833,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(834,834,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(835,835,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(836,836,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(837,837,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(838,838,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(839,839,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(840,840,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(841,841,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(842,842,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(843,843,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(844,844,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(845,845,1,1,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(846,846,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(847,847,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(848,848,1,0,10,'2019-10-18 16:27:35','2019-10-18 16:27:35'),
	(849,849,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(850,850,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(851,851,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(852,852,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(853,853,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(854,854,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(855,855,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(856,856,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(857,857,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(858,858,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(859,859,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(860,860,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(861,861,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(862,862,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(863,863,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(864,864,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(865,865,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(866,866,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(867,867,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(868,868,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(869,869,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(870,870,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(871,871,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(872,872,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(873,873,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(874,874,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(875,875,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(876,876,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(877,877,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(878,878,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(879,879,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(880,880,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(881,881,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(882,882,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(883,883,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(884,884,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(885,885,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(886,886,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(887,887,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(888,888,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(889,889,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(890,890,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(891,891,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(892,892,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(893,893,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(894,894,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(895,895,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(896,896,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(897,897,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(898,898,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(899,899,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(900,900,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(901,901,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(902,902,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(903,903,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(904,904,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(905,905,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(906,906,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(907,907,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(908,908,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(909,909,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(910,910,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(911,911,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(912,912,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(913,913,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(914,914,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(915,915,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(916,916,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(917,917,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(918,918,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(919,919,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(920,920,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(921,921,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(922,922,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(923,923,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(924,924,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(925,925,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(926,926,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(927,927,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(928,928,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(929,929,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(930,930,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(931,931,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(932,932,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(933,933,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(934,934,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(935,935,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(936,936,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(937,937,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(938,938,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(939,939,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(940,940,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(941,941,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(942,942,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(943,943,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(944,944,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(945,945,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(946,946,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(947,947,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(948,948,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(949,949,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(950,950,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(951,951,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(952,952,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(953,953,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(954,954,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(955,955,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(956,956,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(957,957,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(958,958,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(959,959,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(960,960,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(961,961,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(962,962,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(963,963,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(964,964,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(965,965,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(966,966,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(967,967,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(968,968,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(969,969,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(970,970,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(971,971,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(972,972,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(973,973,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(974,974,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(975,975,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(976,976,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(977,977,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(978,978,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(979,979,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(980,980,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(981,981,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(982,982,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(983,983,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(984,984,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(985,985,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(986,986,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(987,987,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(988,988,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(989,989,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(990,990,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(991,991,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(992,992,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(993,993,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(994,994,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(995,995,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(996,996,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(997,997,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(998,998,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(999,999,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1000,1000,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1001,1001,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1002,1002,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1003,1003,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1004,1004,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1005,1005,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1006,1006,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1007,1007,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1008,1008,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1009,1009,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1010,1010,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1011,1011,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1012,1012,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1013,1013,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1014,1014,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1015,1015,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1016,1016,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1017,1017,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1018,1018,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1019,1019,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1020,1020,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1021,1021,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1022,1022,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1023,1023,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1024,1024,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1025,1025,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1026,1026,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1027,1027,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1028,1028,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1029,1029,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1030,1030,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1031,1031,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1032,1032,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1033,1033,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1034,1034,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1035,1035,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1036,1036,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1037,1037,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1038,1038,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1039,1039,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1040,1040,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1041,1041,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1042,1042,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1043,1043,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1044,1044,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1045,1045,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1046,1046,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1047,1047,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1048,1048,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1049,1049,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1050,1050,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1051,1051,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1052,1052,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1053,1053,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1054,1054,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1055,1055,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1056,1056,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1057,1057,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1058,1058,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1059,1059,1,1,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1060,1060,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1061,1061,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1062,1062,1,0,10,'2019-10-18 16:27:36','2019-10-18 16:27:36'),
	(1063,1063,1,0,10,'2019-10-18 16:27:37','2019-10-18 16:27:37'),
	(1064,1064,1,1,10,'2019-10-18 16:27:37','2019-10-18 16:27:37'),
	(1065,1065,1,0,10,'2019-10-18 16:27:37','2019-10-18 16:27:37'),
	(1066,1066,1,0,10,'2019-10-18 16:27:37','2019-10-18 16:27:37'),
	(1067,1067,1,0,10,'2019-10-18 16:27:37','2019-10-18 16:27:37'),
	(1068,1068,1,0,10,'2019-10-18 16:27:37','2019-10-18 16:27:37'),
	(1069,1069,1,1,10,'2019-10-18 16:27:37','2019-10-18 16:27:37');
ALTER TABLE `advanced_filter_user_settings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `advanced_filter_values` WRITE;
ALTER TABLE `advanced_filter_values` DISABLE KEYS;
INSERT INTO `advanced_filter_values` (`id`, `advanced_filter_id`, `field`, `value`, `many`) VALUES 
	(16918,742,'advanced_filter','1',0),
	(16919,742,'id__show','0',0),
	(16920,742,'name__show','1',0),
	(16921,742,'description__show','0',0),
	(16922,742,'LegalAdvisor__show','0',0),
	(16923,742,'risk_magnifier__show','0',0),
	(16924,742,'created__show','0',0),
	(16925,742,'modified__show','0',0),
	(16926,742,'comment_message__show','1',0),
	(16927,742,'last_comment__show','0',0),
	(16928,742,'attachment_filename__show','0',0),
	(16929,742,'last_attachment__show','0',0),
	(16930,742,'_limit','-1',0),
	(16931,742,'_order_column','name',0),
	(16932,742,'_order_direction','ASC',0),
	(16933,742,'last_comment','_minus_1_days_',0),
	(16934,742,'last_comment__comp_type','1',0),
	(16935,743,'advanced_filter','1',0),
	(16936,743,'id__show','0',0),
	(16937,743,'name__show','1',0),
	(16938,743,'description__show','0',0),
	(16939,743,'LegalAdvisor__show','0',0),
	(16940,743,'risk_magnifier__show','0',0),
	(16941,743,'created__show','0',0),
	(16942,743,'modified__show','0',0),
	(16943,743,'comment_message__show','0',0),
	(16944,743,'last_comment__show','0',0),
	(16945,743,'attachment_filename__show','1',0),
	(16946,743,'last_attachment__show','0',0),
	(16947,743,'_limit','-1',0),
	(16948,743,'_order_column','name',0),
	(16949,743,'_order_direction','ASC',0),
	(16950,743,'last_attachment','_minus_1_days_',0),
	(16951,743,'last_attachment__comp_type','1',0),
	(16952,744,'advanced_filter','1',0),
	(16953,744,'id__show','0',0),
	(16954,744,'name__show','1',0),
	(16955,744,'description__show','0',0),
	(16956,744,'LegalAdvisor__show','0',0),
	(16957,744,'risk_magnifier__show','0',0),
	(16958,744,'created__show','0',0),
	(16959,744,'modified__show','0',0),
	(16960,744,'comment_message__show','0',0),
	(16961,744,'last_comment__show','0',0),
	(16962,744,'attachment_filename__show','0',0),
	(16963,744,'last_attachment__show','0',0),
	(16964,744,'_limit','-1',0),
	(16965,744,'_order_column','name',0),
	(16966,744,'_order_direction','ASC',0),
	(16967,744,'modified','_minus_1_days_',0),
	(16968,744,'modified__comp_type','1',0),
	(16969,745,'advanced_filter','1',0),
	(16970,745,'id__show','0',0),
	(16971,745,'name__show','1',0),
	(16972,745,'description__show','0',0),
	(16973,745,'LegalAdvisor__show','0',0),
	(16974,745,'risk_magnifier__show','0',0),
	(16975,745,'created__show','0',0),
	(16976,745,'modified__show','0',0),
	(16977,745,'comment_message__show','0',0),
	(16978,745,'last_comment__show','0',0),
	(16979,745,'attachment_filename__show','0',0),
	(16980,745,'last_attachment__show','0',0),
	(16981,745,'_limit','-1',0),
	(16982,745,'_order_column','name',0),
	(16983,745,'_order_direction','ASC',0),
	(16984,745,'created','_minus_1_days_',0),
	(16985,745,'created__comp_type','1',0),
	(16986,746,'advanced_filter','1',0),
	(16987,746,'name__show','1',0),
	(16988,746,'description__show','1',0),
	(16989,746,'LegalAdvisor__show','1',0),
	(16990,746,'risk_magnifier__show','1',0),
	(16991,746,'_limit','-1',0),
	(16992,746,'_order_column','created',0),
	(16993,746,'_order_direction','DESC',0),
	(16994,747,'advanced_filter','1',0),
	(16995,747,'id__show','0',0),
	(16996,747,'name__show','1',0),
	(16997,747,'description__show','0',0),
	(16998,747,'third_party_type_id__show','0',0),
	(16999,747,'Sponsor__show','0',0),
	(17000,747,'Legal__show','0',0),
	(17001,747,'created__show','0',0),
	(17002,747,'modified__show','0',0),
	(17003,747,'comment_message__show','1',0),
	(17004,747,'last_comment__show','0',0),
	(17005,747,'attachment_filename__show','0',0),
	(17006,747,'last_attachment__show','0',0),
	(17007,747,'_limit','-1',0),
	(17008,747,'_order_column','name',0),
	(17009,747,'_order_direction','ASC',0),
	(17010,747,'last_comment','_minus_1_days_',0),
	(17011,747,'last_comment__comp_type','1',0),
	(17012,748,'advanced_filter','1',0),
	(17013,748,'id__show','0',0),
	(17014,748,'name__show','1',0),
	(17015,748,'description__show','0',0),
	(17016,748,'third_party_type_id__show','0',0),
	(17017,748,'Sponsor__show','0',0),
	(17018,748,'Legal__show','0',0),
	(17019,748,'created__show','0',0),
	(17020,748,'modified__show','0',0),
	(17021,748,'comment_message__show','0',0),
	(17022,748,'last_comment__show','0',0),
	(17023,748,'attachment_filename__show','1',0),
	(17024,748,'last_attachment__show','0',0),
	(17025,748,'_limit','-1',0),
	(17026,748,'_order_column','name',0),
	(17027,748,'_order_direction','ASC',0),
	(17028,748,'last_attachment','_minus_1_days_',0),
	(17029,748,'last_attachment__comp_type','1',0),
	(17030,749,'advanced_filter','1',0),
	(17031,749,'id__show','0',0),
	(17032,749,'name__show','1',0),
	(17033,749,'description__show','0',0),
	(17034,749,'third_party_type_id__show','0',0),
	(17035,749,'Sponsor__show','0',0),
	(17036,749,'Legal__show','0',0),
	(17037,749,'created__show','0',0),
	(17038,749,'modified__show','0',0),
	(17039,749,'comment_message__show','0',0),
	(17040,749,'last_comment__show','0',0),
	(17041,749,'attachment_filename__show','0',0),
	(17042,749,'last_attachment__show','0',0),
	(17043,749,'_limit','-1',0),
	(17044,749,'_order_column','name',0),
	(17045,749,'_order_direction','ASC',0),
	(17046,749,'modified','_minus_1_days_',0),
	(17047,749,'modified__comp_type','1',0),
	(17048,750,'advanced_filter','1',0),
	(17049,750,'id__show','0',0),
	(17050,750,'name__show','1',0),
	(17051,750,'description__show','0',0),
	(17052,750,'third_party_type_id__show','0',0),
	(17053,750,'Sponsor__show','0',0),
	(17054,750,'Legal__show','0',0),
	(17055,750,'created__show','0',0),
	(17056,750,'modified__show','0',0),
	(17057,750,'comment_message__show','0',0),
	(17058,750,'last_comment__show','0',0),
	(17059,750,'attachment_filename__show','0',0),
	(17060,750,'last_attachment__show','0',0),
	(17061,750,'_limit','-1',0),
	(17062,750,'_order_column','name',0),
	(17063,750,'_order_direction','ASC',0),
	(17064,750,'created','_minus_1_days_',0),
	(17065,750,'created__comp_type','1',0),
	(17066,751,'advanced_filter','1',0),
	(17067,751,'name__show','1',0),
	(17068,751,'description__show','1',0),
	(17069,751,'third_party_type_id__show','1',0),
	(17070,751,'Sponsor__show','1',0),
	(17071,751,'Legal__show','1',0),
	(17072,751,'_limit','-1',0),
	(17073,751,'_order_column','created',0),
	(17074,751,'_order_direction','DESC',0),
	(17075,752,'advanced_filter','1',0),
	(17076,752,'id__show','0',0),
	(17077,752,'name__show','1',0),
	(17078,752,'objective__show','0',0),
	(17079,752,'documentation_url__show','0',0),
	(17080,752,'security_service_type_id__show','0',0),
	(17081,752,'ServiceOwner__show','0',0),
	(17082,752,'Collaborator__show','0',0),
	(17083,752,'Classification-name__show','0',0),
	(17084,752,'opex__show','0',0),
	(17085,752,'capex__show','0',0),
	(17086,752,'resource_utilization__show','0',0),
	(17087,752,'ObjectStatus_control_with_issues__show','0',0),
	(17088,752,'SecurityServiceAudit-planned_date__show','0',0),
	(17089,752,'audit_metric_description__show','0',0),
	(17090,752,'audit_success_criteria__show','0',0),
	(17091,752,'AuditOwner__show','0',0),
	(17092,752,'AuditEvidenceOwner__show','0',0),
	(17093,752,'ObjectStatus_audits_last_not_passed__show','0',0),
	(17094,752,'ObjectStatus_audits_last_missing__show','0',0),
	(17095,752,'SecurityServiceMaintenance-planned_date__show','0',0),
	(17096,752,'maintenance_metric_description__show','0',0),
	(17097,752,'MaintenanceOwner__show','0',0),
	(17098,752,'ObjectStatus_maintenances_last_not_passed__show','0',0),
	(17099,752,'ObjectStatus_maintenances_last_missing__show','0',0),
	(17100,752,'SecurityIncident__show','0',0),
	(17101,752,'SecurityIncident-security_incident_status_id__show','0',0),
	(17102,752,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17103,752,'CompliancePackage-package_id__show','0',0),
	(17104,752,'CompliancePackage-name__show','0',0),
	(17105,752,'CompliancePackageItem-item_id__show','0',0),
	(17106,752,'CompliancePackageItem-name__show','0',0),
	(17107,752,'Risk__show','0',0),
	(17108,752,'ThirdPartyRisk__show','0',0),
	(17109,752,'BusinessContinuity__show','0',0),
	(17110,752,'DataAssetInstance-asset_id__show','0',0),
	(17111,752,'DataAsset__show','0',0),
	(17112,752,'DataAsset-data_asset_status_id__show','0',0),
	(17113,752,'SecurityPolicy__show','0',0),
	(17114,752,'Project__show','0',0),
	(17115,752,'ProjectAchievement-description__show','0',0),
	(17116,752,'ObjectStatus_project_planned__show','0',0),
	(17117,752,'ObjectStatus_project_ongoing__show','0',0),
	(17118,752,'ObjectStatus_project_closed__show','0',0),
	(17119,752,'ObjectStatus_project_expired__show','0',0),
	(17120,752,'ObjectStatus_project_expired_tasks__show','0',0),
	(17121,752,'ServiceContract__show','0',0),
	(17122,752,'created__show','0',0),
	(17123,752,'modified__show','0',0),
	(17124,752,'comment_message__show','1',0),
	(17125,752,'last_comment__show','0',0),
	(17126,752,'attachment_filename__show','0',0),
	(17127,752,'last_attachment__show','0',0),
	(17128,752,'_limit','-1',0),
	(17129,752,'_order_column','name',0),
	(17130,752,'_order_direction','ASC',0),
	(17131,752,'last_comment','_minus_1_days_',0),
	(17132,752,'last_comment__comp_type','1',0),
	(17133,753,'advanced_filter','1',0),
	(17134,753,'id__show','0',0),
	(17135,753,'name__show','1',0),
	(17136,753,'objective__show','0',0),
	(17137,753,'documentation_url__show','0',0),
	(17138,753,'security_service_type_id__show','0',0),
	(17139,753,'ServiceOwner__show','0',0),
	(17140,753,'Collaborator__show','0',0),
	(17141,753,'Classification-name__show','0',0),
	(17142,753,'opex__show','0',0),
	(17143,753,'capex__show','0',0),
	(17144,753,'resource_utilization__show','0',0),
	(17145,753,'ObjectStatus_control_with_issues__show','0',0),
	(17146,753,'SecurityServiceAudit-planned_date__show','0',0),
	(17147,753,'audit_metric_description__show','0',0),
	(17148,753,'audit_success_criteria__show','0',0),
	(17149,753,'AuditOwner__show','0',0),
	(17150,753,'AuditEvidenceOwner__show','0',0),
	(17151,753,'ObjectStatus_audits_last_not_passed__show','0',0),
	(17152,753,'ObjectStatus_audits_last_missing__show','0',0),
	(17153,753,'SecurityServiceMaintenance-planned_date__show','0',0),
	(17154,753,'maintenance_metric_description__show','0',0),
	(17155,753,'MaintenanceOwner__show','0',0),
	(17156,753,'ObjectStatus_maintenances_last_not_passed__show','0',0),
	(17157,753,'ObjectStatus_maintenances_last_missing__show','0',0),
	(17158,753,'SecurityIncident__show','0',0),
	(17159,753,'SecurityIncident-security_incident_status_id__show','0',0),
	(17160,753,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17161,753,'CompliancePackage-package_id__show','0',0),
	(17162,753,'CompliancePackage-name__show','0',0),
	(17163,753,'CompliancePackageItem-item_id__show','0',0),
	(17164,753,'CompliancePackageItem-name__show','0',0),
	(17165,753,'Risk__show','0',0),
	(17166,753,'ThirdPartyRisk__show','0',0),
	(17167,753,'BusinessContinuity__show','0',0),
	(17168,753,'DataAssetInstance-asset_id__show','0',0),
	(17169,753,'DataAsset__show','0',0),
	(17170,753,'DataAsset-data_asset_status_id__show','0',0),
	(17171,753,'SecurityPolicy__show','0',0),
	(17172,753,'Project__show','0',0),
	(17173,753,'ProjectAchievement-description__show','0',0),
	(17174,753,'ObjectStatus_project_planned__show','0',0),
	(17175,753,'ObjectStatus_project_ongoing__show','0',0),
	(17176,753,'ObjectStatus_project_closed__show','0',0),
	(17177,753,'ObjectStatus_project_expired__show','0',0),
	(17178,753,'ObjectStatus_project_expired_tasks__show','0',0),
	(17179,753,'ServiceContract__show','0',0),
	(17180,753,'created__show','0',0),
	(17181,753,'modified__show','0',0),
	(17182,753,'comment_message__show','0',0),
	(17183,753,'last_comment__show','0',0),
	(17184,753,'attachment_filename__show','1',0),
	(17185,753,'last_attachment__show','0',0),
	(17186,753,'_limit','-1',0),
	(17187,753,'_order_column','name',0),
	(17188,753,'_order_direction','ASC',0),
	(17189,753,'last_attachment','_minus_1_days_',0),
	(17190,753,'last_attachment__comp_type','1',0),
	(17191,754,'advanced_filter','1',0),
	(17192,754,'id__show','0',0),
	(17193,754,'name__show','1',0),
	(17194,754,'objective__show','0',0),
	(17195,754,'documentation_url__show','0',0),
	(17196,754,'security_service_type_id__show','0',0),
	(17197,754,'ServiceOwner__show','0',0),
	(17198,754,'Collaborator__show','0',0),
	(17199,754,'Classification-name__show','0',0),
	(17200,754,'opex__show','0',0),
	(17201,754,'capex__show','0',0),
	(17202,754,'resource_utilization__show','0',0),
	(17203,754,'ObjectStatus_control_with_issues__show','0',0),
	(17204,754,'SecurityServiceAudit-planned_date__show','0',0),
	(17205,754,'audit_metric_description__show','0',0),
	(17206,754,'audit_success_criteria__show','0',0),
	(17207,754,'AuditOwner__show','0',0),
	(17208,754,'AuditEvidenceOwner__show','0',0),
	(17209,754,'ObjectStatus_audits_last_not_passed__show','0',0),
	(17210,754,'ObjectStatus_audits_last_missing__show','0',0),
	(17211,754,'SecurityServiceMaintenance-planned_date__show','0',0),
	(17212,754,'maintenance_metric_description__show','0',0),
	(17213,754,'MaintenanceOwner__show','0',0),
	(17214,754,'ObjectStatus_maintenances_last_not_passed__show','0',0),
	(17215,754,'ObjectStatus_maintenances_last_missing__show','0',0),
	(17216,754,'SecurityIncident__show','0',0),
	(17217,754,'SecurityIncident-security_incident_status_id__show','0',0),
	(17218,754,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17219,754,'CompliancePackage-package_id__show','0',0),
	(17220,754,'CompliancePackage-name__show','0',0),
	(17221,754,'CompliancePackageItem-item_id__show','0',0),
	(17222,754,'CompliancePackageItem-name__show','0',0),
	(17223,754,'Risk__show','0',0),
	(17224,754,'ThirdPartyRisk__show','0',0),
	(17225,754,'BusinessContinuity__show','0',0),
	(17226,754,'DataAssetInstance-asset_id__show','0',0),
	(17227,754,'DataAsset__show','0',0),
	(17228,754,'DataAsset-data_asset_status_id__show','0',0),
	(17229,754,'SecurityPolicy__show','0',0),
	(17230,754,'Project__show','0',0),
	(17231,754,'ProjectAchievement-description__show','0',0),
	(17232,754,'ObjectStatus_project_planned__show','0',0),
	(17233,754,'ObjectStatus_project_ongoing__show','0',0),
	(17234,754,'ObjectStatus_project_closed__show','0',0),
	(17235,754,'ObjectStatus_project_expired__show','0',0),
	(17236,754,'ObjectStatus_project_expired_tasks__show','0',0),
	(17237,754,'ServiceContract__show','0',0),
	(17238,754,'created__show','0',0),
	(17239,754,'modified__show','0',0),
	(17240,754,'comment_message__show','0',0),
	(17241,754,'last_comment__show','0',0),
	(17242,754,'attachment_filename__show','0',0),
	(17243,754,'last_attachment__show','0',0),
	(17244,754,'_limit','-1',0),
	(17245,754,'_order_column','name',0),
	(17246,754,'_order_direction','ASC',0),
	(17247,754,'modified','_minus_1_days_',0),
	(17248,754,'modified__comp_type','1',0),
	(17249,755,'advanced_filter','1',0),
	(17250,755,'id__show','0',0),
	(17251,755,'name__show','1',0),
	(17252,755,'objective__show','0',0),
	(17253,755,'documentation_url__show','0',0),
	(17254,755,'security_service_type_id__show','0',0),
	(17255,755,'ServiceOwner__show','0',0),
	(17256,755,'Collaborator__show','0',0),
	(17257,755,'Classification-name__show','0',0),
	(17258,755,'opex__show','0',0),
	(17259,755,'capex__show','0',0),
	(17260,755,'resource_utilization__show','0',0),
	(17261,755,'ObjectStatus_control_with_issues__show','0',0),
	(17262,755,'SecurityServiceAudit-planned_date__show','0',0),
	(17263,755,'audit_metric_description__show','0',0),
	(17264,755,'audit_success_criteria__show','0',0),
	(17265,755,'AuditOwner__show','0',0),
	(17266,755,'AuditEvidenceOwner__show','0',0),
	(17267,755,'ObjectStatus_audits_last_not_passed__show','0',0),
	(17268,755,'ObjectStatus_audits_last_missing__show','0',0),
	(17269,755,'SecurityServiceMaintenance-planned_date__show','0',0),
	(17270,755,'maintenance_metric_description__show','0',0),
	(17271,755,'MaintenanceOwner__show','0',0),
	(17272,755,'ObjectStatus_maintenances_last_not_passed__show','0',0),
	(17273,755,'ObjectStatus_maintenances_last_missing__show','0',0),
	(17274,755,'SecurityIncident__show','0',0),
	(17275,755,'SecurityIncident-security_incident_status_id__show','0',0),
	(17276,755,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17277,755,'CompliancePackage-package_id__show','0',0),
	(17278,755,'CompliancePackage-name__show','0',0),
	(17279,755,'CompliancePackageItem-item_id__show','0',0),
	(17280,755,'CompliancePackageItem-name__show','0',0),
	(17281,755,'Risk__show','0',0),
	(17282,755,'ThirdPartyRisk__show','0',0),
	(17283,755,'BusinessContinuity__show','0',0),
	(17284,755,'DataAssetInstance-asset_id__show','0',0),
	(17285,755,'DataAsset__show','0',0),
	(17286,755,'DataAsset-data_asset_status_id__show','0',0),
	(17287,755,'SecurityPolicy__show','0',0),
	(17288,755,'Project__show','0',0),
	(17289,755,'ProjectAchievement-description__show','0',0),
	(17290,755,'ObjectStatus_project_planned__show','0',0),
	(17291,755,'ObjectStatus_project_ongoing__show','0',0),
	(17292,755,'ObjectStatus_project_closed__show','0',0),
	(17293,755,'ObjectStatus_project_expired__show','0',0),
	(17294,755,'ObjectStatus_project_expired_tasks__show','0',0),
	(17295,755,'ServiceContract__show','0',0),
	(17296,755,'created__show','0',0),
	(17297,755,'modified__show','0',0),
	(17298,755,'comment_message__show','0',0),
	(17299,755,'last_comment__show','0',0),
	(17300,755,'attachment_filename__show','0',0),
	(17301,755,'last_attachment__show','0',0),
	(17302,755,'_limit','-1',0),
	(17303,755,'_order_column','name',0),
	(17304,755,'_order_direction','ASC',0),
	(17305,755,'created','_minus_1_days_',0),
	(17306,755,'created__comp_type','1',0),
	(17307,756,'advanced_filter','1',0),
	(17308,756,'name__show','1',0),
	(17309,756,'objective__show','1',0),
	(17310,756,'ServiceOwner__show','1',0),
	(17311,756,'Collaborator__show','1',0),
	(17312,756,'opex__show','1',0),
	(17313,756,'capex__show','1',0),
	(17314,756,'resource_utilization__show','1',0),
	(17315,756,'_limit','-1',0),
	(17316,756,'_order_column','created',0),
	(17317,756,'_order_direction','DESC',0),
	(17318,757,'advanced_filter','1',0),
	(17319,757,'name__show','1',0),
	(17320,757,'objective__show','1',0),
	(17321,757,'ServiceOwner__show','1',0),
	(17322,757,'Collaborator__show','1',0),
	(17323,757,'opex__show','1',0),
	(17324,757,'capex__show','1',0),
	(17325,757,'resource_utilization__show','1',0),
	(17326,757,'_limit','-1',0),
	(17327,757,'_order_column','name',0),
	(17328,757,'_order_direction','ASC',0),
	(17329,757,'ObjectStatus_control_with_issues','1',0),
	(17330,757,'ObjectStatus_control_with_issues__show','1',0),
	(17331,758,'advanced_filter','1',0),
	(17332,758,'name__show','1',0),
	(17333,758,'objective__show','1',0),
	(17334,758,'ServiceOwner__show','1',0),
	(17335,758,'Collaborator__show','1',0),
	(17336,758,'opex__show','1',0),
	(17337,758,'capex__show','1',0),
	(17338,758,'resource_utilization__show','1',0),
	(17339,758,'_limit','-1',0),
	(17340,758,'_order_column','name',0),
	(17341,758,'_order_direction','ASC',0),
	(17342,758,'ObjectStatus_audits_last_missing','1',0),
	(17343,758,'ObjectStatus_audits_last_missing__show','1',0),
	(17344,759,'advanced_filter','1',0),
	(17345,759,'name__show','1',0),
	(17346,759,'objective__show','1',0),
	(17347,759,'ServiceOwner__show','1',0),
	(17348,759,'Collaborator__show','1',0),
	(17349,759,'opex__show','1',0),
	(17350,759,'capex__show','1',0),
	(17351,759,'resource_utilization__show','1',0),
	(17352,759,'_limit','-1',0),
	(17353,759,'_order_column','name',0),
	(17354,759,'_order_direction','ASC',0),
	(17355,759,'ObjectStatus_maintenances_last_missing','1',0),
	(17356,759,'ObjectStatus_maintenances_last_missing__show','1',0),
	(17357,760,'advanced_filter','1',0),
	(17358,760,'name__show','1',0),
	(17359,760,'objective__show','1',0),
	(17360,760,'ServiceOwner__show','1',0),
	(17361,760,'Collaborator__show','1',0),
	(17362,760,'opex__show','1',0),
	(17363,760,'capex__show','1',0),
	(17364,760,'resource_utilization__show','1',0),
	(17365,760,'_limit','-1',0),
	(17366,760,'_order_column','name',0),
	(17367,760,'_order_direction','ASC',0),
	(17368,760,'ObjectStatus_maintenances_last_not_passed','1',0),
	(17369,760,'ObjectStatus_maintenances_last_not_passed__show','1',0),
	(17370,761,'advanced_filter','1',0),
	(17371,761,'name__show','1',0),
	(17372,761,'objective__show','1',0),
	(17373,761,'ServiceOwner__show','1',0),
	(17374,761,'Collaborator__show','1',0),
	(17375,761,'opex__show','1',0),
	(17376,761,'capex__show','1',0),
	(17377,761,'resource_utilization__show','1',0),
	(17378,761,'_limit','-1',0),
	(17379,761,'_order_column','name',0),
	(17380,761,'_order_direction','ASC',0),
	(17381,761,'ObjectStatus_audits_last_not_passed','1',0),
	(17382,761,'ObjectStatus_audits_last_not_passed__show','1',0),
	(17383,762,'advanced_filter','1',0),
	(17384,762,'id__show','0',0),
	(17385,762,'security_service_id__show','1',0),
	(17386,762,'audit_metric_description__show','0',0),
	(17387,762,'audit_success_criteria__show','0',0),
	(17388,762,'planned_date__show','1',0),
	(17389,762,'start_date__show','0',0),
	(17390,762,'end_date__show','0',0),
	(17391,762,'result__show','0',0),
	(17392,762,'result_description__show','0',0),
	(17393,762,'AuditOwner__show','0',0),
	(17394,762,'AuditEvidenceOwner__show','0',0),
	(17395,762,'ObjectStatus_audit_missing__show','0',0),
	(17396,762,'SecurityService-SecurityIncident__show','0',0),
	(17397,762,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17398,762,'CompliancePackage-package_id__show','0',0),
	(17399,762,'CompliancePackage-name__show','0',0),
	(17400,762,'CompliancePackageItem-item_id__show','0',0),
	(17401,762,'CompliancePackageItem-name__show','0',0),
	(17402,762,'SecurityService-Risk__show','0',0),
	(17403,762,'SecurityService-ThirdPartyRisk__show','0',0),
	(17404,762,'SecurityService-BusinessContinuity__show','0',0),
	(17405,762,'DataAssetInstance-asset_id__show','0',0),
	(17406,762,'SecurityService-DataAsset__show','0',0),
	(17407,762,'DataAsset-data_asset_status_id__show','0',0),
	(17408,762,'SecurityService-Project__show','0',0),
	(17409,762,'ProjectAchievement-description__show','0',0),
	(17410,762,'created__show','0',0),
	(17411,762,'modified__show','0',0),
	(17412,762,'comment_message__show','1',0),
	(17413,762,'last_comment__show','0',0),
	(17414,762,'attachment_filename__show','0',0),
	(17415,762,'last_attachment__show','0',0),
	(17416,762,'_limit','-1',0),
	(17417,762,'_order_column','planned_date',0),
	(17418,762,'_order_direction','ASC',0),
	(17419,762,'last_comment','_minus_1_days_',0),
	(17420,762,'last_comment__comp_type','1',0),
	(17421,763,'advanced_filter','1',0),
	(17422,763,'id__show','0',0),
	(17423,763,'security_service_id__show','1',0),
	(17424,763,'audit_metric_description__show','0',0),
	(17425,763,'audit_success_criteria__show','0',0),
	(17426,763,'planned_date__show','1',0),
	(17427,763,'start_date__show','0',0),
	(17428,763,'end_date__show','0',0),
	(17429,763,'result__show','0',0),
	(17430,763,'result_description__show','0',0),
	(17431,763,'AuditOwner__show','0',0),
	(17432,763,'AuditEvidenceOwner__show','0',0),
	(17433,763,'ObjectStatus_audit_missing__show','0',0),
	(17434,763,'SecurityService-SecurityIncident__show','0',0),
	(17435,763,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17436,763,'CompliancePackage-package_id__show','0',0),
	(17437,763,'CompliancePackage-name__show','0',0),
	(17438,763,'CompliancePackageItem-item_id__show','0',0),
	(17439,763,'CompliancePackageItem-name__show','0',0),
	(17440,763,'SecurityService-Risk__show','0',0),
	(17441,763,'SecurityService-ThirdPartyRisk__show','0',0),
	(17442,763,'SecurityService-BusinessContinuity__show','0',0),
	(17443,763,'DataAssetInstance-asset_id__show','0',0),
	(17444,763,'SecurityService-DataAsset__show','0',0),
	(17445,763,'DataAsset-data_asset_status_id__show','0',0),
	(17446,763,'SecurityService-Project__show','0',0),
	(17447,763,'ProjectAchievement-description__show','0',0),
	(17448,763,'created__show','0',0),
	(17449,763,'modified__show','0',0),
	(17450,763,'comment_message__show','0',0),
	(17451,763,'last_comment__show','0',0),
	(17452,763,'attachment_filename__show','1',0),
	(17453,763,'last_attachment__show','0',0),
	(17454,763,'_limit','-1',0),
	(17455,763,'_order_column','planned_date',0),
	(17456,763,'_order_direction','ASC',0),
	(17457,763,'last_attachment','_minus_1_days_',0),
	(17458,763,'last_attachment__comp_type','1',0),
	(17459,764,'advanced_filter','1',0),
	(17460,764,'id__show','0',0),
	(17461,764,'security_service_id__show','1',0),
	(17462,764,'audit_metric_description__show','0',0),
	(17463,764,'audit_success_criteria__show','0',0),
	(17464,764,'planned_date__show','1',0),
	(17465,764,'start_date__show','0',0),
	(17466,764,'end_date__show','0',0),
	(17467,764,'result__show','0',0),
	(17468,764,'result_description__show','0',0),
	(17469,764,'AuditOwner__show','0',0),
	(17470,764,'AuditEvidenceOwner__show','0',0),
	(17471,764,'ObjectStatus_audit_missing__show','0',0),
	(17472,764,'SecurityService-SecurityIncident__show','0',0),
	(17473,764,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17474,764,'CompliancePackage-package_id__show','0',0),
	(17475,764,'CompliancePackage-name__show','0',0),
	(17476,764,'CompliancePackageItem-item_id__show','0',0),
	(17477,764,'CompliancePackageItem-name__show','0',0),
	(17478,764,'SecurityService-Risk__show','0',0),
	(17479,764,'SecurityService-ThirdPartyRisk__show','0',0),
	(17480,764,'SecurityService-BusinessContinuity__show','0',0),
	(17481,764,'DataAssetInstance-asset_id__show','0',0),
	(17482,764,'SecurityService-DataAsset__show','0',0),
	(17483,764,'DataAsset-data_asset_status_id__show','0',0),
	(17484,764,'SecurityService-Project__show','0',0),
	(17485,764,'ProjectAchievement-description__show','0',0),
	(17486,764,'created__show','0',0),
	(17487,764,'modified__show','0',0),
	(17488,764,'comment_message__show','0',0),
	(17489,764,'last_comment__show','0',0),
	(17490,764,'attachment_filename__show','0',0),
	(17491,764,'last_attachment__show','0',0),
	(17492,764,'_limit','-1',0),
	(17493,764,'_order_column','planned_date',0),
	(17494,764,'_order_direction','ASC',0),
	(17495,764,'modified','_minus_1_days_',0),
	(17496,764,'modified__comp_type','1',0),
	(17497,765,'advanced_filter','1',0),
	(17498,765,'id__show','0',0),
	(17499,765,'security_service_id__show','1',0),
	(17500,765,'audit_metric_description__show','0',0),
	(17501,765,'audit_success_criteria__show','0',0),
	(17502,765,'planned_date__show','1',0),
	(17503,765,'start_date__show','0',0),
	(17504,765,'end_date__show','0',0),
	(17505,765,'result__show','0',0),
	(17506,765,'result_description__show','0',0),
	(17507,765,'AuditOwner__show','0',0),
	(17508,765,'AuditEvidenceOwner__show','0',0),
	(17509,765,'ObjectStatus_audit_missing__show','0',0),
	(17510,765,'SecurityService-SecurityIncident__show','0',0),
	(17511,765,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17512,765,'CompliancePackage-package_id__show','0',0),
	(17513,765,'CompliancePackage-name__show','0',0),
	(17514,765,'CompliancePackageItem-item_id__show','0',0),
	(17515,765,'CompliancePackageItem-name__show','0',0),
	(17516,765,'SecurityService-Risk__show','0',0),
	(17517,765,'SecurityService-ThirdPartyRisk__show','0',0),
	(17518,765,'SecurityService-BusinessContinuity__show','0',0),
	(17519,765,'DataAssetInstance-asset_id__show','0',0),
	(17520,765,'SecurityService-DataAsset__show','0',0),
	(17521,765,'DataAsset-data_asset_status_id__show','0',0),
	(17522,765,'SecurityService-Project__show','0',0),
	(17523,765,'ProjectAchievement-description__show','0',0),
	(17524,765,'created__show','0',0),
	(17525,765,'modified__show','0',0),
	(17526,765,'comment_message__show','0',0),
	(17527,765,'last_comment__show','0',0),
	(17528,765,'attachment_filename__show','0',0),
	(17529,765,'last_attachment__show','0',0),
	(17530,765,'_limit','-1',0),
	(17531,765,'_order_column','planned_date',0),
	(17532,765,'_order_direction','ASC',0),
	(17533,765,'created','_minus_1_days_',0),
	(17534,765,'created__comp_type','1',0),
	(17535,766,'advanced_filter','1',0),
	(17536,766,'security_service_id__show','1',0),
	(17537,766,'audit_metric_description__show','1',0),
	(17538,766,'audit_success_criteria__show','1',0),
	(17539,766,'planned_date__show','1',0),
	(17540,766,'start_date__show','1',0),
	(17541,766,'end_date__show','1',0),
	(17542,766,'result__show','1',0),
	(17543,766,'result_description__show','1',0),
	(17544,766,'AuditOwner__show','1',0),
	(17545,766,'AuditEvidenceOwner__show','1',0),
	(17546,766,'_limit','-1',0),
	(17547,766,'_order_column','created',0),
	(17548,766,'_order_direction','DESC',0),
	(17549,767,'advanced_filter','1',0),
	(17550,767,'security_service_id__show','1',0),
	(17551,767,'audit_metric_description__show','1',0),
	(17552,767,'audit_success_criteria__show','1',0),
	(17553,767,'planned_date__show','1',0),
	(17554,767,'start_date__show','1',0),
	(17555,767,'end_date__show','1',0),
	(17556,767,'result__show','1',0),
	(17557,767,'result_description__show','1',0),
	(17558,767,'AuditOwner__show','1',0),
	(17559,767,'AuditEvidenceOwner__show','1',0),
	(17560,767,'_limit','-1',0),
	(17561,767,'_order_column','planned_date',0),
	(17562,767,'_order_direction','ASC',0),
	(17563,767,'planned_date','_plus_14_days_',0),
	(17564,767,'planned_date__comp_type','2',0),
	(17565,767,'planned_date__use_calendar','0',0),
	(17566,767,'result__comp_type','0',0),
	(17567,767,'result','_null_',0),
	(17568,768,'advanced_filter','1',0),
	(17569,768,'security_service_id__show','1',0),
	(17570,768,'audit_metric_description__show','1',0),
	(17571,768,'audit_success_criteria__show','1',0),
	(17572,768,'planned_date__show','1',0),
	(17573,768,'start_date__show','1',0),
	(17574,768,'end_date__show','1',0),
	(17575,768,'result__show','1',0),
	(17576,768,'result_description__show','1',0),
	(17577,768,'AuditOwner__show','1',0),
	(17578,768,'AuditEvidenceOwner__show','1',0),
	(17579,768,'_limit','-1',0),
	(17580,768,'_order_column','planned_date',0),
	(17581,768,'_order_direction','ASC',0),
	(17582,768,'ObjectStatus_audit_missing','1',0),
	(17583,768,'ObjectStatus_audit_missing__show','1',0),
	(17584,769,'advanced_filter','1',0),
	(17585,769,'security_service_id__show','1',0),
	(17586,769,'audit_metric_description__show','1',0),
	(17587,769,'audit_success_criteria__show','1',0),
	(17588,769,'planned_date__show','1',0),
	(17589,769,'start_date__show','1',0),
	(17590,769,'end_date__show','1',0),
	(17591,769,'result__show','1',0),
	(17592,769,'result_description__show','1',0),
	(17593,769,'AuditOwner__show','1',0),
	(17594,769,'AuditEvidenceOwner__show','1',0),
	(17595,769,'_limit','-1',0),
	(17596,769,'_order_column','planned_date',0),
	(17597,769,'_order_direction','ASC',0),
	(17598,769,'result__comp_type','0',0),
	(17599,769,'result','0',0),
	(17600,770,'advanced_filter','1',0),
	(17601,770,'security_service_id__show','1',0),
	(17602,770,'audit_metric_description__show','1',0),
	(17603,770,'audit_success_criteria__show','1',0),
	(17604,770,'planned_date__show','1',0),
	(17605,770,'start_date__show','1',0),
	(17606,770,'end_date__show','1',0),
	(17607,770,'result__show','1',0),
	(17608,770,'result_description__show','1',0),
	(17609,770,'AuditOwner__show','1',0),
	(17610,770,'AuditEvidenceOwner__show','1',0),
	(17611,770,'_limit','-1',0),
	(17612,770,'_order_column','planned_date',0),
	(17613,770,'_order_direction','ASC',0),
	(17614,770,'result__comp_type','0',0),
	(17615,770,'result','1',0),
	(17616,771,'advanced_filter','1',0),
	(17617,771,'security_service_id__show','1',0),
	(17618,771,'audit_metric_description__show','1',0),
	(17619,771,'audit_success_criteria__show','1',0),
	(17620,771,'planned_date__show','1',0),
	(17621,771,'start_date__show','1',0),
	(17622,771,'end_date__show','1',0),
	(17623,771,'result__show','1',0),
	(17624,771,'result_description__show','1',0),
	(17625,771,'AuditOwner__show','1',0),
	(17626,771,'AuditEvidenceOwner__show','1',0),
	(17627,771,'_limit','-1',0),
	(17628,771,'_order_column','planned_date',0),
	(17629,771,'_order_direction','ASC',0),
	(17630,771,'result__comp_type','6',0),
	(17631,771,'result','_null_',0),
	(17632,772,'advanced_filter','1',0),
	(17633,772,'id__show','0',0),
	(17634,772,'security_service_id__show','1',0),
	(17635,772,'task__show','0',0),
	(17636,772,'planned_date__show','1',0),
	(17637,772,'start_date__show','0',0),
	(17638,772,'end_date__show','0',0),
	(17639,772,'result__show','0',0),
	(17640,772,'task_conclusion__show','0',0),
	(17641,772,'MaintenanceOwner__show','0',0),
	(17642,772,'ObjectStatus_maintenance_missing__show','0',0),
	(17643,772,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17644,772,'CompliancePackage-package_id__show','0',0),
	(17645,772,'CompliancePackage-name__show','0',0),
	(17646,772,'CompliancePackageItem-item_id__show','0',0),
	(17647,772,'CompliancePackageItem-name__show','0',0),
	(17648,772,'SecurityService-Risk__show','0',0),
	(17649,772,'SecurityService-ThirdPartyRisk__show','0',0),
	(17650,772,'SecurityService-BusinessContinuity__show','0',0),
	(17651,772,'DataAssetInstance-asset_id__show','0',0),
	(17652,772,'SecurityService-DataAsset__show','0',0),
	(17653,772,'DataAsset-data_asset_status_id__show','0',0),
	(17654,772,'created__show','0',0),
	(17655,772,'modified__show','0',0),
	(17656,772,'comment_message__show','1',0),
	(17657,772,'last_comment__show','0',0),
	(17658,772,'attachment_filename__show','0',0),
	(17659,772,'last_attachment__show','0',0),
	(17660,772,'_limit','-1',0),
	(17661,772,'_order_column','planned_date',0),
	(17662,772,'_order_direction','ASC',0),
	(17663,772,'last_comment','_minus_1_days_',0),
	(17664,772,'last_comment__comp_type','1',0),
	(17665,773,'advanced_filter','1',0),
	(17666,773,'id__show','0',0),
	(17667,773,'security_service_id__show','1',0),
	(17668,773,'task__show','0',0),
	(17669,773,'planned_date__show','1',0),
	(17670,773,'start_date__show','0',0),
	(17671,773,'end_date__show','0',0),
	(17672,773,'result__show','0',0),
	(17673,773,'task_conclusion__show','0',0),
	(17674,773,'MaintenanceOwner__show','0',0),
	(17675,773,'ObjectStatus_maintenance_missing__show','0',0),
	(17676,773,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17677,773,'CompliancePackage-package_id__show','0',0),
	(17678,773,'CompliancePackage-name__show','0',0),
	(17679,773,'CompliancePackageItem-item_id__show','0',0),
	(17680,773,'CompliancePackageItem-name__show','0',0),
	(17681,773,'SecurityService-Risk__show','0',0),
	(17682,773,'SecurityService-ThirdPartyRisk__show','0',0),
	(17683,773,'SecurityService-BusinessContinuity__show','0',0),
	(17684,773,'DataAssetInstance-asset_id__show','0',0),
	(17685,773,'SecurityService-DataAsset__show','0',0),
	(17686,773,'DataAsset-data_asset_status_id__show','0',0),
	(17687,773,'created__show','0',0),
	(17688,773,'modified__show','0',0),
	(17689,773,'comment_message__show','0',0),
	(17690,773,'last_comment__show','0',0),
	(17691,773,'attachment_filename__show','1',0),
	(17692,773,'last_attachment__show','0',0),
	(17693,773,'_limit','-1',0),
	(17694,773,'_order_column','planned_date',0),
	(17695,773,'_order_direction','ASC',0),
	(17696,773,'last_attachment','_minus_1_days_',0),
	(17697,773,'last_attachment__comp_type','1',0),
	(17698,774,'advanced_filter','1',0),
	(17699,774,'id__show','0',0),
	(17700,774,'security_service_id__show','1',0),
	(17701,774,'task__show','0',0),
	(17702,774,'planned_date__show','1',0),
	(17703,774,'start_date__show','0',0),
	(17704,774,'end_date__show','0',0),
	(17705,774,'result__show','0',0),
	(17706,774,'task_conclusion__show','0',0),
	(17707,774,'MaintenanceOwner__show','0',0),
	(17708,774,'ObjectStatus_maintenance_missing__show','0',0),
	(17709,774,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17710,774,'CompliancePackage-package_id__show','0',0),
	(17711,774,'CompliancePackage-name__show','0',0),
	(17712,774,'CompliancePackageItem-item_id__show','0',0),
	(17713,774,'CompliancePackageItem-name__show','0',0),
	(17714,774,'SecurityService-Risk__show','0',0),
	(17715,774,'SecurityService-ThirdPartyRisk__show','0',0),
	(17716,774,'SecurityService-BusinessContinuity__show','0',0),
	(17717,774,'DataAssetInstance-asset_id__show','0',0),
	(17718,774,'SecurityService-DataAsset__show','0',0),
	(17719,774,'DataAsset-data_asset_status_id__show','0',0),
	(17720,774,'created__show','0',0),
	(17721,774,'modified__show','0',0),
	(17722,774,'comment_message__show','0',0),
	(17723,774,'last_comment__show','0',0),
	(17724,774,'attachment_filename__show','0',0),
	(17725,774,'last_attachment__show','0',0),
	(17726,774,'_limit','-1',0),
	(17727,774,'_order_column','planned_date',0),
	(17728,774,'_order_direction','ASC',0),
	(17729,774,'modified','_minus_1_days_',0),
	(17730,774,'modified__comp_type','1',0),
	(17731,775,'advanced_filter','1',0),
	(17732,775,'id__show','0',0),
	(17733,775,'security_service_id__show','1',0),
	(17734,775,'task__show','0',0),
	(17735,775,'planned_date__show','1',0),
	(17736,775,'start_date__show','0',0),
	(17737,775,'end_date__show','0',0),
	(17738,775,'result__show','0',0),
	(17739,775,'task_conclusion__show','0',0),
	(17740,775,'MaintenanceOwner__show','0',0),
	(17741,775,'ObjectStatus_maintenance_missing__show','0',0),
	(17742,775,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17743,775,'CompliancePackage-package_id__show','0',0),
	(17744,775,'CompliancePackage-name__show','0',0),
	(17745,775,'CompliancePackageItem-item_id__show','0',0),
	(17746,775,'CompliancePackageItem-name__show','0',0),
	(17747,775,'SecurityService-Risk__show','0',0),
	(17748,775,'SecurityService-ThirdPartyRisk__show','0',0),
	(17749,775,'SecurityService-BusinessContinuity__show','0',0),
	(17750,775,'DataAssetInstance-asset_id__show','0',0),
	(17751,775,'SecurityService-DataAsset__show','0',0),
	(17752,775,'DataAsset-data_asset_status_id__show','0',0),
	(17753,775,'created__show','0',0),
	(17754,775,'modified__show','0',0),
	(17755,775,'comment_message__show','0',0),
	(17756,775,'last_comment__show','0',0),
	(17757,775,'attachment_filename__show','0',0),
	(17758,775,'last_attachment__show','0',0),
	(17759,775,'_limit','-1',0),
	(17760,775,'_order_column','planned_date',0),
	(17761,775,'_order_direction','ASC',0),
	(17762,775,'created','_minus_1_days_',0),
	(17763,775,'created__comp_type','1',0),
	(17764,776,'advanced_filter','1',0),
	(17765,776,'security_service_id__show','1',0),
	(17766,776,'task__show','1',0),
	(17767,776,'planned_date__show','1',0),
	(17768,776,'start_date__show','1',0),
	(17769,776,'end_date__show','1',0),
	(17770,776,'result__show','1',0),
	(17771,776,'task_conclusion__show','1',0),
	(17772,776,'MaintenanceOwner__show','1',0),
	(17773,776,'_limit','-1',0),
	(17774,776,'_order_column','created',0),
	(17775,776,'_order_direction','DESC',0),
	(17776,777,'advanced_filter','1',0),
	(17777,777,'security_service_id__show','1',0),
	(17778,777,'task__show','1',0),
	(17779,777,'planned_date__show','1',0),
	(17780,777,'start_date__show','1',0),
	(17781,777,'end_date__show','1',0),
	(17782,777,'result__show','1',0),
	(17783,777,'task_conclusion__show','1',0),
	(17784,777,'MaintenanceOwner__show','1',0),
	(17785,777,'_limit','-1',0),
	(17786,777,'_order_column','planned_date',0),
	(17787,777,'_order_direction','ASC',0),
	(17788,777,'planned_date','_plus_14_days_',0),
	(17789,777,'planned_date__comp_type','2',0),
	(17790,777,'planned_date__use_calendar','0',0),
	(17791,777,'result__comp_type','0',0),
	(17792,777,'result','_null_',0),
	(17793,778,'advanced_filter','1',0),
	(17794,778,'security_service_id__show','1',0),
	(17795,778,'task__show','1',0),
	(17796,778,'planned_date__show','1',0),
	(17797,778,'start_date__show','1',0),
	(17798,778,'end_date__show','1',0),
	(17799,778,'result__show','1',0),
	(17800,778,'task_conclusion__show','1',0),
	(17801,778,'MaintenanceOwner__show','1',0),
	(17802,778,'_limit','-1',0),
	(17803,778,'_order_column','planned_date',0),
	(17804,778,'_order_direction','ASC',0),
	(17805,778,'ObjectStatus_maintenance_missing','1',0),
	(17806,778,'ObjectStatus_maintenance_missing__show','1',0),
	(17807,779,'advanced_filter','1',0),
	(17808,779,'security_service_id__show','1',0),
	(17809,779,'task__show','1',0),
	(17810,779,'planned_date__show','1',0),
	(17811,779,'start_date__show','1',0),
	(17812,779,'end_date__show','1',0),
	(17813,779,'result__show','1',0),
	(17814,779,'task_conclusion__show','1',0),
	(17815,779,'MaintenanceOwner__show','1',0),
	(17816,779,'_limit','-1',0),
	(17817,779,'_order_column','planned_date',0),
	(17818,779,'_order_direction','ASC',0),
	(17819,779,'result__comp_type','0',0),
	(17820,779,'result','0',0),
	(17821,780,'advanced_filter','1',0),
	(17822,780,'security_service_id__show','1',0),
	(17823,780,'task__show','1',0),
	(17824,780,'planned_date__show','1',0),
	(17825,780,'start_date__show','1',0),
	(17826,780,'end_date__show','1',0),
	(17827,780,'result__show','1',0),
	(17828,780,'task_conclusion__show','1',0),
	(17829,780,'MaintenanceOwner__show','1',0),
	(17830,780,'_limit','-1',0),
	(17831,780,'_order_column','planned_date',0),
	(17832,780,'_order_direction','ASC',0),
	(17833,780,'result__comp_type','0',0),
	(17834,780,'result','1',0),
	(17835,781,'advanced_filter','1',0),
	(17836,781,'id__show','0',0),
	(17837,781,'index__show','1',0),
	(17838,781,'short_description__show','0',0),
	(17839,781,'Owner__show','0',0),
	(17840,781,'Collaborator__show','0',0),
	(17841,781,'Tag-title__show','0',0),
	(17842,781,'published_date__show','0',0),
	(17843,781,'next_review_date__show','0',0),
	(17844,781,'status__show','0',0),
	(17845,781,'ObjectStatus_expired_reviews__show','0',0),
	(17846,781,'asset_label_id__show','0',0),
	(17847,781,'security_policy_document_type_id__show','0',0),
	(17848,781,'version__show','0',0),
	(17849,781,'use_attachments__show','0',0),
	(17850,781,'permission__show','0',0),
	(17851,781,'ldap_connector_id__show','0',0),
	(17852,781,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17853,781,'CompliancePackage-package_id__show','0',0),
	(17854,781,'CompliancePackage-name__show','0',0),
	(17855,781,'CompliancePackageItem-item_id__show','0',0),
	(17856,781,'CompliancePackageItem-name__show','0',0),
	(17857,781,'RiskTreatment__show','0',0),
	(17858,781,'ThirdPartyRiskTreatment__show','0',0),
	(17859,781,'BusinessContinuityTreatment__show','0',0),
	(17860,781,'DataAssetInstance-asset_id__show','0',0),
	(17861,781,'DataAsset__show','0',0),
	(17862,781,'DataAsset-data_asset_status_id__show','0',0),
	(17863,781,'SecurityService__show','0',0),
	(17864,781,'SecurityService-objective__show','0',0),
	(17865,781,'Project__show','0',0),
	(17866,781,'ProjectAchievement-description__show','0',0),
	(17867,781,'ObjectStatus_project_planned__show','0',0),
	(17868,781,'ObjectStatus_project_ongoing__show','0',0),
	(17869,781,'ObjectStatus_project_closed__show','0',0),
	(17870,781,'ObjectStatus_project_expired__show','0',0),
	(17871,781,'ObjectStatus_project_expired_tasks__show','0',0),
	(17872,781,'created__show','0',0),
	(17873,781,'modified__show','0',0),
	(17874,781,'comment_message__show','1',0),
	(17875,781,'last_comment__show','0',0),
	(17876,781,'attachment_filename__show','0',0),
	(17877,781,'last_attachment__show','0',0),
	(17878,781,'_limit','-1',0),
	(17879,781,'_order_column','index',0),
	(17880,781,'_order_direction','ASC',0),
	(17881,781,'last_comment','_minus_1_days_',0),
	(17882,781,'last_comment__comp_type','1',0),
	(17883,782,'advanced_filter','1',0),
	(17884,782,'id__show','0',0),
	(17885,782,'index__show','1',0),
	(17886,782,'short_description__show','0',0),
	(17887,782,'Owner__show','0',0),
	(17888,782,'Collaborator__show','0',0),
	(17889,782,'Tag-title__show','0',0),
	(17890,782,'published_date__show','0',0),
	(17891,782,'next_review_date__show','0',0),
	(17892,782,'status__show','0',0),
	(17893,782,'ObjectStatus_expired_reviews__show','0',0),
	(17894,782,'asset_label_id__show','0',0),
	(17895,782,'security_policy_document_type_id__show','0',0),
	(17896,782,'version__show','0',0),
	(17897,782,'use_attachments__show','0',0),
	(17898,782,'permission__show','0',0),
	(17899,782,'ldap_connector_id__show','0',0),
	(17900,782,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17901,782,'CompliancePackage-package_id__show','0',0),
	(17902,782,'CompliancePackage-name__show','0',0),
	(17903,782,'CompliancePackageItem-item_id__show','0',0),
	(17904,782,'CompliancePackageItem-name__show','0',0),
	(17905,782,'RiskTreatment__show','0',0),
	(17906,782,'ThirdPartyRiskTreatment__show','0',0),
	(17907,782,'BusinessContinuityTreatment__show','0',0),
	(17908,782,'DataAssetInstance-asset_id__show','0',0),
	(17909,782,'DataAsset__show','0',0),
	(17910,782,'DataAsset-data_asset_status_id__show','0',0),
	(17911,782,'SecurityService__show','0',0),
	(17912,782,'SecurityService-objective__show','0',0),
	(17913,782,'Project__show','0',0),
	(17914,782,'ProjectAchievement-description__show','0',0),
	(17915,782,'ObjectStatus_project_planned__show','0',0),
	(17916,782,'ObjectStatus_project_ongoing__show','0',0),
	(17917,782,'ObjectStatus_project_closed__show','0',0),
	(17918,782,'ObjectStatus_project_expired__show','0',0),
	(17919,782,'ObjectStatus_project_expired_tasks__show','0',0),
	(17920,782,'created__show','0',0),
	(17921,782,'modified__show','0',0),
	(17922,782,'comment_message__show','0',0),
	(17923,782,'last_comment__show','0',0),
	(17924,782,'attachment_filename__show','1',0),
	(17925,782,'last_attachment__show','0',0),
	(17926,782,'_limit','-1',0),
	(17927,782,'_order_column','index',0),
	(17928,782,'_order_direction','ASC',0),
	(17929,782,'last_attachment','_minus_1_days_',0),
	(17930,782,'last_attachment__comp_type','1',0),
	(17931,783,'advanced_filter','1',0),
	(17932,783,'id__show','0',0),
	(17933,783,'index__show','1',0),
	(17934,783,'short_description__show','0',0),
	(17935,783,'Owner__show','0',0),
	(17936,783,'Collaborator__show','0',0),
	(17937,783,'Tag-title__show','0',0),
	(17938,783,'published_date__show','0',0),
	(17939,783,'next_review_date__show','0',0),
	(17940,783,'status__show','0',0),
	(17941,783,'ObjectStatus_expired_reviews__show','0',0),
	(17942,783,'asset_label_id__show','0',0),
	(17943,783,'security_policy_document_type_id__show','0',0),
	(17944,783,'version__show','0',0),
	(17945,783,'use_attachments__show','0',0),
	(17946,783,'permission__show','0',0),
	(17947,783,'ldap_connector_id__show','0',0),
	(17948,783,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17949,783,'CompliancePackage-package_id__show','0',0),
	(17950,783,'CompliancePackage-name__show','0',0),
	(17951,783,'CompliancePackageItem-item_id__show','0',0),
	(17952,783,'CompliancePackageItem-name__show','0',0),
	(17953,783,'RiskTreatment__show','0',0),
	(17954,783,'ThirdPartyRiskTreatment__show','0',0),
	(17955,783,'BusinessContinuityTreatment__show','0',0),
	(17956,783,'DataAssetInstance-asset_id__show','0',0),
	(17957,783,'DataAsset__show','0',0),
	(17958,783,'DataAsset-data_asset_status_id__show','0',0),
	(17959,783,'SecurityService__show','0',0),
	(17960,783,'SecurityService-objective__show','0',0),
	(17961,783,'Project__show','0',0),
	(17962,783,'ProjectAchievement-description__show','0',0),
	(17963,783,'ObjectStatus_project_planned__show','0',0),
	(17964,783,'ObjectStatus_project_ongoing__show','0',0),
	(17965,783,'ObjectStatus_project_closed__show','0',0),
	(17966,783,'ObjectStatus_project_expired__show','0',0),
	(17967,783,'ObjectStatus_project_expired_tasks__show','0',0),
	(17968,783,'created__show','0',0),
	(17969,783,'modified__show','0',0),
	(17970,783,'comment_message__show','0',0),
	(17971,783,'last_comment__show','0',0),
	(17972,783,'attachment_filename__show','0',0),
	(17973,783,'last_attachment__show','0',0),
	(17974,783,'_limit','-1',0),
	(17975,783,'_order_column','index',0),
	(17976,783,'_order_direction','ASC',0),
	(17977,783,'modified','_minus_1_days_',0),
	(17978,783,'modified__comp_type','1',0),
	(17979,784,'advanced_filter','1',0),
	(17980,784,'id__show','0',0),
	(17981,784,'index__show','1',0),
	(17982,784,'short_description__show','0',0),
	(17983,784,'Owner__show','0',0),
	(17984,784,'Collaborator__show','0',0),
	(17985,784,'Tag-title__show','0',0),
	(17986,784,'published_date__show','0',0),
	(17987,784,'next_review_date__show','0',0),
	(17988,784,'status__show','0',0),
	(17989,784,'ObjectStatus_expired_reviews__show','0',0),
	(17990,784,'asset_label_id__show','0',0),
	(17991,784,'security_policy_document_type_id__show','0',0),
	(17992,784,'version__show','0',0),
	(17993,784,'use_attachments__show','0',0),
	(17994,784,'permission__show','0',0),
	(17995,784,'ldap_connector_id__show','0',0),
	(17996,784,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(17997,784,'CompliancePackage-package_id__show','0',0),
	(17998,784,'CompliancePackage-name__show','0',0),
	(17999,784,'CompliancePackageItem-item_id__show','0',0),
	(18000,784,'CompliancePackageItem-name__show','0',0),
	(18001,784,'RiskTreatment__show','0',0),
	(18002,784,'ThirdPartyRiskTreatment__show','0',0),
	(18003,784,'BusinessContinuityTreatment__show','0',0),
	(18004,784,'DataAssetInstance-asset_id__show','0',0),
	(18005,784,'DataAsset__show','0',0),
	(18006,784,'DataAsset-data_asset_status_id__show','0',0),
	(18007,784,'SecurityService__show','0',0),
	(18008,784,'SecurityService-objective__show','0',0),
	(18009,784,'Project__show','0',0),
	(18010,784,'ProjectAchievement-description__show','0',0),
	(18011,784,'ObjectStatus_project_planned__show','0',0),
	(18012,784,'ObjectStatus_project_ongoing__show','0',0),
	(18013,784,'ObjectStatus_project_closed__show','0',0),
	(18014,784,'ObjectStatus_project_expired__show','0',0),
	(18015,784,'ObjectStatus_project_expired_tasks__show','0',0),
	(18016,784,'created__show','0',0),
	(18017,784,'modified__show','0',0),
	(18018,784,'comment_message__show','0',0),
	(18019,784,'last_comment__show','0',0),
	(18020,784,'attachment_filename__show','0',0),
	(18021,784,'last_attachment__show','0',0),
	(18022,784,'_limit','-1',0),
	(18023,784,'_order_column','index',0),
	(18024,784,'_order_direction','ASC',0),
	(18025,784,'created','_minus_1_days_',0),
	(18026,784,'created__comp_type','1',0),
	(18027,785,'advanced_filter','1',0),
	(18028,785,'index__show','1',0),
	(18029,785,'short_description__show','1',0),
	(18030,785,'Owner__show','1',0),
	(18031,785,'Collaborator__show','1',0),
	(18032,785,'published_date__show','1',0),
	(18033,785,'next_review_date__show','1',0),
	(18034,785,'asset_label_id__show','1',0),
	(18035,785,'security_policy_document_type_id__show','1',0),
	(18036,785,'version__show','1',0),
	(18037,785,'_limit','-1',0),
	(18038,785,'_order_column','created',0),
	(18039,785,'_order_direction','DESC',0),
	(18040,786,'advanced_filter','1',0),
	(18041,786,'index__show','1',0),
	(18042,786,'short_description__show','1',0),
	(18043,786,'Owner__show','1',0),
	(18044,786,'Collaborator__show','1',0),
	(18045,786,'published_date__show','1',0),
	(18046,786,'next_review_date__show','1',0),
	(18047,786,'asset_label_id__show','1',0),
	(18048,786,'security_policy_document_type_id__show','1',0),
	(18049,786,'version__show','1',0),
	(18050,786,'_limit','-1',0),
	(18051,786,'_order_column','index',0),
	(18052,786,'_order_direction','ASC',0),
	(18053,786,'status','1',0),
	(18054,786,'status__comp_type','0',0),
	(18055,786,'ObjectStatus_expired_reviews','1',0),
	(18056,786,'ObjectStatus_expired_reviews__show','1',0),
	(18057,787,'advanced_filter','1',0),
	(18058,787,'id__show','0',0),
	(18059,787,'foreign_key__show','0',0),
	(18060,787,'planned_date__show','1',0),
	(18061,787,'actual_date__show','0',0),
	(18062,787,'Reviewer__show','0',0),
	(18063,787,'description__show','0',0),
	(18064,787,'completed__show','0',0),
	(18065,787,'ObjectStatus_expired__show','0',0),
	(18066,787,'ObjectStatus_current_review__show','0',0),
	(18067,787,'SecurityPolicy-next_review_date__show','0',0),
	(18068,787,'SecurityPolicy-security_policy_document_type_id__show','0',0),
	(18069,787,'version__show','0',0),
	(18070,787,'use_attachments__show','0',0),
	(18071,787,'url__show','0',0),
	(18072,787,'attachment__show','0',0),
	(18073,787,'created__show','0',0),
	(18074,787,'modified__show','0',0),
	(18075,787,'comment_message__show','1',0),
	(18076,787,'last_comment__show','0',0),
	(18077,787,'attachment_filename__show','0',0),
	(18078,787,'last_attachment__show','0',0),
	(18079,787,'_limit','-1',0),
	(18080,787,'_order_column','planned_date',0),
	(18081,787,'_order_direction','ASC',0),
	(18082,787,'last_comment','_minus_1_days_',0),
	(18083,787,'last_comment__comp_type','1',0),
	(18084,788,'advanced_filter','1',0),
	(18085,788,'id__show','0',0),
	(18086,788,'foreign_key__show','0',0),
	(18087,788,'planned_date__show','1',0),
	(18088,788,'actual_date__show','0',0),
	(18089,788,'Reviewer__show','0',0),
	(18090,788,'description__show','0',0),
	(18091,788,'completed__show','0',0),
	(18092,788,'ObjectStatus_expired__show','0',0),
	(18093,788,'ObjectStatus_current_review__show','0',0),
	(18094,788,'SecurityPolicy-next_review_date__show','0',0),
	(18095,788,'SecurityPolicy-security_policy_document_type_id__show','0',0),
	(18096,788,'version__show','0',0),
	(18097,788,'use_attachments__show','0',0),
	(18098,788,'url__show','0',0),
	(18099,788,'attachment__show','0',0),
	(18100,788,'created__show','0',0),
	(18101,788,'modified__show','0',0),
	(18102,788,'comment_message__show','0',0),
	(18103,788,'last_comment__show','0',0),
	(18104,788,'attachment_filename__show','1',0),
	(18105,788,'last_attachment__show','0',0),
	(18106,788,'_limit','-1',0),
	(18107,788,'_order_column','planned_date',0),
	(18108,788,'_order_direction','ASC',0),
	(18109,788,'last_attachment','_minus_1_days_',0),
	(18110,788,'last_attachment__comp_type','1',0),
	(18111,789,'advanced_filter','1',0),
	(18112,789,'id__show','0',0),
	(18113,789,'foreign_key__show','0',0),
	(18114,789,'planned_date__show','1',0),
	(18115,789,'actual_date__show','0',0),
	(18116,789,'Reviewer__show','0',0),
	(18117,789,'description__show','0',0),
	(18118,789,'completed__show','0',0),
	(18119,789,'ObjectStatus_expired__show','0',0),
	(18120,789,'ObjectStatus_current_review__show','0',0),
	(18121,789,'SecurityPolicy-next_review_date__show','0',0),
	(18122,789,'SecurityPolicy-security_policy_document_type_id__show','0',0),
	(18123,789,'version__show','0',0),
	(18124,789,'use_attachments__show','0',0),
	(18125,789,'url__show','0',0),
	(18126,789,'attachment__show','0',0),
	(18127,789,'created__show','0',0),
	(18128,789,'modified__show','0',0),
	(18129,789,'comment_message__show','0',0),
	(18130,789,'last_comment__show','0',0),
	(18131,789,'attachment_filename__show','0',0),
	(18132,789,'last_attachment__show','0',0),
	(18133,789,'_limit','-1',0),
	(18134,789,'_order_column','planned_date',0),
	(18135,789,'_order_direction','ASC',0),
	(18136,789,'modified','_minus_1_days_',0),
	(18137,789,'modified__comp_type','1',0),
	(18138,790,'advanced_filter','1',0),
	(18139,790,'id__show','0',0),
	(18140,790,'foreign_key__show','0',0),
	(18141,790,'planned_date__show','1',0),
	(18142,790,'actual_date__show','0',0),
	(18143,790,'Reviewer__show','0',0),
	(18144,790,'description__show','0',0),
	(18145,790,'completed__show','0',0),
	(18146,790,'ObjectStatus_expired__show','0',0),
	(18147,790,'ObjectStatus_current_review__show','0',0),
	(18148,790,'SecurityPolicy-next_review_date__show','0',0),
	(18149,790,'SecurityPolicy-security_policy_document_type_id__show','0',0),
	(18150,790,'version__show','0',0),
	(18151,790,'use_attachments__show','0',0),
	(18152,790,'url__show','0',0),
	(18153,790,'attachment__show','0',0),
	(18154,790,'created__show','0',0),
	(18155,790,'modified__show','0',0),
	(18156,790,'comment_message__show','0',0),
	(18157,790,'last_comment__show','0',0),
	(18158,790,'attachment_filename__show','0',0),
	(18159,790,'last_attachment__show','0',0),
	(18160,790,'_limit','-1',0),
	(18161,790,'_order_column','planned_date',0),
	(18162,790,'_order_direction','ASC',0),
	(18163,790,'created','_minus_1_days_',0),
	(18164,790,'created__comp_type','1',0),
	(18165,791,'advanced_filter','1',0),
	(18166,791,'foreign_key__show','1',0),
	(18167,791,'planned_date__show','1',0),
	(18168,791,'actual_date__show','1',0),
	(18169,791,'Reviewer__show','1',0),
	(18170,791,'description__show','1',0),
	(18171,791,'SecurityPolicy-next_review_date__show','1',0),
	(18172,791,'SecurityPolicy-security_policy_document_type_id__show','1',0),
	(18173,791,'version__show','1',0),
	(18174,791,'use_attachments__show','1',0),
	(18175,791,'_limit','-1',0),
	(18176,791,'_order_column','created',0),
	(18177,791,'_order_direction','DESC',0),
	(18178,792,'advanced_filter','1',0),
	(18179,792,'foreign_key__show','1',0),
	(18180,792,'planned_date__show','1',0),
	(18181,792,'actual_date__show','1',0),
	(18182,792,'Reviewer__show','1',0),
	(18183,792,'description__show','1',0),
	(18184,792,'SecurityPolicy-next_review_date__show','1',0),
	(18185,792,'SecurityPolicy-security_policy_document_type_id__show','1',0),
	(18186,792,'version__show','1',0),
	(18187,792,'use_attachments__show','1',0),
	(18188,792,'_limit','-1',0),
	(18189,792,'_order_column','planned_date',0),
	(18190,792,'_order_direction','ASC',0),
	(18191,792,'planned_date','_plus_14_days_',0),
	(18192,792,'planned_date__comp_type','2',0),
	(18193,792,'planned_date__use_calendar','0',0),
	(18194,792,'result__comp_type','0',0),
	(18195,792,'result','_null_',0),
	(18196,792,'completed','0',0),
	(18197,792,'completed__comp_type','5',0),
	(18198,793,'advanced_filter','1',0),
	(18199,793,'id__show','0',0),
	(18200,793,'title__show','1',0),
	(18201,793,'description__show','0',0),
	(18202,793,'Tag-title__show','0',0),
	(18203,793,'Stakeholder__show','0',0),
	(18204,793,'Owner__show','0',0),
	(18205,793,'review__show','0',0),
	(18206,793,'ObjectStatus_risk_above_appetite__show','0',0),
	(18207,793,'ObjectStatus_expired_reviews__show','0',0),
	(18208,793,'RiskClassification__show','0',0),
	(18209,793,'risk_score__show','0',0),
	(18210,793,'Asset__show','0',0),
	(18211,793,'Asset-BusinessUnit__show','0',0),
	(18212,793,'Threat__show','0',0),
	(18213,793,'threats__show','0',0),
	(18214,793,'Vulnerability__show','0',0),
	(18215,793,'vulnerabilities__show','0',0),
	(18216,793,'RiskClassificationTreatment__show','0',0),
	(18217,793,'residual_risk__show','0',0),
	(18218,793,'risk_mitigation_strategy_id__show','0',0),
	(18219,793,'RiskException-id__show','0',0),
	(18220,793,'SecurityService-id__show','0',0),
	(18221,793,'Project-id__show','0',0),
	(18222,793,'SecurityPolicyTreatment-id__show','0',0),
	(18223,793,'DataAssetInstance-asset_id__show','0',0),
	(18224,793,'DataAsset__show','0',0),
	(18225,793,'DataAsset-data_asset_status_id__show','0',0),
	(18226,793,'SecurityIncident__show','0',0),
	(18227,793,'SecurityIncident-security_incident_status_id__show','0',0),
	(18228,793,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(18229,793,'CompliancePackage-package_id__show','0',0),
	(18230,793,'CompliancePackage-name__show','0',0),
	(18231,793,'CompliancePackageItem-item_id__show','0',0),
	(18232,793,'CompliancePackageItem-name__show','0',0),
	(18233,793,'Project__show','0',0),
	(18234,793,'ProjectAchievement-description__show','0',0),
	(18235,793,'ObjectStatus_project_planned__show','0',0),
	(18236,793,'ObjectStatus_project_ongoing__show','0',0),
	(18237,793,'ObjectStatus_project_closed__show','0',0),
	(18238,793,'ObjectStatus_project_expired__show','0',0),
	(18239,793,'ObjectStatus_project_expired_tasks__show','0',0),
	(18240,793,'SecurityService__show','0',0),
	(18241,793,'SecurityService-objective__show','0',0),
	(18242,793,'ObjectStatus_audits_last_not_passed__show','0',0),
	(18243,793,'ObjectStatus_audits_last_missing__show','0',0),
	(18244,793,'ObjectStatus_control_with_issues__show','0',0),
	(18245,793,'ObjectStatus_maintenances_last_missing__show','0',0),
	(18246,793,'SecurityPolicyTreatment__show','0',0),
	(18247,793,'RiskException__show','0',0),
	(18248,793,'RiskException-description__show','0',0),
	(18249,793,'RiskException-status__show','0',0),
	(18250,793,'ObjectStatus_risk_exception_expired__show','0',0),
	(18251,793,'created__show','0',0),
	(18252,793,'modified__show','0',0),
	(18253,793,'comment_message__show','1',0),
	(18254,793,'last_comment__show','0',0),
	(18255,793,'attachment_filename__show','0',0),
	(18256,793,'last_attachment__show','0',0),
	(18257,793,'_limit','-1',0),
	(18258,793,'_order_column','title',0),
	(18259,793,'_order_direction','ASC',0),
	(18260,793,'last_comment','_minus_1_days_',0),
	(18261,793,'last_comment__comp_type','1',0),
	(18262,794,'advanced_filter','1',0),
	(18263,794,'id__show','0',0),
	(18264,794,'title__show','1',0),
	(18265,794,'description__show','0',0),
	(18266,794,'Tag-title__show','0',0),
	(18267,794,'Stakeholder__show','0',0),
	(18268,794,'Owner__show','0',0),
	(18269,794,'review__show','0',0),
	(18270,794,'ObjectStatus_risk_above_appetite__show','0',0),
	(18271,794,'ObjectStatus_expired_reviews__show','0',0),
	(18272,794,'RiskClassification__show','0',0),
	(18273,794,'risk_score__show','0',0),
	(18274,794,'Asset__show','0',0),
	(18275,794,'Asset-BusinessUnit__show','0',0),
	(18276,794,'Threat__show','0',0),
	(18277,794,'threats__show','0',0),
	(18278,794,'Vulnerability__show','0',0),
	(18279,794,'vulnerabilities__show','0',0),
	(18280,794,'RiskClassificationTreatment__show','0',0),
	(18281,794,'residual_risk__show','0',0),
	(18282,794,'risk_mitigation_strategy_id__show','0',0),
	(18283,794,'RiskException-id__show','0',0),
	(18284,794,'SecurityService-id__show','0',0),
	(18285,794,'Project-id__show','0',0),
	(18286,794,'SecurityPolicyTreatment-id__show','0',0),
	(18287,794,'DataAssetInstance-asset_id__show','0',0),
	(18288,794,'DataAsset__show','0',0),
	(18289,794,'DataAsset-data_asset_status_id__show','0',0),
	(18290,794,'SecurityIncident__show','0',0),
	(18291,794,'SecurityIncident-security_incident_status_id__show','0',0),
	(18292,794,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(18293,794,'CompliancePackage-package_id__show','0',0),
	(18294,794,'CompliancePackage-name__show','0',0),
	(18295,794,'CompliancePackageItem-item_id__show','0',0),
	(18296,794,'CompliancePackageItem-name__show','0',0),
	(18297,794,'Project__show','0',0),
	(18298,794,'ProjectAchievement-description__show','0',0),
	(18299,794,'ObjectStatus_project_planned__show','0',0),
	(18300,794,'ObjectStatus_project_ongoing__show','0',0),
	(18301,794,'ObjectStatus_project_closed__show','0',0),
	(18302,794,'ObjectStatus_project_expired__show','0',0),
	(18303,794,'ObjectStatus_project_expired_tasks__show','0',0),
	(18304,794,'SecurityService__show','0',0),
	(18305,794,'SecurityService-objective__show','0',0),
	(18306,794,'ObjectStatus_audits_last_not_passed__show','0',0),
	(18307,794,'ObjectStatus_audits_last_missing__show','0',0),
	(18308,794,'ObjectStatus_control_with_issues__show','0',0),
	(18309,794,'ObjectStatus_maintenances_last_missing__show','0',0),
	(18310,794,'SecurityPolicyTreatment__show','0',0),
	(18311,794,'RiskException__show','0',0),
	(18312,794,'RiskException-description__show','0',0),
	(18313,794,'RiskException-status__show','0',0),
	(18314,794,'ObjectStatus_risk_exception_expired__show','0',0),
	(18315,794,'created__show','0',0),
	(18316,794,'modified__show','0',0),
	(18317,794,'comment_message__show','0',0),
	(18318,794,'last_comment__show','0',0),
	(18319,794,'attachment_filename__show','1',0),
	(18320,794,'last_attachment__show','0',0),
	(18321,794,'_limit','-1',0),
	(18322,794,'_order_column','title',0),
	(18323,794,'_order_direction','ASC',0),
	(18324,794,'last_attachment','_minus_1_days_',0),
	(18325,794,'last_attachment__comp_type','1',0),
	(18326,795,'advanced_filter','1',0),
	(18327,795,'id__show','0',0),
	(18328,795,'title__show','1',0),
	(18329,795,'description__show','0',0),
	(18330,795,'Tag-title__show','0',0),
	(18331,795,'Stakeholder__show','0',0),
	(18332,795,'Owner__show','0',0),
	(18333,795,'review__show','0',0),
	(18334,795,'ObjectStatus_risk_above_appetite__show','0',0),
	(18335,795,'ObjectStatus_expired_reviews__show','0',0),
	(18336,795,'RiskClassification__show','0',0),
	(18337,795,'risk_score__show','0',0),
	(18338,795,'Asset__show','0',0),
	(18339,795,'Asset-BusinessUnit__show','0',0),
	(18340,795,'Threat__show','0',0),
	(18341,795,'threats__show','0',0),
	(18342,795,'Vulnerability__show','0',0),
	(18343,795,'vulnerabilities__show','0',0),
	(18344,795,'RiskClassificationTreatment__show','0',0),
	(18345,795,'residual_risk__show','0',0),
	(18346,795,'risk_mitigation_strategy_id__show','0',0),
	(18347,795,'RiskException-id__show','0',0),
	(18348,795,'SecurityService-id__show','0',0),
	(18349,795,'Project-id__show','0',0),
	(18350,795,'SecurityPolicyTreatment-id__show','0',0),
	(18351,795,'DataAssetInstance-asset_id__show','0',0),
	(18352,795,'DataAsset__show','0',0),
	(18353,795,'DataAsset-data_asset_status_id__show','0',0),
	(18354,795,'SecurityIncident__show','0',0),
	(18355,795,'SecurityIncident-security_incident_status_id__show','0',0),
	(18356,795,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(18357,795,'CompliancePackage-package_id__show','0',0),
	(18358,795,'CompliancePackage-name__show','0',0),
	(18359,795,'CompliancePackageItem-item_id__show','0',0),
	(18360,795,'CompliancePackageItem-name__show','0',0),
	(18361,795,'Project__show','0',0),
	(18362,795,'ProjectAchievement-description__show','0',0),
	(18363,795,'ObjectStatus_project_planned__show','0',0),
	(18364,795,'ObjectStatus_project_ongoing__show','0',0),
	(18365,795,'ObjectStatus_project_closed__show','0',0),
	(18366,795,'ObjectStatus_project_expired__show','0',0),
	(18367,795,'ObjectStatus_project_expired_tasks__show','0',0),
	(18368,795,'SecurityService__show','0',0),
	(18369,795,'SecurityService-objective__show','0',0),
	(18370,795,'ObjectStatus_audits_last_not_passed__show','0',0),
	(18371,795,'ObjectStatus_audits_last_missing__show','0',0),
	(18372,795,'ObjectStatus_control_with_issues__show','0',0),
	(18373,795,'ObjectStatus_maintenances_last_missing__show','0',0),
	(18374,795,'SecurityPolicyTreatment__show','0',0),
	(18375,795,'RiskException__show','0',0),
	(18376,795,'RiskException-description__show','0',0),
	(18377,795,'RiskException-status__show','0',0),
	(18378,795,'ObjectStatus_risk_exception_expired__show','0',0),
	(18379,795,'created__show','0',0),
	(18380,795,'modified__show','0',0),
	(18381,795,'comment_message__show','0',0),
	(18382,795,'last_comment__show','0',0),
	(18383,795,'attachment_filename__show','0',0),
	(18384,795,'last_attachment__show','0',0),
	(18385,795,'_limit','-1',0),
	(18386,795,'_order_column','title',0),
	(18387,795,'_order_direction','ASC',0),
	(18388,795,'modified','_minus_1_days_',0),
	(18389,795,'modified__comp_type','1',0),
	(18390,796,'advanced_filter','1',0),
	(18391,796,'id__show','0',0),
	(18392,796,'title__show','1',0),
	(18393,796,'description__show','0',0),
	(18394,796,'Tag-title__show','0',0),
	(18395,796,'Stakeholder__show','0',0),
	(18396,796,'Owner__show','0',0),
	(18397,796,'review__show','0',0),
	(18398,796,'ObjectStatus_risk_above_appetite__show','0',0),
	(18399,796,'ObjectStatus_expired_reviews__show','0',0),
	(18400,796,'RiskClassification__show','0',0),
	(18401,796,'risk_score__show','0',0),
	(18402,796,'Asset__show','0',0),
	(18403,796,'Asset-BusinessUnit__show','0',0),
	(18404,796,'Threat__show','0',0),
	(18405,796,'threats__show','0',0),
	(18406,796,'Vulnerability__show','0',0),
	(18407,796,'vulnerabilities__show','0',0),
	(18408,796,'RiskClassificationTreatment__show','0',0),
	(18409,796,'residual_risk__show','0',0),
	(18410,796,'risk_mitigation_strategy_id__show','0',0),
	(18411,796,'RiskException-id__show','0',0),
	(18412,796,'SecurityService-id__show','0',0),
	(18413,796,'Project-id__show','0',0),
	(18414,796,'SecurityPolicyTreatment-id__show','0',0),
	(18415,796,'DataAssetInstance-asset_id__show','0',0),
	(18416,796,'DataAsset__show','0',0),
	(18417,796,'DataAsset-data_asset_status_id__show','0',0),
	(18418,796,'SecurityIncident__show','0',0),
	(18419,796,'SecurityIncident-security_incident_status_id__show','0',0),
	(18420,796,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(18421,796,'CompliancePackage-package_id__show','0',0),
	(18422,796,'CompliancePackage-name__show','0',0),
	(18423,796,'CompliancePackageItem-item_id__show','0',0),
	(18424,796,'CompliancePackageItem-name__show','0',0),
	(18425,796,'Project__show','0',0),
	(18426,796,'ProjectAchievement-description__show','0',0),
	(18427,796,'ObjectStatus_project_planned__show','0',0),
	(18428,796,'ObjectStatus_project_ongoing__show','0',0),
	(18429,796,'ObjectStatus_project_closed__show','0',0),
	(18430,796,'ObjectStatus_project_expired__show','0',0),
	(18431,796,'ObjectStatus_project_expired_tasks__show','0',0),
	(18432,796,'SecurityService__show','0',0),
	(18433,796,'SecurityService-objective__show','0',0),
	(18434,796,'ObjectStatus_audits_last_not_passed__show','0',0),
	(18435,796,'ObjectStatus_audits_last_missing__show','0',0),
	(18436,796,'ObjectStatus_control_with_issues__show','0',0),
	(18437,796,'ObjectStatus_maintenances_last_missing__show','0',0),
	(18438,796,'SecurityPolicyTreatment__show','0',0),
	(18439,796,'RiskException__show','0',0),
	(18440,796,'RiskException-description__show','0',0),
	(18441,796,'RiskException-status__show','0',0),
	(18442,796,'ObjectStatus_risk_exception_expired__show','0',0),
	(18443,796,'created__show','0',0),
	(18444,796,'modified__show','0',0),
	(18445,796,'comment_message__show','0',0),
	(18446,796,'last_comment__show','0',0),
	(18447,796,'attachment_filename__show','0',0),
	(18448,796,'last_attachment__show','0',0),
	(18449,796,'_limit','-1',0),
	(18450,796,'_order_column','title',0),
	(18451,796,'_order_direction','ASC',0),
	(18452,796,'created','_minus_1_days_',0),
	(18453,796,'created__comp_type','1',0),
	(18454,797,'advanced_filter','1',0),
	(18455,797,'title__show','1',0),
	(18456,797,'description__show','1',0),
	(18457,797,'Stakeholder__show','1',0),
	(18458,797,'Owner__show','1',0),
	(18459,797,'review__show','1',0),
	(18460,797,'ObjectStatus_risk_above_appetite__show','1',0),
	(18461,797,'ObjectStatus_expired_reviews__show','1',0),
	(18462,797,'RiskClassification__show','1',0),
	(18463,797,'risk_score__show','1',0),
	(18464,797,'Asset__show','1',0),
	(18465,797,'RiskClassificationTreatment__show','1',0),
	(18466,797,'residual_risk__show','1',0),
	(18467,797,'risk_mitigation_strategy_id__show','1',0),
	(18468,797,'_limit','-1',0),
	(18469,797,'_order_column','created',0),
	(18470,797,'_order_direction','DESC',0),
	(18471,798,'advanced_filter','1',0),
	(18472,798,'title__show','1',0),
	(18473,798,'description__show','1',0),
	(18474,798,'Stakeholder__show','1',0),
	(18475,798,'Owner__show','1',0),
	(18476,798,'review__show','1',0),
	(18477,798,'ObjectStatus_risk_above_appetite__show','1',0),
	(18478,798,'ObjectStatus_expired_reviews__show','1',0),
	(18479,798,'RiskClassification__show','1',0),
	(18480,798,'risk_score__show','1',0),
	(18481,798,'Asset__show','1',0),
	(18482,798,'RiskClassificationTreatment__show','1',0),
	(18483,798,'residual_risk__show','1',0),
	(18484,798,'risk_mitigation_strategy_id__show','1',0),
	(18485,798,'_limit','-1',0),
	(18486,798,'_order_column','title',0),
	(18487,798,'_order_direction','ASC',0),
	(18488,798,'ObjectStatus_expired','1',0),
	(18489,798,'ObjectStatus_expired__show','1',0),
	(18490,799,'advanced_filter','1',0),
	(18491,799,'id__show','0',0),
	(18492,799,'BusinessUnit__show','0',0),
	(18493,799,'name__show','1',0),
	(18494,799,'description__show','0',0),
	(18495,799,'asset_label_id__show','0',0),
	(18496,799,'asset_media_type_id__show','0',0),
	(18497,799,'Legal__show','0',0),
	(18498,799,'review__show','0',0),
	(18499,799,'RelatedAssets__show','0',0),
	(18500,799,'ObjectStatus_expired_reviews__show','0',0),
	(18501,799,'AssetOwner__show','0',0),
	(18502,799,'AssetGuardian__show','0',0),
	(18503,799,'AssetUser__show','0',0),
	(18504,799,'AssetClassification__show','0',0),
	(18505,799,'SecurityIncident__show','0',0),
	(18506,799,'SecurityIncident-security_incident_status_id__show','0',0),
	(18507,799,'Risk__show','0',0),
	(18508,799,'ThirdPartyRisk__show','0',0),
	(18509,799,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(18510,799,'CompliancePackage-package_id__show','0',0),
	(18511,799,'CompliancePackage-name__show','0',0),
	(18512,799,'CompliancePackageItem-item_id__show','0',0),
	(18513,799,'CompliancePackageItem-name__show','0',0),
	(18514,799,'DataAssetInstance-DataAsset__show','0',0),
	(18515,799,'DataAsset-data_asset_status_id__show','0',0),
	(18516,799,'DataAssetSetting-gdpr_enabled__show','0',0),
	(18517,799,'DataAssetInstance-incomplete_gdpr_analysis__show','0',0),
	(18518,799,'created__show','0',0),
	(18519,799,'modified__show','0',0),
	(18520,799,'comment_message__show','1',0),
	(18521,799,'last_comment__show','0',0),
	(18522,799,'attachment_filename__show','0',0),
	(18523,799,'last_attachment__show','0',0),
	(18524,799,'_limit','-1',0),
	(18525,799,'_order_column','name',0),
	(18526,799,'_order_direction','ASC',0),
	(18527,799,'last_comment','_minus_1_days_',0),
	(18528,799,'last_comment__comp_type','1',0),
	(18529,800,'advanced_filter','1',0),
	(18530,800,'id__show','0',0),
	(18531,800,'BusinessUnit__show','0',0),
	(18532,800,'name__show','1',0),
	(18533,800,'description__show','0',0),
	(18534,800,'asset_label_id__show','0',0),
	(18535,800,'asset_media_type_id__show','0',0),
	(18536,800,'Legal__show','0',0),
	(18537,800,'review__show','0',0),
	(18538,800,'RelatedAssets__show','0',0),
	(18539,800,'ObjectStatus_expired_reviews__show','0',0),
	(18540,800,'AssetOwner__show','0',0),
	(18541,800,'AssetGuardian__show','0',0),
	(18542,800,'AssetUser__show','0',0),
	(18543,800,'AssetClassification__show','0',0),
	(18544,800,'SecurityIncident__show','0',0),
	(18545,800,'SecurityIncident-security_incident_status_id__show','0',0),
	(18546,800,'Risk__show','0',0),
	(18547,800,'ThirdPartyRisk__show','0',0),
	(18548,800,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(18549,800,'CompliancePackage-package_id__show','0',0),
	(18550,800,'CompliancePackage-name__show','0',0),
	(18551,800,'CompliancePackageItem-item_id__show','0',0),
	(18552,800,'CompliancePackageItem-name__show','0',0),
	(18553,800,'DataAssetInstance-DataAsset__show','0',0),
	(18554,800,'DataAsset-data_asset_status_id__show','0',0),
	(18555,800,'DataAssetSetting-gdpr_enabled__show','0',0),
	(18556,800,'DataAssetInstance-incomplete_gdpr_analysis__show','0',0),
	(18557,800,'created__show','0',0),
	(18558,800,'modified__show','0',0),
	(18559,800,'comment_message__show','0',0),
	(18560,800,'last_comment__show','0',0),
	(18561,800,'attachment_filename__show','1',0),
	(18562,800,'last_attachment__show','0',0),
	(18563,800,'_limit','-1',0),
	(18564,800,'_order_column','name',0),
	(18565,800,'_order_direction','ASC',0),
	(18566,800,'last_attachment','_minus_1_days_',0),
	(18567,800,'last_attachment__comp_type','1',0),
	(18568,801,'advanced_filter','1',0),
	(18569,801,'id__show','0',0),
	(18570,801,'BusinessUnit__show','0',0),
	(18571,801,'name__show','1',0),
	(18572,801,'description__show','0',0),
	(18573,801,'asset_label_id__show','0',0),
	(18574,801,'asset_media_type_id__show','0',0),
	(18575,801,'Legal__show','0',0),
	(18576,801,'review__show','0',0),
	(18577,801,'RelatedAssets__show','0',0),
	(18578,801,'ObjectStatus_expired_reviews__show','0',0),
	(18579,801,'AssetOwner__show','0',0),
	(18580,801,'AssetGuardian__show','0',0),
	(18581,801,'AssetUser__show','0',0),
	(18582,801,'AssetClassification__show','0',0),
	(18583,801,'SecurityIncident__show','0',0),
	(18584,801,'SecurityIncident-security_incident_status_id__show','0',0),
	(18585,801,'Risk__show','0',0),
	(18586,801,'ThirdPartyRisk__show','0',0),
	(18587,801,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(18588,801,'CompliancePackage-package_id__show','0',0),
	(18589,801,'CompliancePackage-name__show','0',0),
	(18590,801,'CompliancePackageItem-item_id__show','0',0),
	(18591,801,'CompliancePackageItem-name__show','0',0),
	(18592,801,'DataAssetInstance-DataAsset__show','0',0),
	(18593,801,'DataAsset-data_asset_status_id__show','0',0),
	(18594,801,'DataAssetSetting-gdpr_enabled__show','0',0),
	(18595,801,'DataAssetInstance-incomplete_gdpr_analysis__show','0',0),
	(18596,801,'created__show','0',0),
	(18597,801,'modified__show','0',0),
	(18598,801,'comment_message__show','0',0),
	(18599,801,'last_comment__show','0',0),
	(18600,801,'attachment_filename__show','0',0),
	(18601,801,'last_attachment__show','0',0),
	(18602,801,'_limit','-1',0),
	(18603,801,'_order_column','name',0),
	(18604,801,'_order_direction','ASC',0),
	(18605,801,'modified','_minus_1_days_',0),
	(18606,801,'modified__comp_type','1',0),
	(18607,802,'advanced_filter','1',0),
	(18608,802,'id__show','0',0),
	(18609,802,'BusinessUnit__show','0',0),
	(18610,802,'name__show','1',0),
	(18611,802,'description__show','0',0),
	(18612,802,'asset_label_id__show','0',0),
	(18613,802,'asset_media_type_id__show','0',0),
	(18614,802,'Legal__show','0',0),
	(18615,802,'review__show','0',0),
	(18616,802,'RelatedAssets__show','0',0),
	(18617,802,'ObjectStatus_expired_reviews__show','0',0),
	(18618,802,'AssetOwner__show','0',0),
	(18619,802,'AssetGuardian__show','0',0),
	(18620,802,'AssetUser__show','0',0),
	(18621,802,'AssetClassification__show','0',0),
	(18622,802,'SecurityIncident__show','0',0),
	(18623,802,'SecurityIncident-security_incident_status_id__show','0',0),
	(18624,802,'Risk__show','0',0),
	(18625,802,'ThirdPartyRisk__show','0',0),
	(18626,802,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(18627,802,'CompliancePackage-package_id__show','0',0),
	(18628,802,'CompliancePackage-name__show','0',0),
	(18629,802,'CompliancePackageItem-item_id__show','0',0),
	(18630,802,'CompliancePackageItem-name__show','0',0),
	(18631,802,'DataAssetInstance-DataAsset__show','0',0),
	(18632,802,'DataAsset-data_asset_status_id__show','0',0),
	(18633,802,'DataAssetSetting-gdpr_enabled__show','0',0),
	(18634,802,'DataAssetInstance-incomplete_gdpr_analysis__show','0',0),
	(18635,802,'created__show','0',0),
	(18636,802,'modified__show','0',0),
	(18637,802,'comment_message__show','0',0),
	(18638,802,'last_comment__show','0',0),
	(18639,802,'attachment_filename__show','0',0),
	(18640,802,'last_attachment__show','0',0),
	(18641,802,'_limit','-1',0),
	(18642,802,'_order_column','name',0),
	(18643,802,'_order_direction','ASC',0),
	(18644,802,'created','_minus_1_days_',0),
	(18645,802,'created__comp_type','1',0),
	(18646,803,'advanced_filter','1',0),
	(18647,803,'BusinessUnit__show','1',0),
	(18648,803,'name__show','1',0),
	(18649,803,'description__show','1',0),
	(18650,803,'asset_label_id__show','1',0),
	(18651,803,'asset_media_type_id__show','1',0),
	(18652,803,'Legal__show','1',0),
	(18653,803,'review__show','1',0),
	(18654,803,'AssetOwner__show','1',0),
	(18655,803,'AssetGuardian__show','1',0),
	(18656,803,'AssetUser__show','1',0),
	(18657,803,'_limit','-1',0),
	(18658,803,'_order_column','created',0),
	(18659,803,'_order_direction','DESC',0),
	(18660,804,'advanced_filter','1',0),
	(18661,804,'BusinessUnit__show','1',0),
	(18662,804,'name__show','1',0),
	(18663,804,'description__show','1',0),
	(18664,804,'asset_label_id__show','1',0),
	(18665,804,'asset_media_type_id__show','1',0),
	(18666,804,'Legal__show','1',0),
	(18667,804,'review__show','1',0),
	(18668,804,'AssetOwner__show','1',0),
	(18669,804,'AssetGuardian__show','1',0),
	(18670,804,'AssetUser__show','1',0),
	(18671,804,'_limit','-1',0),
	(18672,804,'_order_column','name',0),
	(18673,804,'_order_direction','ASC',0),
	(18674,804,'ObjectStatus_expired_reviews','1',0),
	(18675,804,'ObjectStatus_expired_reviews__show','1',0),
	(18676,805,'advanced_filter','1',0),
	(18677,805,'id__show','0',0),
	(18678,805,'foreign_key__show','0',0),
	(18679,805,'planned_date__show','1',0),
	(18680,805,'actual_date__show','0',0),
	(18681,805,'Reviewer__show','0',0),
	(18682,805,'description__show','0',0),
	(18683,805,'completed__show','0',0),
	(18684,805,'ObjectStatus_expired__show','0',0),
	(18685,805,'ObjectStatus_current_review__show','0',0),
	(18686,805,'created__show','0',0),
	(18687,805,'modified__show','0',0),
	(18688,805,'comment_message__show','1',0),
	(18689,805,'last_comment__show','0',0),
	(18690,805,'attachment_filename__show','0',0),
	(18691,805,'last_attachment__show','0',0),
	(18692,805,'_limit','-1',0),
	(18693,805,'_order_column','planned_date',0),
	(18694,805,'_order_direction','ASC',0),
	(18695,805,'last_comment','_minus_1_days_',0),
	(18696,805,'last_comment__comp_type','1',0),
	(18697,806,'advanced_filter','1',0),
	(18698,806,'id__show','0',0),
	(18699,806,'foreign_key__show','0',0),
	(18700,806,'planned_date__show','1',0),
	(18701,806,'actual_date__show','0',0),
	(18702,806,'Reviewer__show','0',0),
	(18703,806,'description__show','0',0),
	(18704,806,'completed__show','0',0),
	(18705,806,'ObjectStatus_expired__show','0',0),
	(18706,806,'ObjectStatus_current_review__show','0',0),
	(18707,806,'created__show','0',0),
	(18708,806,'modified__show','0',0),
	(18709,806,'comment_message__show','0',0),
	(18710,806,'last_comment__show','0',0),
	(18711,806,'attachment_filename__show','1',0),
	(18712,806,'last_attachment__show','0',0),
	(18713,806,'_limit','-1',0),
	(18714,806,'_order_column','planned_date',0),
	(18715,806,'_order_direction','ASC',0),
	(18716,806,'last_attachment','_minus_1_days_',0),
	(18717,806,'last_attachment__comp_type','1',0),
	(18718,807,'advanced_filter','1',0),
	(18719,807,'id__show','0',0),
	(18720,807,'foreign_key__show','0',0),
	(18721,807,'planned_date__show','1',0),
	(18722,807,'actual_date__show','0',0),
	(18723,807,'Reviewer__show','0',0),
	(18724,807,'description__show','0',0),
	(18725,807,'completed__show','0',0),
	(18726,807,'ObjectStatus_expired__show','0',0),
	(18727,807,'ObjectStatus_current_review__show','0',0),
	(18728,807,'created__show','0',0),
	(18729,807,'modified__show','0',0),
	(18730,807,'comment_message__show','0',0),
	(18731,807,'last_comment__show','0',0),
	(18732,807,'attachment_filename__show','0',0),
	(18733,807,'last_attachment__show','0',0),
	(18734,807,'_limit','-1',0),
	(18735,807,'_order_column','planned_date',0),
	(18736,807,'_order_direction','ASC',0),
	(18737,807,'modified','_minus_1_days_',0),
	(18738,807,'modified__comp_type','1',0),
	(18739,808,'advanced_filter','1',0),
	(18740,808,'id__show','0',0),
	(18741,808,'foreign_key__show','0',0),
	(18742,808,'planned_date__show','1',0),
	(18743,808,'actual_date__show','0',0),
	(18744,808,'Reviewer__show','0',0),
	(18745,808,'description__show','0',0),
	(18746,808,'completed__show','0',0),
	(18747,808,'ObjectStatus_expired__show','0',0),
	(18748,808,'ObjectStatus_current_review__show','0',0),
	(18749,808,'created__show','0',0),
	(18750,808,'modified__show','0',0),
	(18751,808,'comment_message__show','0',0),
	(18752,808,'last_comment__show','0',0),
	(18753,808,'attachment_filename__show','0',0),
	(18754,808,'last_attachment__show','0',0),
	(18755,808,'_limit','-1',0),
	(18756,808,'_order_column','planned_date',0),
	(18757,808,'_order_direction','ASC',0),
	(18758,808,'created','_minus_1_days_',0),
	(18759,808,'created__comp_type','1',0),
	(18760,809,'advanced_filter','1',0),
	(18761,809,'foreign_key__show','1',0),
	(18762,809,'planned_date__show','1',0),
	(18763,809,'actual_date__show','1',0),
	(18764,809,'Reviewer__show','1',0),
	(18765,809,'description__show','1',0),
	(18766,809,'_limit','-1',0),
	(18767,809,'_order_column','created',0),
	(18768,809,'_order_direction','DESC',0),
	(18769,810,'advanced_filter','1',0),
	(18770,810,'foreign_key__show','1',0),
	(18771,810,'planned_date__show','1',0),
	(18772,810,'actual_date__show','1',0),
	(18773,810,'Reviewer__show','1',0),
	(18774,810,'description__show','1',0),
	(18775,810,'_limit','-1',0),
	(18776,810,'_order_column','planned_date',0),
	(18777,810,'_order_direction','ASC',0),
	(18778,810,'planned_date','_plus_14_days_',0),
	(18779,810,'planned_date__comp_type','2',0),
	(18780,810,'planned_date__use_calendar','0',0),
	(18781,810,'result__comp_type','0',0),
	(18782,810,'result','_null_',0),
	(18783,810,'completed','0',0),
	(18784,810,'completed__comp_type','5',0),
	(18785,811,'advanced_filter','1',0),
	(18786,811,'id__show','0',0),
	(18787,811,'foreign_key__show','0',0),
	(18788,811,'planned_date__show','1',0),
	(18789,811,'actual_date__show','0',0),
	(18790,811,'Reviewer__show','0',0),
	(18791,811,'description__show','0',0),
	(18792,811,'completed__show','0',0),
	(18793,811,'ObjectStatus_expired__show','0',0),
	(18794,811,'ObjectStatus_current_review__show','0',0),
	(18795,811,'created__show','0',0),
	(18796,811,'modified__show','0',0),
	(18797,811,'comment_message__show','1',0),
	(18798,811,'last_comment__show','0',0),
	(18799,811,'attachment_filename__show','0',0),
	(18800,811,'last_attachment__show','0',0),
	(18801,811,'_limit','-1',0),
	(18802,811,'_order_column','planned_date',0),
	(18803,811,'_order_direction','ASC',0),
	(18804,811,'last_comment','_minus_1_days_',0),
	(18805,811,'last_comment__comp_type','1',0),
	(18806,812,'advanced_filter','1',0),
	(18807,812,'id__show','0',0),
	(18808,812,'foreign_key__show','0',0),
	(18809,812,'planned_date__show','1',0),
	(18810,812,'actual_date__show','0',0),
	(18811,812,'Reviewer__show','0',0),
	(18812,812,'description__show','0',0),
	(18813,812,'completed__show','0',0),
	(18814,812,'ObjectStatus_expired__show','0',0),
	(18815,812,'ObjectStatus_current_review__show','0',0),
	(18816,812,'created__show','0',0),
	(18817,812,'modified__show','0',0),
	(18818,812,'comment_message__show','0',0),
	(18819,812,'last_comment__show','0',0),
	(18820,812,'attachment_filename__show','1',0),
	(18821,812,'last_attachment__show','0',0),
	(18822,812,'_limit','-1',0),
	(18823,812,'_order_column','planned_date',0),
	(18824,812,'_order_direction','ASC',0),
	(18825,812,'last_attachment','_minus_1_days_',0),
	(18826,812,'last_attachment__comp_type','1',0),
	(18827,813,'advanced_filter','1',0),
	(18828,813,'id__show','0',0),
	(18829,813,'foreign_key__show','0',0),
	(18830,813,'planned_date__show','1',0),
	(18831,813,'actual_date__show','0',0),
	(18832,813,'Reviewer__show','0',0),
	(18833,813,'description__show','0',0),
	(18834,813,'completed__show','0',0),
	(18835,813,'ObjectStatus_expired__show','0',0),
	(18836,813,'ObjectStatus_current_review__show','0',0),
	(18837,813,'created__show','0',0),
	(18838,813,'modified__show','0',0),
	(18839,813,'comment_message__show','0',0),
	(18840,813,'last_comment__show','0',0),
	(18841,813,'attachment_filename__show','0',0),
	(18842,813,'last_attachment__show','0',0),
	(18843,813,'_limit','-1',0),
	(18844,813,'_order_column','planned_date',0),
	(18845,813,'_order_direction','ASC',0),
	(18846,813,'modified','_minus_1_days_',0),
	(18847,813,'modified__comp_type','1',0),
	(18848,814,'advanced_filter','1',0),
	(18849,814,'id__show','0',0),
	(18850,814,'foreign_key__show','0',0),
	(18851,814,'planned_date__show','1',0),
	(18852,814,'actual_date__show','0',0),
	(18853,814,'Reviewer__show','0',0),
	(18854,814,'description__show','0',0),
	(18855,814,'completed__show','0',0),
	(18856,814,'ObjectStatus_expired__show','0',0),
	(18857,814,'ObjectStatus_current_review__show','0',0),
	(18858,814,'created__show','0',0),
	(18859,814,'modified__show','0',0),
	(18860,814,'comment_message__show','0',0),
	(18861,814,'last_comment__show','0',0),
	(18862,814,'attachment_filename__show','0',0),
	(18863,814,'last_attachment__show','0',0),
	(18864,814,'_limit','-1',0),
	(18865,814,'_order_column','planned_date',0),
	(18866,814,'_order_direction','ASC',0),
	(18867,814,'created','_minus_1_days_',0),
	(18868,814,'created__comp_type','1',0),
	(18869,815,'advanced_filter','1',0),
	(18870,815,'foreign_key__show','1',0),
	(18871,815,'planned_date__show','1',0),
	(18872,815,'actual_date__show','1',0),
	(18873,815,'Reviewer__show','1',0),
	(18874,815,'description__show','1',0),
	(18875,815,'_limit','-1',0),
	(18876,815,'_order_column','created',0),
	(18877,815,'_order_direction','DESC',0),
	(18878,816,'advanced_filter','1',0),
	(18879,816,'foreign_key__show','1',0),
	(18880,816,'planned_date__show','1',0),
	(18881,816,'actual_date__show','1',0),
	(18882,816,'Reviewer__show','1',0),
	(18883,816,'description__show','1',0),
	(18884,816,'_limit','-1',0),
	(18885,816,'_order_column','planned_date',0),
	(18886,816,'_order_direction','ASC',0),
	(18887,816,'planned_date','_plus_14_days_',0),
	(18888,816,'planned_date__comp_type','2',0),
	(18889,816,'planned_date__use_calendar','0',0),
	(18890,816,'result__comp_type','0',0),
	(18891,816,'result','_null_',0),
	(18892,816,'completed','0',0),
	(18893,816,'completed__comp_type','5',0),
	(18894,817,'advanced_filter','1',0),
	(18895,817,'id__show','0',0),
	(18896,817,'foreign_key__show','0',0),
	(18897,817,'planned_date__show','1',0),
	(18898,817,'actual_date__show','0',0),
	(18899,817,'Reviewer__show','0',0),
	(18900,817,'description__show','0',0),
	(18901,817,'completed__show','0',0),
	(18902,817,'ObjectStatus_expired__show','0',0),
	(18903,817,'ObjectStatus_current_review__show','0',0),
	(18904,817,'created__show','0',0),
	(18905,817,'modified__show','0',0),
	(18906,817,'comment_message__show','1',0),
	(18907,817,'last_comment__show','0',0),
	(18908,817,'attachment_filename__show','0',0),
	(18909,817,'last_attachment__show','0',0),
	(18910,817,'_limit','-1',0),
	(18911,817,'_order_column','planned_date',0),
	(18912,817,'_order_direction','ASC',0),
	(18913,817,'last_comment','_minus_1_days_',0),
	(18914,817,'last_comment__comp_type','1',0),
	(18915,818,'advanced_filter','1',0),
	(18916,818,'id__show','0',0),
	(18917,818,'foreign_key__show','0',0),
	(18918,818,'planned_date__show','1',0),
	(18919,818,'actual_date__show','0',0),
	(18920,818,'Reviewer__show','0',0),
	(18921,818,'description__show','0',0),
	(18922,818,'completed__show','0',0),
	(18923,818,'ObjectStatus_expired__show','0',0),
	(18924,818,'ObjectStatus_current_review__show','0',0),
	(18925,818,'created__show','0',0),
	(18926,818,'modified__show','0',0),
	(18927,818,'comment_message__show','0',0),
	(18928,818,'last_comment__show','0',0),
	(18929,818,'attachment_filename__show','1',0),
	(18930,818,'last_attachment__show','0',0),
	(18931,818,'_limit','-1',0),
	(18932,818,'_order_column','planned_date',0),
	(18933,818,'_order_direction','ASC',0),
	(18934,818,'last_attachment','_minus_1_days_',0),
	(18935,818,'last_attachment__comp_type','1',0),
	(18936,819,'advanced_filter','1',0),
	(18937,819,'id__show','0',0),
	(18938,819,'foreign_key__show','0',0),
	(18939,819,'planned_date__show','1',0),
	(18940,819,'actual_date__show','0',0),
	(18941,819,'Reviewer__show','0',0),
	(18942,819,'description__show','0',0),
	(18943,819,'completed__show','0',0),
	(18944,819,'ObjectStatus_expired__show','0',0),
	(18945,819,'ObjectStatus_current_review__show','0',0),
	(18946,819,'created__show','0',0),
	(18947,819,'modified__show','0',0),
	(18948,819,'comment_message__show','0',0),
	(18949,819,'last_comment__show','0',0),
	(18950,819,'attachment_filename__show','0',0),
	(18951,819,'last_attachment__show','0',0),
	(18952,819,'_limit','-1',0),
	(18953,819,'_order_column','planned_date',0),
	(18954,819,'_order_direction','ASC',0),
	(18955,819,'modified','_minus_1_days_',0),
	(18956,819,'modified__comp_type','1',0),
	(18957,820,'advanced_filter','1',0),
	(18958,820,'id__show','0',0),
	(18959,820,'foreign_key__show','0',0),
	(18960,820,'planned_date__show','1',0),
	(18961,820,'actual_date__show','0',0),
	(18962,820,'Reviewer__show','0',0),
	(18963,820,'description__show','0',0),
	(18964,820,'completed__show','0',0),
	(18965,820,'ObjectStatus_expired__show','0',0),
	(18966,820,'ObjectStatus_current_review__show','0',0),
	(18967,820,'created__show','0',0),
	(18968,820,'modified__show','0',0),
	(18969,820,'comment_message__show','0',0),
	(18970,820,'last_comment__show','0',0),
	(18971,820,'attachment_filename__show','0',0),
	(18972,820,'last_attachment__show','0',0),
	(18973,820,'_limit','-1',0),
	(18974,820,'_order_column','planned_date',0),
	(18975,820,'_order_direction','ASC',0),
	(18976,820,'created','_minus_1_days_',0),
	(18977,820,'created__comp_type','1',0),
	(18978,821,'advanced_filter','1',0),
	(18979,821,'foreign_key__show','1',0),
	(18980,821,'planned_date__show','1',0),
	(18981,821,'actual_date__show','1',0),
	(18982,821,'Reviewer__show','1',0),
	(18983,821,'description__show','1',0),
	(18984,821,'_limit','-1',0),
	(18985,821,'_order_column','created',0),
	(18986,821,'_order_direction','DESC',0),
	(18987,822,'advanced_filter','1',0),
	(18988,822,'foreign_key__show','1',0),
	(18989,822,'planned_date__show','1',0),
	(18990,822,'actual_date__show','1',0),
	(18991,822,'Reviewer__show','1',0),
	(18992,822,'description__show','1',0),
	(18993,822,'_limit','-1',0),
	(18994,822,'_order_column','planned_date',0),
	(18995,822,'_order_direction','ASC',0),
	(18996,822,'planned_date','_plus_14_days_',0),
	(18997,822,'planned_date__comp_type','2',0),
	(18998,822,'planned_date__use_calendar','0',0),
	(18999,822,'result__comp_type','0',0),
	(19000,822,'result','_null_',0),
	(19001,822,'completed','0',0),
	(19002,822,'completed__comp_type','5',0),
	(19003,823,'advanced_filter','1',0),
	(19004,823,'id__show','0',0),
	(19005,823,'foreign_key__show','0',0),
	(19006,823,'planned_date__show','1',0),
	(19007,823,'actual_date__show','0',0),
	(19008,823,'Reviewer__show','0',0),
	(19009,823,'description__show','0',0),
	(19010,823,'completed__show','0',0),
	(19011,823,'ObjectStatus_expired__show','0',0),
	(19012,823,'ObjectStatus_current_review__show','0',0),
	(19013,823,'created__show','0',0),
	(19014,823,'modified__show','0',0),
	(19015,823,'comment_message__show','1',0),
	(19016,823,'last_comment__show','0',0),
	(19017,823,'attachment_filename__show','0',0),
	(19018,823,'last_attachment__show','0',0),
	(19019,823,'_limit','-1',0),
	(19020,823,'_order_column','planned_date',0),
	(19021,823,'_order_direction','ASC',0),
	(19022,823,'last_comment','_minus_1_days_',0),
	(19023,823,'last_comment__comp_type','1',0),
	(19024,824,'advanced_filter','1',0),
	(19025,824,'id__show','0',0),
	(19026,824,'foreign_key__show','0',0),
	(19027,824,'planned_date__show','1',0),
	(19028,824,'actual_date__show','0',0),
	(19029,824,'Reviewer__show','0',0),
	(19030,824,'description__show','0',0),
	(19031,824,'completed__show','0',0),
	(19032,824,'ObjectStatus_expired__show','0',0),
	(19033,824,'ObjectStatus_current_review__show','0',0),
	(19034,824,'created__show','0',0),
	(19035,824,'modified__show','0',0),
	(19036,824,'comment_message__show','0',0),
	(19037,824,'last_comment__show','0',0),
	(19038,824,'attachment_filename__show','1',0),
	(19039,824,'last_attachment__show','0',0),
	(19040,824,'_limit','-1',0),
	(19041,824,'_order_column','planned_date',0),
	(19042,824,'_order_direction','ASC',0),
	(19043,824,'last_attachment','_minus_1_days_',0),
	(19044,824,'last_attachment__comp_type','1',0),
	(19045,825,'advanced_filter','1',0),
	(19046,825,'id__show','0',0),
	(19047,825,'foreign_key__show','0',0),
	(19048,825,'planned_date__show','1',0),
	(19049,825,'actual_date__show','0',0),
	(19050,825,'Reviewer__show','0',0),
	(19051,825,'description__show','0',0),
	(19052,825,'completed__show','0',0),
	(19053,825,'ObjectStatus_expired__show','0',0),
	(19054,825,'ObjectStatus_current_review__show','0',0),
	(19055,825,'created__show','0',0),
	(19056,825,'modified__show','0',0),
	(19057,825,'comment_message__show','0',0),
	(19058,825,'last_comment__show','0',0),
	(19059,825,'attachment_filename__show','0',0),
	(19060,825,'last_attachment__show','0',0),
	(19061,825,'_limit','-1',0),
	(19062,825,'_order_column','planned_date',0),
	(19063,825,'_order_direction','ASC',0),
	(19064,825,'modified','_minus_1_days_',0),
	(19065,825,'modified__comp_type','1',0),
	(19066,826,'advanced_filter','1',0),
	(19067,826,'id__show','0',0),
	(19068,826,'foreign_key__show','0',0),
	(19069,826,'planned_date__show','1',0),
	(19070,826,'actual_date__show','0',0),
	(19071,826,'Reviewer__show','0',0),
	(19072,826,'description__show','0',0),
	(19073,826,'completed__show','0',0),
	(19074,826,'ObjectStatus_expired__show','0',0),
	(19075,826,'ObjectStatus_current_review__show','0',0),
	(19076,826,'created__show','0',0),
	(19077,826,'modified__show','0',0),
	(19078,826,'comment_message__show','0',0),
	(19079,826,'last_comment__show','0',0),
	(19080,826,'attachment_filename__show','0',0),
	(19081,826,'last_attachment__show','0',0),
	(19082,826,'_limit','-1',0),
	(19083,826,'_order_column','planned_date',0),
	(19084,826,'_order_direction','ASC',0),
	(19085,826,'created','_minus_1_days_',0),
	(19086,826,'created__comp_type','1',0),
	(19087,827,'advanced_filter','1',0),
	(19088,827,'foreign_key__show','1',0),
	(19089,827,'planned_date__show','1',0),
	(19090,827,'actual_date__show','1',0),
	(19091,827,'Reviewer__show','1',0),
	(19092,827,'description__show','1',0),
	(19093,827,'_limit','-1',0),
	(19094,827,'_order_column','created',0),
	(19095,827,'_order_direction','DESC',0),
	(19096,828,'advanced_filter','1',0),
	(19097,828,'foreign_key__show','1',0),
	(19098,828,'planned_date__show','1',0),
	(19099,828,'actual_date__show','1',0),
	(19100,828,'Reviewer__show','1',0),
	(19101,828,'description__show','1',0),
	(19102,828,'_limit','-1',0),
	(19103,828,'_order_column','planned_date',0),
	(19104,828,'_order_direction','ASC',0),
	(19105,828,'planned_date','_plus_14_days_',0),
	(19106,828,'planned_date__comp_type','2',0),
	(19107,828,'planned_date__use_calendar','0',0),
	(19108,828,'result__comp_type','0',0),
	(19109,828,'result','_null_',0),
	(19110,828,'completed','0',0),
	(19111,828,'completed__comp_type','5',0),
	(19112,829,'advanced_filter','1',0),
	(19113,829,'id__show','0',0),
	(19114,829,'title__show','1',0),
	(19115,829,'description__show','0',0),
	(19116,829,'Tag-title__show','0',0),
	(19117,829,'Stakeholder__show','0',0),
	(19118,829,'Owner__show','0',0),
	(19119,829,'review__show','0',0),
	(19120,829,'ObjectStatus_risk_above_appetite__show','0',0),
	(19121,829,'ObjectStatus_expired_reviews__show','0',0),
	(19122,829,'RiskClassification__show','0',0),
	(19123,829,'risk_score__show','0',0),
	(19124,829,'ThirdParty__show','0',0),
	(19125,829,'Asset__show','0',0),
	(19126,829,'Threat__show','0',0),
	(19127,829,'threats__show','0',0),
	(19128,829,'Vulnerability__show','0',0),
	(19129,829,'vulnerabilities__show','0',0),
	(19130,829,'RiskClassificationTreatment__show','0',0),
	(19131,829,'residual_risk__show','0',0),
	(19132,829,'risk_mitigation_strategy_id__show','0',0),
	(19133,829,'RiskException-id__show','0',0),
	(19134,829,'SecurityService-id__show','0',0),
	(19135,829,'Project-id__show','0',0),
	(19136,829,'SecurityPolicyTreatment-id__show','0',0),
	(19137,829,'DataAssetInstance-asset_id__show','0',0),
	(19138,829,'DataAsset__show','0',0),
	(19139,829,'DataAsset-data_asset_status_id__show','0',0),
	(19140,829,'SecurityIncident__show','0',0),
	(19141,829,'SecurityIncident-security_incident_status_id__show','0',0),
	(19142,829,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(19143,829,'CompliancePackage-package_id__show','0',0),
	(19144,829,'CompliancePackage-name__show','0',0),
	(19145,829,'CompliancePackageItem-item_id__show','0',0),
	(19146,829,'CompliancePackageItem-name__show','0',0),
	(19147,829,'Project__show','0',0),
	(19148,829,'ProjectAchievement-description__show','0',0),
	(19149,829,'ObjectStatus_project_planned__show','0',0),
	(19150,829,'ObjectStatus_project_ongoing__show','0',0),
	(19151,829,'ObjectStatus_project_closed__show','0',0),
	(19152,829,'ObjectStatus_project_expired__show','0',0),
	(19153,829,'ObjectStatus_project_expired_tasks__show','0',0),
	(19154,829,'SecurityService__show','0',0),
	(19155,829,'SecurityService-objective__show','0',0),
	(19156,829,'ObjectStatus_audits_last_not_passed__show','0',0),
	(19157,829,'ObjectStatus_audits_last_missing__show','0',0),
	(19158,829,'ObjectStatus_control_with_issues__show','0',0),
	(19159,829,'ObjectStatus_maintenances_last_missing__show','0',0),
	(19160,829,'SecurityPolicyTreatment__show','0',0),
	(19161,829,'RiskException__show','0',0),
	(19162,829,'RiskException-description__show','0',0),
	(19163,829,'RiskException-status__show','0',0),
	(19164,829,'ObjectStatus_risk_exception_expired__show','0',0),
	(19165,829,'created__show','0',0),
	(19166,829,'modified__show','0',0),
	(19167,829,'comment_message__show','1',0),
	(19168,829,'last_comment__show','0',0),
	(19169,829,'attachment_filename__show','0',0),
	(19170,829,'last_attachment__show','0',0),
	(19171,829,'_limit','-1',0),
	(19172,829,'_order_column','title',0),
	(19173,829,'_order_direction','ASC',0),
	(19174,829,'last_comment','_minus_1_days_',0),
	(19175,829,'last_comment__comp_type','1',0),
	(19176,830,'advanced_filter','1',0),
	(19177,830,'id__show','0',0),
	(19178,830,'title__show','1',0),
	(19179,830,'description__show','0',0),
	(19180,830,'Tag-title__show','0',0),
	(19181,830,'Stakeholder__show','0',0),
	(19182,830,'Owner__show','0',0),
	(19183,830,'review__show','0',0),
	(19184,830,'ObjectStatus_risk_above_appetite__show','0',0),
	(19185,830,'ObjectStatus_expired_reviews__show','0',0),
	(19186,830,'RiskClassification__show','0',0),
	(19187,830,'risk_score__show','0',0),
	(19188,830,'ThirdParty__show','0',0),
	(19189,830,'Asset__show','0',0),
	(19190,830,'Threat__show','0',0),
	(19191,830,'threats__show','0',0),
	(19192,830,'Vulnerability__show','0',0),
	(19193,830,'vulnerabilities__show','0',0),
	(19194,830,'RiskClassificationTreatment__show','0',0),
	(19195,830,'residual_risk__show','0',0),
	(19196,830,'risk_mitigation_strategy_id__show','0',0),
	(19197,830,'RiskException-id__show','0',0),
	(19198,830,'SecurityService-id__show','0',0),
	(19199,830,'Project-id__show','0',0),
	(19200,830,'SecurityPolicyTreatment-id__show','0',0),
	(19201,830,'DataAssetInstance-asset_id__show','0',0),
	(19202,830,'DataAsset__show','0',0),
	(19203,830,'DataAsset-data_asset_status_id__show','0',0),
	(19204,830,'SecurityIncident__show','0',0),
	(19205,830,'SecurityIncident-security_incident_status_id__show','0',0),
	(19206,830,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(19207,830,'CompliancePackage-package_id__show','0',0),
	(19208,830,'CompliancePackage-name__show','0',0),
	(19209,830,'CompliancePackageItem-item_id__show','0',0),
	(19210,830,'CompliancePackageItem-name__show','0',0),
	(19211,830,'Project__show','0',0),
	(19212,830,'ProjectAchievement-description__show','0',0),
	(19213,830,'ObjectStatus_project_planned__show','0',0),
	(19214,830,'ObjectStatus_project_ongoing__show','0',0),
	(19215,830,'ObjectStatus_project_closed__show','0',0),
	(19216,830,'ObjectStatus_project_expired__show','0',0),
	(19217,830,'ObjectStatus_project_expired_tasks__show','0',0),
	(19218,830,'SecurityService__show','0',0),
	(19219,830,'SecurityService-objective__show','0',0),
	(19220,830,'ObjectStatus_audits_last_not_passed__show','0',0),
	(19221,830,'ObjectStatus_audits_last_missing__show','0',0),
	(19222,830,'ObjectStatus_control_with_issues__show','0',0),
	(19223,830,'ObjectStatus_maintenances_last_missing__show','0',0),
	(19224,830,'SecurityPolicyTreatment__show','0',0),
	(19225,830,'RiskException__show','0',0),
	(19226,830,'RiskException-description__show','0',0),
	(19227,830,'RiskException-status__show','0',0),
	(19228,830,'ObjectStatus_risk_exception_expired__show','0',0),
	(19229,830,'created__show','0',0),
	(19230,830,'modified__show','0',0),
	(19231,830,'comment_message__show','0',0),
	(19232,830,'last_comment__show','0',0),
	(19233,830,'attachment_filename__show','1',0),
	(19234,830,'last_attachment__show','0',0),
	(19235,830,'_limit','-1',0),
	(19236,830,'_order_column','title',0),
	(19237,830,'_order_direction','ASC',0),
	(19238,830,'last_attachment','_minus_1_days_',0),
	(19239,830,'last_attachment__comp_type','1',0),
	(19240,831,'advanced_filter','1',0),
	(19241,831,'id__show','0',0),
	(19242,831,'title__show','1',0),
	(19243,831,'description__show','0',0),
	(19244,831,'Tag-title__show','0',0),
	(19245,831,'Stakeholder__show','0',0),
	(19246,831,'Owner__show','0',0),
	(19247,831,'review__show','0',0),
	(19248,831,'ObjectStatus_risk_above_appetite__show','0',0),
	(19249,831,'ObjectStatus_expired_reviews__show','0',0),
	(19250,831,'RiskClassification__show','0',0),
	(19251,831,'risk_score__show','0',0),
	(19252,831,'ThirdParty__show','0',0),
	(19253,831,'Asset__show','0',0),
	(19254,831,'Threat__show','0',0),
	(19255,831,'threats__show','0',0),
	(19256,831,'Vulnerability__show','0',0),
	(19257,831,'vulnerabilities__show','0',0),
	(19258,831,'RiskClassificationTreatment__show','0',0),
	(19259,831,'residual_risk__show','0',0),
	(19260,831,'risk_mitigation_strategy_id__show','0',0),
	(19261,831,'RiskException-id__show','0',0),
	(19262,831,'SecurityService-id__show','0',0),
	(19263,831,'Project-id__show','0',0),
	(19264,831,'SecurityPolicyTreatment-id__show','0',0),
	(19265,831,'DataAssetInstance-asset_id__show','0',0),
	(19266,831,'DataAsset__show','0',0),
	(19267,831,'DataAsset-data_asset_status_id__show','0',0),
	(19268,831,'SecurityIncident__show','0',0),
	(19269,831,'SecurityIncident-security_incident_status_id__show','0',0),
	(19270,831,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(19271,831,'CompliancePackage-package_id__show','0',0),
	(19272,831,'CompliancePackage-name__show','0',0),
	(19273,831,'CompliancePackageItem-item_id__show','0',0),
	(19274,831,'CompliancePackageItem-name__show','0',0),
	(19275,831,'Project__show','0',0),
	(19276,831,'ProjectAchievement-description__show','0',0),
	(19277,831,'ObjectStatus_project_planned__show','0',0),
	(19278,831,'ObjectStatus_project_ongoing__show','0',0),
	(19279,831,'ObjectStatus_project_closed__show','0',0),
	(19280,831,'ObjectStatus_project_expired__show','0',0),
	(19281,831,'ObjectStatus_project_expired_tasks__show','0',0),
	(19282,831,'SecurityService__show','0',0),
	(19283,831,'SecurityService-objective__show','0',0),
	(19284,831,'ObjectStatus_audits_last_not_passed__show','0',0),
	(19285,831,'ObjectStatus_audits_last_missing__show','0',0),
	(19286,831,'ObjectStatus_control_with_issues__show','0',0),
	(19287,831,'ObjectStatus_maintenances_last_missing__show','0',0),
	(19288,831,'SecurityPolicyTreatment__show','0',0),
	(19289,831,'RiskException__show','0',0),
	(19290,831,'RiskException-description__show','0',0),
	(19291,831,'RiskException-status__show','0',0),
	(19292,831,'ObjectStatus_risk_exception_expired__show','0',0),
	(19293,831,'created__show','0',0),
	(19294,831,'modified__show','0',0),
	(19295,831,'comment_message__show','0',0),
	(19296,831,'last_comment__show','0',0),
	(19297,831,'attachment_filename__show','0',0),
	(19298,831,'last_attachment__show','0',0),
	(19299,831,'_limit','-1',0),
	(19300,831,'_order_column','title',0),
	(19301,831,'_order_direction','ASC',0),
	(19302,831,'modified','_minus_1_days_',0),
	(19303,831,'modified__comp_type','1',0),
	(19304,832,'advanced_filter','1',0),
	(19305,832,'id__show','0',0),
	(19306,832,'title__show','1',0),
	(19307,832,'description__show','0',0),
	(19308,832,'Tag-title__show','0',0),
	(19309,832,'Stakeholder__show','0',0),
	(19310,832,'Owner__show','0',0),
	(19311,832,'review__show','0',0),
	(19312,832,'ObjectStatus_risk_above_appetite__show','0',0),
	(19313,832,'ObjectStatus_expired_reviews__show','0',0),
	(19314,832,'RiskClassification__show','0',0),
	(19315,832,'risk_score__show','0',0),
	(19316,832,'ThirdParty__show','0',0),
	(19317,832,'Asset__show','0',0),
	(19318,832,'Threat__show','0',0),
	(19319,832,'threats__show','0',0),
	(19320,832,'Vulnerability__show','0',0),
	(19321,832,'vulnerabilities__show','0',0),
	(19322,832,'RiskClassificationTreatment__show','0',0),
	(19323,832,'residual_risk__show','0',0),
	(19324,832,'risk_mitigation_strategy_id__show','0',0),
	(19325,832,'RiskException-id__show','0',0),
	(19326,832,'SecurityService-id__show','0',0),
	(19327,832,'Project-id__show','0',0),
	(19328,832,'SecurityPolicyTreatment-id__show','0',0),
	(19329,832,'DataAssetInstance-asset_id__show','0',0),
	(19330,832,'DataAsset__show','0',0),
	(19331,832,'DataAsset-data_asset_status_id__show','0',0),
	(19332,832,'SecurityIncident__show','0',0),
	(19333,832,'SecurityIncident-security_incident_status_id__show','0',0),
	(19334,832,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(19335,832,'CompliancePackage-package_id__show','0',0),
	(19336,832,'CompliancePackage-name__show','0',0),
	(19337,832,'CompliancePackageItem-item_id__show','0',0),
	(19338,832,'CompliancePackageItem-name__show','0',0),
	(19339,832,'Project__show','0',0),
	(19340,832,'ProjectAchievement-description__show','0',0),
	(19341,832,'ObjectStatus_project_planned__show','0',0),
	(19342,832,'ObjectStatus_project_ongoing__show','0',0),
	(19343,832,'ObjectStatus_project_closed__show','0',0),
	(19344,832,'ObjectStatus_project_expired__show','0',0),
	(19345,832,'ObjectStatus_project_expired_tasks__show','0',0),
	(19346,832,'SecurityService__show','0',0),
	(19347,832,'SecurityService-objective__show','0',0),
	(19348,832,'ObjectStatus_audits_last_not_passed__show','0',0),
	(19349,832,'ObjectStatus_audits_last_missing__show','0',0),
	(19350,832,'ObjectStatus_control_with_issues__show','0',0),
	(19351,832,'ObjectStatus_maintenances_last_missing__show','0',0),
	(19352,832,'SecurityPolicyTreatment__show','0',0),
	(19353,832,'RiskException__show','0',0),
	(19354,832,'RiskException-description__show','0',0),
	(19355,832,'RiskException-status__show','0',0),
	(19356,832,'ObjectStatus_risk_exception_expired__show','0',0),
	(19357,832,'created__show','0',0),
	(19358,832,'modified__show','0',0),
	(19359,832,'comment_message__show','0',0),
	(19360,832,'last_comment__show','0',0),
	(19361,832,'attachment_filename__show','0',0),
	(19362,832,'last_attachment__show','0',0),
	(19363,832,'_limit','-1',0),
	(19364,832,'_order_column','title',0),
	(19365,832,'_order_direction','ASC',0),
	(19366,832,'created','_minus_1_days_',0),
	(19367,832,'created__comp_type','1',0),
	(19368,833,'advanced_filter','1',0),
	(19369,833,'title__show','1',0),
	(19370,833,'description__show','1',0),
	(19371,833,'Stakeholder__show','1',0),
	(19372,833,'Owner__show','1',0),
	(19373,833,'review__show','1',0),
	(19374,833,'ObjectStatus_risk_above_appetite__show','1',0),
	(19375,833,'ObjectStatus_expired_reviews__show','1',0),
	(19376,833,'RiskClassification__show','1',0),
	(19377,833,'risk_score__show','1',0),
	(19378,833,'ThirdParty__show','1',0),
	(19379,833,'Asset__show','1',0),
	(19380,833,'RiskClassificationTreatment__show','1',0),
	(19381,833,'residual_risk__show','1',0),
	(19382,833,'risk_mitigation_strategy_id__show','1',0),
	(19383,833,'_limit','-1',0),
	(19384,833,'_order_column','created',0),
	(19385,833,'_order_direction','DESC',0),
	(19386,834,'advanced_filter','1',0),
	(19387,834,'title__show','1',0),
	(19388,834,'description__show','1',0),
	(19389,834,'Stakeholder__show','1',0),
	(19390,834,'Owner__show','1',0),
	(19391,834,'review__show','1',0),
	(19392,834,'ObjectStatus_risk_above_appetite__show','1',0),
	(19393,834,'ObjectStatus_expired_reviews__show','1',0),
	(19394,834,'RiskClassification__show','1',0),
	(19395,834,'risk_score__show','1',0),
	(19396,834,'ThirdParty__show','1',0),
	(19397,834,'Asset__show','1',0),
	(19398,834,'RiskClassificationTreatment__show','1',0),
	(19399,834,'residual_risk__show','1',0),
	(19400,834,'risk_mitigation_strategy_id__show','1',0),
	(19401,834,'_limit','-1',0),
	(19402,834,'_order_column','title',0),
	(19403,834,'_order_direction','ASC',0),
	(19404,834,'ObjectStatus_expired','1',0),
	(19405,834,'ObjectStatus_expired__show','1',0),
	(19406,835,'advanced_filter','1',0),
	(19407,835,'id__show','0',0),
	(19408,835,'title__show','1',0),
	(19409,835,'description__show','0',0),
	(19410,835,'Tag-title__show','0',0),
	(19411,835,'Stakeholder__show','0',0),
	(19412,835,'Owner__show','0',0),
	(19413,835,'review__show','0',0),
	(19414,835,'ObjectStatus_risk_above_appetite__show','0',0),
	(19415,835,'ObjectStatus_expired_reviews__show','0',0),
	(19416,835,'RiskClassification__show','0',0),
	(19417,835,'risk_score__show','0',0),
	(19418,835,'BusinessUnit__show','0',0),
	(19419,835,'Process__show','0',0),
	(19420,835,'Process-rpd__show','0',0),
	(19421,835,'Process-rto__show','0',0),
	(19422,835,'Process-rpo__show','0',0),
	(19423,835,'Threat__show','0',0),
	(19424,835,'threats__show','0',0),
	(19425,835,'Vulnerability__show','0',0),
	(19426,835,'vulnerabilities__show','0',0),
	(19427,835,'BusinessContinuityPlan__show','0',0),
	(19428,835,'RiskClassificationTreatment__show','0',0),
	(19429,835,'residual_risk__show','0',0),
	(19430,835,'risk_mitigation_strategy_id__show','0',0),
	(19431,835,'RiskException-id__show','0',0),
	(19432,835,'SecurityService-id__show','0',0),
	(19433,835,'Project-id__show','0',0),
	(19434,835,'SecurityPolicyTreatment-id__show','0',0),
	(19435,835,'DataAssetInstance-asset_id__show','0',0),
	(19436,835,'DataAsset__show','0',0),
	(19437,835,'DataAsset-data_asset_status_id__show','0',0),
	(19438,835,'SecurityIncident__show','0',0),
	(19439,835,'SecurityIncident-security_incident_status_id__show','0',0),
	(19440,835,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(19441,835,'CompliancePackage-package_id__show','0',0),
	(19442,835,'CompliancePackage-name__show','0',0),
	(19443,835,'CompliancePackageItem-item_id__show','0',0),
	(19444,835,'CompliancePackageItem-name__show','0',0),
	(19445,835,'Project__show','0',0),
	(19446,835,'ProjectAchievement-description__show','0',0),
	(19447,835,'ObjectStatus_project_planned__show','0',0),
	(19448,835,'ObjectStatus_project_ongoing__show','0',0),
	(19449,835,'ObjectStatus_project_closed__show','0',0),
	(19450,835,'ObjectStatus_project_expired__show','0',0),
	(19451,835,'ObjectStatus_project_expired_tasks__show','0',0),
	(19452,835,'SecurityService__show','0',0),
	(19453,835,'SecurityService-objective__show','0',0),
	(19454,835,'ObjectStatus_audits_last_not_passed__show','0',0),
	(19455,835,'ObjectStatus_audits_last_missing__show','0',0),
	(19456,835,'ObjectStatus_control_with_issues__show','0',0),
	(19457,835,'ObjectStatus_maintenances_last_missing__show','0',0),
	(19458,835,'SecurityPolicyTreatment__show','0',0),
	(19459,835,'RiskException__show','0',0),
	(19460,835,'RiskException-description__show','0',0),
	(19461,835,'RiskException-status__show','0',0),
	(19462,835,'ObjectStatus_risk_exception_expired__show','0',0),
	(19463,835,'created__show','0',0),
	(19464,835,'modified__show','0',0),
	(19465,835,'comment_message__show','1',0),
	(19466,835,'last_comment__show','0',0),
	(19467,835,'attachment_filename__show','0',0),
	(19468,835,'last_attachment__show','0',0),
	(19469,835,'_limit','-1',0),
	(19470,835,'_order_column','title',0),
	(19471,835,'_order_direction','ASC',0),
	(19472,835,'last_comment','_minus_1_days_',0),
	(19473,835,'last_comment__comp_type','1',0),
	(19474,836,'advanced_filter','1',0),
	(19475,836,'id__show','0',0),
	(19476,836,'title__show','1',0),
	(19477,836,'description__show','0',0),
	(19478,836,'Tag-title__show','0',0),
	(19479,836,'Stakeholder__show','0',0),
	(19480,836,'Owner__show','0',0),
	(19481,836,'review__show','0',0),
	(19482,836,'ObjectStatus_risk_above_appetite__show','0',0),
	(19483,836,'ObjectStatus_expired_reviews__show','0',0),
	(19484,836,'RiskClassification__show','0',0),
	(19485,836,'risk_score__show','0',0),
	(19486,836,'BusinessUnit__show','0',0),
	(19487,836,'Process__show','0',0),
	(19488,836,'Process-rpd__show','0',0),
	(19489,836,'Process-rto__show','0',0),
	(19490,836,'Process-rpo__show','0',0),
	(19491,836,'Threat__show','0',0),
	(19492,836,'threats__show','0',0),
	(19493,836,'Vulnerability__show','0',0),
	(19494,836,'vulnerabilities__show','0',0),
	(19495,836,'BusinessContinuityPlan__show','0',0),
	(19496,836,'RiskClassificationTreatment__show','0',0),
	(19497,836,'residual_risk__show','0',0),
	(19498,836,'risk_mitigation_strategy_id__show','0',0),
	(19499,836,'RiskException-id__show','0',0),
	(19500,836,'SecurityService-id__show','0',0),
	(19501,836,'Project-id__show','0',0),
	(19502,836,'SecurityPolicyTreatment-id__show','0',0),
	(19503,836,'DataAssetInstance-asset_id__show','0',0),
	(19504,836,'DataAsset__show','0',0),
	(19505,836,'DataAsset-data_asset_status_id__show','0',0),
	(19506,836,'SecurityIncident__show','0',0),
	(19507,836,'SecurityIncident-security_incident_status_id__show','0',0),
	(19508,836,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(19509,836,'CompliancePackage-package_id__show','0',0),
	(19510,836,'CompliancePackage-name__show','0',0),
	(19511,836,'CompliancePackageItem-item_id__show','0',0),
	(19512,836,'CompliancePackageItem-name__show','0',0),
	(19513,836,'Project__show','0',0),
	(19514,836,'ProjectAchievement-description__show','0',0),
	(19515,836,'ObjectStatus_project_planned__show','0',0),
	(19516,836,'ObjectStatus_project_ongoing__show','0',0),
	(19517,836,'ObjectStatus_project_closed__show','0',0),
	(19518,836,'ObjectStatus_project_expired__show','0',0),
	(19519,836,'ObjectStatus_project_expired_tasks__show','0',0),
	(19520,836,'SecurityService__show','0',0),
	(19521,836,'SecurityService-objective__show','0',0),
	(19522,836,'ObjectStatus_audits_last_not_passed__show','0',0),
	(19523,836,'ObjectStatus_audits_last_missing__show','0',0),
	(19524,836,'ObjectStatus_control_with_issues__show','0',0),
	(19525,836,'ObjectStatus_maintenances_last_missing__show','0',0),
	(19526,836,'SecurityPolicyTreatment__show','0',0),
	(19527,836,'RiskException__show','0',0),
	(19528,836,'RiskException-description__show','0',0),
	(19529,836,'RiskException-status__show','0',0),
	(19530,836,'ObjectStatus_risk_exception_expired__show','0',0),
	(19531,836,'created__show','0',0),
	(19532,836,'modified__show','0',0),
	(19533,836,'comment_message__show','0',0),
	(19534,836,'last_comment__show','0',0),
	(19535,836,'attachment_filename__show','1',0),
	(19536,836,'last_attachment__show','0',0),
	(19537,836,'_limit','-1',0),
	(19538,836,'_order_column','title',0),
	(19539,836,'_order_direction','ASC',0),
	(19540,836,'last_attachment','_minus_1_days_',0),
	(19541,836,'last_attachment__comp_type','1',0),
	(19542,837,'advanced_filter','1',0),
	(19543,837,'id__show','0',0),
	(19544,837,'title__show','1',0),
	(19545,837,'description__show','0',0),
	(19546,837,'Tag-title__show','0',0),
	(19547,837,'Stakeholder__show','0',0),
	(19548,837,'Owner__show','0',0),
	(19549,837,'review__show','0',0),
	(19550,837,'ObjectStatus_risk_above_appetite__show','0',0),
	(19551,837,'ObjectStatus_expired_reviews__show','0',0),
	(19552,837,'RiskClassification__show','0',0),
	(19553,837,'risk_score__show','0',0),
	(19554,837,'BusinessUnit__show','0',0),
	(19555,837,'Process__show','0',0),
	(19556,837,'Process-rpd__show','0',0),
	(19557,837,'Process-rto__show','0',0),
	(19558,837,'Process-rpo__show','0',0),
	(19559,837,'Threat__show','0',0),
	(19560,837,'threats__show','0',0),
	(19561,837,'Vulnerability__show','0',0),
	(19562,837,'vulnerabilities__show','0',0),
	(19563,837,'BusinessContinuityPlan__show','0',0),
	(19564,837,'RiskClassificationTreatment__show','0',0),
	(19565,837,'residual_risk__show','0',0),
	(19566,837,'risk_mitigation_strategy_id__show','0',0),
	(19567,837,'RiskException-id__show','0',0),
	(19568,837,'SecurityService-id__show','0',0),
	(19569,837,'Project-id__show','0',0),
	(19570,837,'SecurityPolicyTreatment-id__show','0',0),
	(19571,837,'DataAssetInstance-asset_id__show','0',0),
	(19572,837,'DataAsset__show','0',0),
	(19573,837,'DataAsset-data_asset_status_id__show','0',0),
	(19574,837,'SecurityIncident__show','0',0),
	(19575,837,'SecurityIncident-security_incident_status_id__show','0',0),
	(19576,837,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(19577,837,'CompliancePackage-package_id__show','0',0),
	(19578,837,'CompliancePackage-name__show','0',0),
	(19579,837,'CompliancePackageItem-item_id__show','0',0),
	(19580,837,'CompliancePackageItem-name__show','0',0),
	(19581,837,'Project__show','0',0),
	(19582,837,'ProjectAchievement-description__show','0',0),
	(19583,837,'ObjectStatus_project_planned__show','0',0),
	(19584,837,'ObjectStatus_project_ongoing__show','0',0),
	(19585,837,'ObjectStatus_project_closed__show','0',0),
	(19586,837,'ObjectStatus_project_expired__show','0',0),
	(19587,837,'ObjectStatus_project_expired_tasks__show','0',0),
	(19588,837,'SecurityService__show','0',0),
	(19589,837,'SecurityService-objective__show','0',0),
	(19590,837,'ObjectStatus_audits_last_not_passed__show','0',0),
	(19591,837,'ObjectStatus_audits_last_missing__show','0',0),
	(19592,837,'ObjectStatus_control_with_issues__show','0',0),
	(19593,837,'ObjectStatus_maintenances_last_missing__show','0',0),
	(19594,837,'SecurityPolicyTreatment__show','0',0),
	(19595,837,'RiskException__show','0',0),
	(19596,837,'RiskException-description__show','0',0),
	(19597,837,'RiskException-status__show','0',0),
	(19598,837,'ObjectStatus_risk_exception_expired__show','0',0),
	(19599,837,'created__show','0',0),
	(19600,837,'modified__show','0',0),
	(19601,837,'comment_message__show','0',0),
	(19602,837,'last_comment__show','0',0),
	(19603,837,'attachment_filename__show','0',0),
	(19604,837,'last_attachment__show','0',0),
	(19605,837,'_limit','-1',0),
	(19606,837,'_order_column','title',0),
	(19607,837,'_order_direction','ASC',0),
	(19608,837,'modified','_minus_1_days_',0),
	(19609,837,'modified__comp_type','1',0),
	(19610,838,'advanced_filter','1',0),
	(19611,838,'id__show','0',0),
	(19612,838,'title__show','1',0),
	(19613,838,'description__show','0',0),
	(19614,838,'Tag-title__show','0',0),
	(19615,838,'Stakeholder__show','0',0),
	(19616,838,'Owner__show','0',0),
	(19617,838,'review__show','0',0),
	(19618,838,'ObjectStatus_risk_above_appetite__show','0',0),
	(19619,838,'ObjectStatus_expired_reviews__show','0',0),
	(19620,838,'RiskClassification__show','0',0),
	(19621,838,'risk_score__show','0',0),
	(19622,838,'BusinessUnit__show','0',0),
	(19623,838,'Process__show','0',0),
	(19624,838,'Process-rpd__show','0',0),
	(19625,838,'Process-rto__show','0',0),
	(19626,838,'Process-rpo__show','0',0),
	(19627,838,'Threat__show','0',0),
	(19628,838,'threats__show','0',0),
	(19629,838,'Vulnerability__show','0',0),
	(19630,838,'vulnerabilities__show','0',0),
	(19631,838,'BusinessContinuityPlan__show','0',0),
	(19632,838,'RiskClassificationTreatment__show','0',0),
	(19633,838,'residual_risk__show','0',0),
	(19634,838,'risk_mitigation_strategy_id__show','0',0),
	(19635,838,'RiskException-id__show','0',0),
	(19636,838,'SecurityService-id__show','0',0),
	(19637,838,'Project-id__show','0',0),
	(19638,838,'SecurityPolicyTreatment-id__show','0',0),
	(19639,838,'DataAssetInstance-asset_id__show','0',0),
	(19640,838,'DataAsset__show','0',0),
	(19641,838,'DataAsset-data_asset_status_id__show','0',0),
	(19642,838,'SecurityIncident__show','0',0),
	(19643,838,'SecurityIncident-security_incident_status_id__show','0',0),
	(19644,838,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(19645,838,'CompliancePackage-package_id__show','0',0),
	(19646,838,'CompliancePackage-name__show','0',0),
	(19647,838,'CompliancePackageItem-item_id__show','0',0),
	(19648,838,'CompliancePackageItem-name__show','0',0),
	(19649,838,'Project__show','0',0),
	(19650,838,'ProjectAchievement-description__show','0',0),
	(19651,838,'ObjectStatus_project_planned__show','0',0),
	(19652,838,'ObjectStatus_project_ongoing__show','0',0),
	(19653,838,'ObjectStatus_project_closed__show','0',0),
	(19654,838,'ObjectStatus_project_expired__show','0',0),
	(19655,838,'ObjectStatus_project_expired_tasks__show','0',0),
	(19656,838,'SecurityService__show','0',0),
	(19657,838,'SecurityService-objective__show','0',0),
	(19658,838,'ObjectStatus_audits_last_not_passed__show','0',0),
	(19659,838,'ObjectStatus_audits_last_missing__show','0',0),
	(19660,838,'ObjectStatus_control_with_issues__show','0',0),
	(19661,838,'ObjectStatus_maintenances_last_missing__show','0',0),
	(19662,838,'SecurityPolicyTreatment__show','0',0),
	(19663,838,'RiskException__show','0',0),
	(19664,838,'RiskException-description__show','0',0),
	(19665,838,'RiskException-status__show','0',0),
	(19666,838,'ObjectStatus_risk_exception_expired__show','0',0),
	(19667,838,'created__show','0',0),
	(19668,838,'modified__show','0',0),
	(19669,838,'comment_message__show','0',0),
	(19670,838,'last_comment__show','0',0),
	(19671,838,'attachment_filename__show','0',0),
	(19672,838,'last_attachment__show','0',0),
	(19673,838,'_limit','-1',0),
	(19674,838,'_order_column','title',0),
	(19675,838,'_order_direction','ASC',0),
	(19676,838,'created','_minus_1_days_',0),
	(19677,838,'created__comp_type','1',0),
	(19678,839,'advanced_filter','1',0),
	(19679,839,'title__show','1',0),
	(19680,839,'description__show','1',0),
	(19681,839,'Stakeholder__show','1',0),
	(19682,839,'Owner__show','1',0),
	(19683,839,'review__show','1',0),
	(19684,839,'ObjectStatus_risk_above_appetite__show','1',0),
	(19685,839,'ObjectStatus_expired_reviews__show','1',0),
	(19686,839,'RiskClassification__show','1',0),
	(19687,839,'risk_score__show','1',0),
	(19688,839,'BusinessUnit__show','1',0),
	(19689,839,'Process__show','1',0),
	(19690,839,'Process-rto__show','1',0),
	(19691,839,'Process-rpo__show','1',0),
	(19692,839,'BusinessContinuityPlan__show','1',0),
	(19693,839,'RiskClassificationTreatment__show','1',0),
	(19694,839,'residual_risk__show','1',0),
	(19695,839,'risk_mitigation_strategy_id__show','1',0),
	(19696,839,'_limit','-1',0),
	(19697,839,'_order_column','created',0),
	(19698,839,'_order_direction','DESC',0),
	(19699,840,'advanced_filter','1',0),
	(19700,840,'title__show','1',0),
	(19701,840,'description__show','1',0),
	(19702,840,'Stakeholder__show','1',0),
	(19703,840,'Owner__show','1',0),
	(19704,840,'review__show','1',0),
	(19705,840,'ObjectStatus_risk_above_appetite__show','1',0),
	(19706,840,'ObjectStatus_expired_reviews__show','1',0),
	(19707,840,'RiskClassification__show','1',0),
	(19708,840,'risk_score__show','1',0),
	(19709,840,'BusinessUnit__show','1',0),
	(19710,840,'Process__show','1',0),
	(19711,840,'Process-rto__show','1',0),
	(19712,840,'Process-rpo__show','1',0),
	(19713,840,'BusinessContinuityPlan__show','1',0),
	(19714,840,'RiskClassificationTreatment__show','1',0),
	(19715,840,'residual_risk__show','1',0),
	(19716,840,'risk_mitigation_strategy_id__show','1',0),
	(19717,840,'_limit','-1',0),
	(19718,840,'_order_column','title',0),
	(19719,840,'_order_direction','ASC',0),
	(19720,840,'ObjectStatus_expired','1',0),
	(19721,840,'ObjectStatus_expired__show','1',0),
	(19722,841,'advanced_filter','1',0),
	(19723,841,'id__show','0',0),
	(19724,841,'name__show','1',0),
	(19725,841,'description__show','0',0),
	(19726,841,'BusinessUnitOwner__show','0',0),
	(19727,841,'Legal__show','0',0),
	(19728,841,'created__show','0',0),
	(19729,841,'modified__show','0',0),
	(19730,841,'comment_message__show','1',0),
	(19731,841,'last_comment__show','0',0),
	(19732,841,'attachment_filename__show','0',0),
	(19733,841,'last_attachment__show','0',0),
	(19734,841,'_limit','-1',0),
	(19735,841,'_order_column','name',0),
	(19736,841,'_order_direction','ASC',0),
	(19737,841,'last_comment','_minus_1_days_',0),
	(19738,841,'last_comment__comp_type','1',0),
	(19739,842,'advanced_filter','1',0),
	(19740,842,'id__show','0',0),
	(19741,842,'name__show','1',0),
	(19742,842,'description__show','0',0),
	(19743,842,'BusinessUnitOwner__show','0',0),
	(19744,842,'Legal__show','0',0),
	(19745,842,'created__show','0',0),
	(19746,842,'modified__show','0',0),
	(19747,842,'comment_message__show','0',0),
	(19748,842,'last_comment__show','0',0),
	(19749,842,'attachment_filename__show','1',0),
	(19750,842,'last_attachment__show','0',0),
	(19751,842,'_limit','-1',0),
	(19752,842,'_order_column','name',0),
	(19753,842,'_order_direction','ASC',0),
	(19754,842,'last_attachment','_minus_1_days_',0),
	(19755,842,'last_attachment__comp_type','1',0),
	(19756,843,'advanced_filter','1',0),
	(19757,843,'id__show','0',0),
	(19758,843,'name__show','1',0),
	(19759,843,'description__show','0',0),
	(19760,843,'BusinessUnitOwner__show','0',0),
	(19761,843,'Legal__show','0',0),
	(19762,843,'created__show','0',0),
	(19763,843,'modified__show','0',0),
	(19764,843,'comment_message__show','0',0),
	(19765,843,'last_comment__show','0',0),
	(19766,843,'attachment_filename__show','0',0),
	(19767,843,'last_attachment__show','0',0),
	(19768,843,'_limit','-1',0),
	(19769,843,'_order_column','name',0),
	(19770,843,'_order_direction','ASC',0),
	(19771,843,'modified','_minus_1_days_',0),
	(19772,843,'modified__comp_type','1',0),
	(19773,844,'advanced_filter','1',0),
	(19774,844,'id__show','0',0),
	(19775,844,'name__show','1',0),
	(19776,844,'description__show','0',0),
	(19777,844,'BusinessUnitOwner__show','0',0),
	(19778,844,'Legal__show','0',0),
	(19779,844,'created__show','0',0),
	(19780,844,'modified__show','0',0),
	(19781,844,'comment_message__show','0',0),
	(19782,844,'last_comment__show','0',0),
	(19783,844,'attachment_filename__show','0',0),
	(19784,844,'last_attachment__show','0',0),
	(19785,844,'_limit','-1',0),
	(19786,844,'_order_column','name',0),
	(19787,844,'_order_direction','ASC',0),
	(19788,844,'created','_minus_1_days_',0),
	(19789,844,'created__comp_type','1',0),
	(19790,845,'advanced_filter','1',0),
	(19791,845,'name__show','1',0),
	(19792,845,'description__show','1',0),
	(19793,845,'BusinessUnitOwner__show','1',0),
	(19794,845,'Legal__show','1',0),
	(19795,845,'_limit','-1',0),
	(19796,845,'_order_column','created',0),
	(19797,845,'_order_direction','DESC',0),
	(19798,846,'advanced_filter','1',0),
	(19799,846,'id__show','0',0),
	(19800,846,'name__show','1',0),
	(19801,846,'description__show','0',0),
	(19802,846,'business_unit_id__show','0',0),
	(19803,846,'rto__show','0',0),
	(19804,846,'rpo__show','0',0),
	(19805,846,'rpd__show','0',0),
	(19806,846,'created__show','0',0),
	(19807,846,'modified__show','0',0),
	(19808,846,'comment_message__show','1',0),
	(19809,846,'last_comment__show','0',0),
	(19810,846,'attachment_filename__show','0',0),
	(19811,846,'last_attachment__show','0',0),
	(19812,846,'_limit','-1',0),
	(19813,846,'_order_column','name',0),
	(19814,846,'_order_direction','ASC',0),
	(19815,846,'last_comment','_minus_1_days_',0),
	(19816,846,'last_comment__comp_type','1',0),
	(19817,847,'advanced_filter','1',0),
	(19818,847,'id__show','0',0),
	(19819,847,'name__show','1',0),
	(19820,847,'description__show','0',0),
	(19821,847,'business_unit_id__show','0',0),
	(19822,847,'rto__show','0',0),
	(19823,847,'rpo__show','0',0),
	(19824,847,'rpd__show','0',0),
	(19825,847,'created__show','0',0),
	(19826,847,'modified__show','0',0),
	(19827,847,'comment_message__show','0',0),
	(19828,847,'last_comment__show','0',0),
	(19829,847,'attachment_filename__show','1',0),
	(19830,847,'last_attachment__show','0',0),
	(19831,847,'_limit','-1',0),
	(19832,847,'_order_column','name',0),
	(19833,847,'_order_direction','ASC',0),
	(19834,847,'last_attachment','_minus_1_days_',0),
	(19835,847,'last_attachment__comp_type','1',0),
	(19836,848,'advanced_filter','1',0),
	(19837,848,'id__show','0',0),
	(19838,848,'name__show','1',0),
	(19839,848,'description__show','0',0),
	(19840,848,'business_unit_id__show','0',0),
	(19841,848,'rto__show','0',0),
	(19842,848,'rpo__show','0',0),
	(19843,848,'rpd__show','0',0),
	(19844,848,'created__show','0',0),
	(19845,848,'modified__show','0',0),
	(19846,848,'comment_message__show','0',0),
	(19847,848,'last_comment__show','0',0),
	(19848,848,'attachment_filename__show','0',0),
	(19849,848,'last_attachment__show','0',0),
	(19850,848,'_limit','-1',0),
	(19851,848,'_order_column','name',0),
	(19852,848,'_order_direction','ASC',0),
	(19853,848,'modified','_minus_1_days_',0),
	(19854,848,'modified__comp_type','1',0),
	(19855,849,'advanced_filter','1',0),
	(19856,849,'id__show','0',0),
	(19857,849,'name__show','1',0),
	(19858,849,'description__show','0',0),
	(19859,849,'business_unit_id__show','0',0),
	(19860,849,'rto__show','0',0),
	(19861,849,'rpo__show','0',0),
	(19862,849,'rpd__show','0',0),
	(19863,849,'created__show','0',0),
	(19864,849,'modified__show','0',0),
	(19865,849,'comment_message__show','0',0),
	(19866,849,'last_comment__show','0',0),
	(19867,849,'attachment_filename__show','0',0),
	(19868,849,'last_attachment__show','0',0),
	(19869,849,'_limit','-1',0),
	(19870,849,'_order_column','name',0),
	(19871,849,'_order_direction','ASC',0),
	(19872,849,'created','_minus_1_days_',0),
	(19873,849,'created__comp_type','1',0),
	(19874,850,'advanced_filter','1',0),
	(19875,850,'name__show','1',0),
	(19876,850,'description__show','1',0),
	(19877,850,'business_unit_id__show','1',0),
	(19878,850,'rto__show','1',0),
	(19879,850,'rpo__show','1',0),
	(19880,850,'rpd__show','1',0),
	(19881,850,'_limit','-1',0),
	(19882,850,'_order_column','created',0),
	(19883,850,'_order_direction','DESC',0),
	(19884,851,'advanced_filter','1',0),
	(19885,851,'id__show','0',0),
	(19886,851,'name__show','1',0),
	(19887,851,'description__show','0',0),
	(19888,851,'Owner__show','0',0),
	(19889,851,'value__show','0',0),
	(19890,851,'start__show','0',0),
	(19891,851,'end__show','0',0),
	(19892,851,'ObjectStatus_expired__show','0',0),
	(19893,851,'third_party_id__show','0',0),
	(19894,851,'created__show','0',0),
	(19895,851,'modified__show','0',0),
	(19896,851,'comment_message__show','1',0),
	(19897,851,'last_comment__show','0',0),
	(19898,851,'attachment_filename__show','0',0),
	(19899,851,'last_attachment__show','0',0),
	(19900,851,'_limit','-1',0),
	(19901,851,'_order_column','name',0),
	(19902,851,'_order_direction','ASC',0),
	(19903,851,'last_comment','_minus_1_days_',0),
	(19904,851,'last_comment__comp_type','1',0),
	(19905,852,'advanced_filter','1',0),
	(19906,852,'id__show','0',0),
	(19907,852,'name__show','1',0),
	(19908,852,'description__show','0',0),
	(19909,852,'Owner__show','0',0),
	(19910,852,'value__show','0',0),
	(19911,852,'start__show','0',0),
	(19912,852,'end__show','0',0),
	(19913,852,'ObjectStatus_expired__show','0',0),
	(19914,852,'third_party_id__show','0',0),
	(19915,852,'created__show','0',0),
	(19916,852,'modified__show','0',0),
	(19917,852,'comment_message__show','0',0),
	(19918,852,'last_comment__show','0',0),
	(19919,852,'attachment_filename__show','1',0),
	(19920,852,'last_attachment__show','0',0),
	(19921,852,'_limit','-1',0),
	(19922,852,'_order_column','name',0),
	(19923,852,'_order_direction','ASC',0),
	(19924,852,'last_attachment','_minus_1_days_',0),
	(19925,852,'last_attachment__comp_type','1',0),
	(19926,853,'advanced_filter','1',0),
	(19927,853,'id__show','0',0),
	(19928,853,'name__show','1',0),
	(19929,853,'description__show','0',0),
	(19930,853,'Owner__show','0',0),
	(19931,853,'value__show','0',0),
	(19932,853,'start__show','0',0),
	(19933,853,'end__show','0',0),
	(19934,853,'ObjectStatus_expired__show','0',0),
	(19935,853,'third_party_id__show','0',0),
	(19936,853,'created__show','0',0),
	(19937,853,'modified__show','0',0),
	(19938,853,'comment_message__show','0',0),
	(19939,853,'last_comment__show','0',0),
	(19940,853,'attachment_filename__show','0',0),
	(19941,853,'last_attachment__show','0',0),
	(19942,853,'_limit','-1',0),
	(19943,853,'_order_column','name',0),
	(19944,853,'_order_direction','ASC',0),
	(19945,853,'modified','_minus_1_days_',0),
	(19946,853,'modified__comp_type','1',0),
	(19947,854,'advanced_filter','1',0),
	(19948,854,'id__show','0',0),
	(19949,854,'name__show','1',0),
	(19950,854,'description__show','0',0),
	(19951,854,'Owner__show','0',0),
	(19952,854,'value__show','0',0),
	(19953,854,'start__show','0',0),
	(19954,854,'end__show','0',0),
	(19955,854,'ObjectStatus_expired__show','0',0),
	(19956,854,'third_party_id__show','0',0),
	(19957,854,'created__show','0',0),
	(19958,854,'modified__show','0',0),
	(19959,854,'comment_message__show','0',0),
	(19960,854,'last_comment__show','0',0),
	(19961,854,'attachment_filename__show','0',0),
	(19962,854,'last_attachment__show','0',0),
	(19963,854,'_limit','-1',0),
	(19964,854,'_order_column','name',0),
	(19965,854,'_order_direction','ASC',0),
	(19966,854,'created','_minus_1_days_',0),
	(19967,854,'created__comp_type','1',0),
	(19968,855,'advanced_filter','1',0),
	(19969,855,'name__show','1',0),
	(19970,855,'description__show','1',0),
	(19971,855,'Owner__show','1',0),
	(19972,855,'value__show','1',0),
	(19973,855,'start__show','1',0),
	(19974,855,'end__show','1',0),
	(19975,855,'third_party_id__show','1',0),
	(19976,855,'_limit','-1',0),
	(19977,855,'_order_column','created',0),
	(19978,855,'_order_direction','DESC',0),
	(19979,856,'advanced_filter','1',0),
	(19980,856,'name__show','1',0),
	(19981,856,'description__show','1',0),
	(19982,856,'Owner__show','1',0),
	(19983,856,'value__show','1',0),
	(19984,856,'start__show','1',0),
	(19985,856,'end__show','1',0),
	(19986,856,'third_party_id__show','1',0),
	(19987,856,'_limit','-1',0),
	(19988,856,'_order_column','name',0),
	(19989,856,'_order_direction','ASC',0),
	(19990,856,'end','_plus_14_days_',0),
	(19991,856,'end__comp_type','2',0),
	(19992,856,'end__use_calendar','0',0),
	(19993,857,'advanced_filter','1',0),
	(19994,857,'name__show','1',0),
	(19995,857,'description__show','1',0),
	(19996,857,'Owner__show','1',0),
	(19997,857,'value__show','1',0),
	(19998,857,'start__show','1',0),
	(19999,857,'end__show','1',0),
	(20000,857,'third_party_id__show','1',0),
	(20001,857,'_limit','-1',0),
	(20002,857,'_order_column','name',0),
	(20003,857,'_order_direction','ASC',0),
	(20004,857,'ObjectStatus_expired','1',0),
	(20005,857,'ObjectStatus_expired__show','1',0),
	(20006,858,'advanced_filter','1',0),
	(20007,858,'id__show','0',0),
	(20008,858,'title__show','1',0),
	(20009,858,'Requester__show','0',0),
	(20010,858,'expiration__show','0',0),
	(20011,858,'Tag-title__show','0',0),
	(20012,858,'closure_date__show','0',0),
	(20013,858,'status__show','0',0),
	(20014,858,'ObjectStatus_expired__show','0',0),
	(20015,858,'Risk__show','0',0),
	(20016,858,'ThirdPartyRisk__show','0',0),
	(20017,858,'BusinessContinuity__show','0',0),
	(20018,858,'created__show','0',0),
	(20019,858,'modified__show','0',0),
	(20020,858,'comment_message__show','1',0),
	(20021,858,'last_comment__show','0',0),
	(20022,858,'attachment_filename__show','0',0),
	(20023,858,'last_attachment__show','0',0),
	(20024,858,'_limit','-1',0),
	(20025,858,'_order_column','title',0),
	(20026,858,'_order_direction','ASC',0),
	(20027,858,'last_comment','_minus_1_days_',0),
	(20028,858,'last_comment__comp_type','1',0),
	(20029,859,'advanced_filter','1',0),
	(20030,859,'id__show','0',0),
	(20031,859,'title__show','1',0),
	(20032,859,'Requester__show','0',0),
	(20033,859,'expiration__show','0',0),
	(20034,859,'Tag-title__show','0',0),
	(20035,859,'closure_date__show','0',0),
	(20036,859,'status__show','0',0),
	(20037,859,'ObjectStatus_expired__show','0',0),
	(20038,859,'Risk__show','0',0),
	(20039,859,'ThirdPartyRisk__show','0',0),
	(20040,859,'BusinessContinuity__show','0',0),
	(20041,859,'created__show','0',0),
	(20042,859,'modified__show','0',0),
	(20043,859,'comment_message__show','0',0),
	(20044,859,'last_comment__show','0',0),
	(20045,859,'attachment_filename__show','1',0),
	(20046,859,'last_attachment__show','0',0),
	(20047,859,'_limit','-1',0),
	(20048,859,'_order_column','title',0),
	(20049,859,'_order_direction','ASC',0),
	(20050,859,'last_attachment','_minus_1_days_',0),
	(20051,859,'last_attachment__comp_type','1',0),
	(20052,860,'advanced_filter','1',0),
	(20053,860,'id__show','0',0),
	(20054,860,'title__show','1',0),
	(20055,860,'Requester__show','0',0),
	(20056,860,'expiration__show','0',0),
	(20057,860,'Tag-title__show','0',0),
	(20058,860,'closure_date__show','0',0),
	(20059,860,'status__show','0',0),
	(20060,860,'ObjectStatus_expired__show','0',0),
	(20061,860,'Risk__show','0',0),
	(20062,860,'ThirdPartyRisk__show','0',0),
	(20063,860,'BusinessContinuity__show','0',0),
	(20064,860,'created__show','0',0),
	(20065,860,'modified__show','0',0),
	(20066,860,'comment_message__show','0',0),
	(20067,860,'last_comment__show','0',0),
	(20068,860,'attachment_filename__show','0',0),
	(20069,860,'last_attachment__show','0',0),
	(20070,860,'_limit','-1',0),
	(20071,860,'_order_column','title',0),
	(20072,860,'_order_direction','ASC',0),
	(20073,860,'modified','_minus_1_days_',0),
	(20074,860,'modified__comp_type','1',0),
	(20075,861,'advanced_filter','1',0),
	(20076,861,'id__show','0',0),
	(20077,861,'title__show','1',0),
	(20078,861,'Requester__show','0',0),
	(20079,861,'expiration__show','0',0),
	(20080,861,'Tag-title__show','0',0),
	(20081,861,'closure_date__show','0',0),
	(20082,861,'status__show','0',0),
	(20083,861,'ObjectStatus_expired__show','0',0),
	(20084,861,'Risk__show','0',0),
	(20085,861,'ThirdPartyRisk__show','0',0),
	(20086,861,'BusinessContinuity__show','0',0),
	(20087,861,'created__show','0',0),
	(20088,861,'modified__show','0',0),
	(20089,861,'comment_message__show','0',0),
	(20090,861,'last_comment__show','0',0),
	(20091,861,'attachment_filename__show','0',0),
	(20092,861,'last_attachment__show','0',0),
	(20093,861,'_limit','-1',0),
	(20094,861,'_order_column','title',0),
	(20095,861,'_order_direction','ASC',0),
	(20096,861,'created','_minus_1_days_',0),
	(20097,861,'created__comp_type','1',0),
	(20098,862,'advanced_filter','1',0),
	(20099,862,'title__show','1',0),
	(20100,862,'Requester__show','1',0),
	(20101,862,'expiration__show','1',0),
	(20102,862,'Tag-title__show','1',0),
	(20103,862,'closure_date__show','1',0),
	(20104,862,'status__show','1',0),
	(20105,862,'Risk__show','1',0),
	(20106,862,'ThirdPartyRisk__show','1',0),
	(20107,862,'BusinessContinuity__show','1',0),
	(20108,862,'_limit','-1',0),
	(20109,862,'_order_column','created',0),
	(20110,862,'_order_direction','DESC',0),
	(20111,863,'advanced_filter','1',0),
	(20112,863,'title__show','1',0),
	(20113,863,'Requester__show','1',0),
	(20114,863,'expiration__show','1',0),
	(20115,863,'Tag-title__show','1',0),
	(20116,863,'closure_date__show','1',0),
	(20117,863,'status__show','1',0),
	(20118,863,'Risk__show','1',0),
	(20119,863,'ThirdPartyRisk__show','1',0),
	(20120,863,'BusinessContinuity__show','1',0),
	(20121,863,'_limit','-1',0),
	(20122,863,'_order_column','title',0),
	(20123,863,'_order_direction','ASC',0),
	(20124,863,'expiration','_plus_14_days_',0),
	(20125,863,'expiration__comp_type','2',0),
	(20126,863,'expiration__use_calendar','0',0),
	(20127,863,'status__comp_type','0',0),
	(20128,863,'status','1',0),
	(20129,864,'advanced_filter','1',0),
	(20130,864,'title__show','1',0),
	(20131,864,'Requester__show','1',0),
	(20132,864,'expiration__show','1',0),
	(20133,864,'Tag-title__show','1',0),
	(20134,864,'closure_date__show','1',0),
	(20135,864,'status__show','1',0),
	(20136,864,'Risk__show','1',0),
	(20137,864,'ThirdPartyRisk__show','1',0),
	(20138,864,'BusinessContinuity__show','1',0),
	(20139,864,'_limit','-1',0),
	(20140,864,'_order_column','title',0),
	(20141,864,'_order_direction','ASC',0),
	(20142,864,'ObjectStatus_expired','1',0),
	(20143,864,'ObjectStatus_expired__show','1',0),
	(20144,865,'advanced_filter','1',0),
	(20145,865,'id__show','0',0),
	(20146,865,'title__show','1',0),
	(20147,865,'Requestor__show','0',0),
	(20148,865,'expiration__show','0',0),
	(20149,865,'Classification-name__show','0',0),
	(20150,865,'closure_date__show','0',0),
	(20151,865,'status__show','0',0),
	(20152,865,'ObjectStatus_expired__show','0',0),
	(20153,865,'SecurityPolicy__show','0',0),
	(20154,865,'Asset__show','0',0),
	(20155,865,'ThirdParty__show','0',0),
	(20156,865,'created__show','0',0),
	(20157,865,'modified__show','0',0),
	(20158,865,'comment_message__show','1',0),
	(20159,865,'last_comment__show','0',0),
	(20160,865,'attachment_filename__show','0',0),
	(20161,865,'last_attachment__show','0',0),
	(20162,865,'_limit','-1',0),
	(20163,865,'_order_column','title',0),
	(20164,865,'_order_direction','ASC',0),
	(20165,865,'last_comment','_minus_1_days_',0),
	(20166,865,'last_comment__comp_type','1',0),
	(20167,866,'advanced_filter','1',0),
	(20168,866,'id__show','0',0),
	(20169,866,'title__show','1',0),
	(20170,866,'Requestor__show','0',0),
	(20171,866,'expiration__show','0',0),
	(20172,866,'Classification-name__show','0',0),
	(20173,866,'closure_date__show','0',0),
	(20174,866,'status__show','0',0),
	(20175,866,'ObjectStatus_expired__show','0',0),
	(20176,866,'SecurityPolicy__show','0',0),
	(20177,866,'Asset__show','0',0),
	(20178,866,'ThirdParty__show','0',0),
	(20179,866,'created__show','0',0),
	(20180,866,'modified__show','0',0),
	(20181,866,'comment_message__show','0',0),
	(20182,866,'last_comment__show','0',0),
	(20183,866,'attachment_filename__show','1',0),
	(20184,866,'last_attachment__show','0',0),
	(20185,866,'_limit','-1',0),
	(20186,866,'_order_column','title',0),
	(20187,866,'_order_direction','ASC',0),
	(20188,866,'last_attachment','_minus_1_days_',0),
	(20189,866,'last_attachment__comp_type','1',0),
	(20190,867,'advanced_filter','1',0),
	(20191,867,'id__show','0',0),
	(20192,867,'title__show','1',0),
	(20193,867,'Requestor__show','0',0),
	(20194,867,'expiration__show','0',0),
	(20195,867,'Classification-name__show','0',0),
	(20196,867,'closure_date__show','0',0),
	(20197,867,'status__show','0',0),
	(20198,867,'ObjectStatus_expired__show','0',0),
	(20199,867,'SecurityPolicy__show','0',0),
	(20200,867,'Asset__show','0',0),
	(20201,867,'ThirdParty__show','0',0),
	(20202,867,'created__show','0',0),
	(20203,867,'modified__show','0',0),
	(20204,867,'comment_message__show','0',0),
	(20205,867,'last_comment__show','0',0),
	(20206,867,'attachment_filename__show','0',0),
	(20207,867,'last_attachment__show','0',0),
	(20208,867,'_limit','-1',0),
	(20209,867,'_order_column','title',0),
	(20210,867,'_order_direction','ASC',0),
	(20211,867,'modified','_minus_1_days_',0),
	(20212,867,'modified__comp_type','1',0),
	(20213,868,'advanced_filter','1',0),
	(20214,868,'id__show','0',0),
	(20215,868,'title__show','1',0),
	(20216,868,'Requestor__show','0',0),
	(20217,868,'expiration__show','0',0),
	(20218,868,'Classification-name__show','0',0),
	(20219,868,'closure_date__show','0',0),
	(20220,868,'status__show','0',0),
	(20221,868,'ObjectStatus_expired__show','0',0),
	(20222,868,'SecurityPolicy__show','0',0),
	(20223,868,'Asset__show','0',0),
	(20224,868,'ThirdParty__show','0',0),
	(20225,868,'created__show','0',0),
	(20226,868,'modified__show','0',0),
	(20227,868,'comment_message__show','0',0),
	(20228,868,'last_comment__show','0',0),
	(20229,868,'attachment_filename__show','0',0),
	(20230,868,'last_attachment__show','0',0),
	(20231,868,'_limit','-1',0),
	(20232,868,'_order_column','title',0),
	(20233,868,'_order_direction','ASC',0),
	(20234,868,'created','_minus_1_days_',0),
	(20235,868,'created__comp_type','1',0),
	(20236,869,'advanced_filter','1',0),
	(20237,869,'title__show','1',0),
	(20238,869,'Requestor__show','1',0),
	(20239,869,'expiration__show','1',0),
	(20240,869,'closure_date__show','1',0),
	(20241,869,'status__show','1',0),
	(20242,869,'SecurityPolicy__show','1',0),
	(20243,869,'Asset__show','1',0),
	(20244,869,'_limit','-1',0),
	(20245,869,'_order_column','created',0),
	(20246,869,'_order_direction','DESC',0),
	(20247,870,'advanced_filter','1',0),
	(20248,870,'title__show','1',0),
	(20249,870,'Requestor__show','1',0),
	(20250,870,'expiration__show','1',0),
	(20251,870,'closure_date__show','1',0),
	(20252,870,'status__show','1',0),
	(20253,870,'SecurityPolicy__show','1',0),
	(20254,870,'Asset__show','1',0),
	(20255,870,'_limit','-1',0),
	(20256,870,'_order_column','title',0),
	(20257,870,'_order_direction','ASC',0),
	(20258,870,'expiration','_plus_14_days_',0),
	(20259,870,'expiration__comp_type','2',0),
	(20260,870,'expiration__use_calendar','0',0),
	(20261,870,'status__comp_type','0',0),
	(20262,870,'status','1',0),
	(20263,871,'advanced_filter','1',0),
	(20264,871,'title__show','1',0),
	(20265,871,'Requestor__show','1',0),
	(20266,871,'expiration__show','1',0),
	(20267,871,'closure_date__show','1',0),
	(20268,871,'status__show','1',0),
	(20269,871,'SecurityPolicy__show','1',0),
	(20270,871,'Asset__show','1',0),
	(20271,871,'_limit','-1',0),
	(20272,871,'_order_column','title',0),
	(20273,871,'_order_direction','ASC',0),
	(20274,871,'ObjectStatus_expired','1',0),
	(20275,871,'ObjectStatus_expired__show','1',0),
	(20276,872,'advanced_filter','1',0),
	(20277,872,'id__show','0',0),
	(20278,872,'title__show','1',0),
	(20279,872,'goal__show','0',0),
	(20280,872,'start__show','0',0),
	(20281,872,'deadline__show','0',0),
	(20282,872,'Owner__show','0',0),
	(20283,872,'ultimate_completion__show','0',0),
	(20284,872,'plan_budget__show','0',0),
	(20285,872,'Tag-title__show','0',0),
	(20286,872,'project_status_id__show','0',0),
	(20287,872,'ObjectStatus_expired__show','0',0),
	(20288,872,'ObjectStatus_expired_tasks__show','0',0),
	(20289,872,'ObjectStatus_no_updates__show','0',0),
	(20290,872,'ProjectAchievement-description__show','0',0),
	(20291,872,'ProjectExpense-description__show','0',0),
	(20292,872,'SecurityService__show','0',0),
	(20293,872,'SecurityService-objective__show','0',0),
	(20294,872,'Risk__show','0',0),
	(20295,872,'ThirdPartyRisk__show','0',0),
	(20296,872,'BusinessContinuity__show','0',0),
	(20297,872,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(20298,872,'CompliancePackage-package_id__show','0',0),
	(20299,872,'CompliancePackage-name__show','0',0),
	(20300,872,'CompliancePackageItem-item_id__show','0',0),
	(20301,872,'CompliancePackageItem-name__show','0',0),
	(20302,872,'SecurityPolicy__show','0',0),
	(20303,872,'DataAsset__show','0',0),
	(20304,872,'created__show','0',0),
	(20305,872,'modified__show','0',0),
	(20306,872,'comment_message__show','1',0),
	(20307,872,'last_comment__show','0',0),
	(20308,872,'attachment_filename__show','0',0),
	(20309,872,'last_attachment__show','0',0),
	(20310,872,'_limit','-1',0),
	(20311,872,'_order_column','title',0),
	(20312,872,'_order_direction','ASC',0),
	(20313,872,'last_comment','_minus_1_days_',0),
	(20314,872,'last_comment__comp_type','1',0),
	(20315,873,'advanced_filter','1',0),
	(20316,873,'id__show','0',0),
	(20317,873,'title__show','1',0),
	(20318,873,'goal__show','0',0),
	(20319,873,'start__show','0',0),
	(20320,873,'deadline__show','0',0),
	(20321,873,'Owner__show','0',0),
	(20322,873,'ultimate_completion__show','0',0),
	(20323,873,'plan_budget__show','0',0),
	(20324,873,'Tag-title__show','0',0),
	(20325,873,'project_status_id__show','0',0),
	(20326,873,'ObjectStatus_expired__show','0',0),
	(20327,873,'ObjectStatus_expired_tasks__show','0',0),
	(20328,873,'ObjectStatus_no_updates__show','0',0),
	(20329,873,'ProjectAchievement-description__show','0',0),
	(20330,873,'ProjectExpense-description__show','0',0),
	(20331,873,'SecurityService__show','0',0),
	(20332,873,'SecurityService-objective__show','0',0),
	(20333,873,'Risk__show','0',0),
	(20334,873,'ThirdPartyRisk__show','0',0),
	(20335,873,'BusinessContinuity__show','0',0),
	(20336,873,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(20337,873,'CompliancePackage-package_id__show','0',0),
	(20338,873,'CompliancePackage-name__show','0',0),
	(20339,873,'CompliancePackageItem-item_id__show','0',0),
	(20340,873,'CompliancePackageItem-name__show','0',0),
	(20341,873,'SecurityPolicy__show','0',0),
	(20342,873,'DataAsset__show','0',0),
	(20343,873,'created__show','0',0),
	(20344,873,'modified__show','0',0),
	(20345,873,'comment_message__show','0',0),
	(20346,873,'last_comment__show','0',0),
	(20347,873,'attachment_filename__show','1',0),
	(20348,873,'last_attachment__show','0',0),
	(20349,873,'_limit','-1',0),
	(20350,873,'_order_column','title',0),
	(20351,873,'_order_direction','ASC',0),
	(20352,873,'last_attachment','_minus_1_days_',0),
	(20353,873,'last_attachment__comp_type','1',0),
	(20354,874,'advanced_filter','1',0),
	(20355,874,'id__show','0',0),
	(20356,874,'title__show','1',0),
	(20357,874,'goal__show','0',0),
	(20358,874,'start__show','0',0),
	(20359,874,'deadline__show','0',0),
	(20360,874,'Owner__show','0',0),
	(20361,874,'ultimate_completion__show','0',0),
	(20362,874,'plan_budget__show','0',0),
	(20363,874,'Tag-title__show','0',0),
	(20364,874,'project_status_id__show','0',0),
	(20365,874,'ObjectStatus_expired__show','0',0),
	(20366,874,'ObjectStatus_expired_tasks__show','0',0),
	(20367,874,'ObjectStatus_no_updates__show','0',0),
	(20368,874,'ProjectAchievement-description__show','0',0),
	(20369,874,'ProjectExpense-description__show','0',0),
	(20370,874,'SecurityService__show','0',0),
	(20371,874,'SecurityService-objective__show','0',0),
	(20372,874,'Risk__show','0',0),
	(20373,874,'ThirdPartyRisk__show','0',0),
	(20374,874,'BusinessContinuity__show','0',0),
	(20375,874,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(20376,874,'CompliancePackage-package_id__show','0',0),
	(20377,874,'CompliancePackage-name__show','0',0),
	(20378,874,'CompliancePackageItem-item_id__show','0',0),
	(20379,874,'CompliancePackageItem-name__show','0',0),
	(20380,874,'SecurityPolicy__show','0',0),
	(20381,874,'DataAsset__show','0',0),
	(20382,874,'created__show','0',0),
	(20383,874,'modified__show','0',0),
	(20384,874,'comment_message__show','0',0),
	(20385,874,'last_comment__show','0',0),
	(20386,874,'attachment_filename__show','0',0),
	(20387,874,'last_attachment__show','0',0),
	(20388,874,'_limit','-1',0),
	(20389,874,'_order_column','title',0),
	(20390,874,'_order_direction','ASC',0),
	(20391,874,'modified','_minus_1_days_',0),
	(20392,874,'modified__comp_type','1',0),
	(20393,875,'advanced_filter','1',0),
	(20394,875,'id__show','0',0),
	(20395,875,'title__show','1',0),
	(20396,875,'goal__show','0',0),
	(20397,875,'start__show','0',0),
	(20398,875,'deadline__show','0',0),
	(20399,875,'Owner__show','0',0),
	(20400,875,'ultimate_completion__show','0',0),
	(20401,875,'plan_budget__show','0',0),
	(20402,875,'Tag-title__show','0',0),
	(20403,875,'project_status_id__show','0',0),
	(20404,875,'ObjectStatus_expired__show','0',0),
	(20405,875,'ObjectStatus_expired_tasks__show','0',0),
	(20406,875,'ObjectStatus_no_updates__show','0',0),
	(20407,875,'ProjectAchievement-description__show','0',0),
	(20408,875,'ProjectExpense-description__show','0',0),
	(20409,875,'SecurityService__show','0',0),
	(20410,875,'SecurityService-objective__show','0',0),
	(20411,875,'Risk__show','0',0),
	(20412,875,'ThirdPartyRisk__show','0',0),
	(20413,875,'BusinessContinuity__show','0',0),
	(20414,875,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(20415,875,'CompliancePackage-package_id__show','0',0),
	(20416,875,'CompliancePackage-name__show','0',0),
	(20417,875,'CompliancePackageItem-item_id__show','0',0),
	(20418,875,'CompliancePackageItem-name__show','0',0),
	(20419,875,'SecurityPolicy__show','0',0),
	(20420,875,'DataAsset__show','0',0),
	(20421,875,'created__show','0',0),
	(20422,875,'modified__show','0',0),
	(20423,875,'comment_message__show','0',0),
	(20424,875,'last_comment__show','0',0),
	(20425,875,'attachment_filename__show','0',0),
	(20426,875,'last_attachment__show','0',0),
	(20427,875,'_limit','-1',0),
	(20428,875,'_order_column','title',0),
	(20429,875,'_order_direction','ASC',0),
	(20430,875,'created','_minus_1_days_',0),
	(20431,875,'created__comp_type','1',0),
	(20432,876,'advanced_filter','1',0),
	(20433,876,'title__show','1',0),
	(20434,876,'start__show','1',0),
	(20435,876,'deadline__show','1',0),
	(20436,876,'Owner__show','1',0),
	(20437,876,'plan_budget__show','1',0),
	(20438,876,'Tag-title__show','1',0),
	(20439,876,'project_status_id__show','1',0),
	(20440,876,'ProjectAchievement-description__show','1',0),
	(20441,876,'ProjectExpense-description__show','1',0),
	(20442,876,'_limit','-1',0),
	(20443,876,'_order_column','created',0),
	(20444,876,'_order_direction','DESC',0),
	(20445,877,'advanced_filter','1',0),
	(20446,877,'title__show','1',0),
	(20447,877,'start__show','1',0),
	(20448,877,'deadline__show','1',0),
	(20449,877,'Owner__show','1',0),
	(20450,877,'plan_budget__show','1',0),
	(20451,877,'Tag-title__show','1',0),
	(20452,877,'project_status_id__show','1',0),
	(20453,877,'ProjectAchievement-description__show','1',0),
	(20454,877,'ProjectExpense-description__show','1',0),
	(20455,877,'_limit','-1',0),
	(20456,877,'_order_column','title',0),
	(20457,877,'_order_direction','ASC',0),
	(20458,877,'project_status_id','2',0),
	(20459,877,'project_status_id__show','1',0),
	(20460,877,'ObjectStatus_expired_tasks','1',0),
	(20461,877,'ObjectStatus_expired_tasks__show','1',0),
	(20462,878,'advanced_filter','1',0),
	(20463,878,'title__show','1',0),
	(20464,878,'start__show','1',0),
	(20465,878,'deadline__show','1',0),
	(20466,878,'Owner__show','1',0),
	(20467,878,'plan_budget__show','1',0),
	(20468,878,'Tag-title__show','1',0),
	(20469,878,'project_status_id__show','1',0),
	(20470,878,'ProjectAchievement-description__show','1',0),
	(20471,878,'ProjectExpense-description__show','1',0),
	(20472,878,'_limit','-1',0),
	(20473,878,'_order_column','title',0),
	(20474,878,'_order_direction','ASC',0),
	(20475,878,'project_status_id','2',0),
	(20476,878,'project_status_id__show','1',0),
	(20477,878,'ObjectStatus_expired','1',0),
	(20478,878,'ObjectStatus_expired__show','1',0),
	(20479,879,'advanced_filter','1',0),
	(20480,879,'title__show','1',0),
	(20481,879,'start__show','1',0),
	(20482,879,'deadline__show','1',0),
	(20483,879,'Owner__show','1',0),
	(20484,879,'plan_budget__show','1',0),
	(20485,879,'Tag-title__show','1',0),
	(20486,879,'project_status_id__show','1',0),
	(20487,879,'ProjectAchievement-description__show','1',0),
	(20488,879,'ProjectExpense-description__show','1',0),
	(20489,879,'_limit','-1',0),
	(20490,879,'_order_column','title',0),
	(20491,879,'_order_direction','ASC',0),
	(20492,879,'project_status_id','2',0),
	(20493,879,'project_status_id__show','1',0),
	(20494,879,'ObjectStatus_no_updates','1',0),
	(20495,879,'ObjectStatus_no_updates__show','1',0),
	(20496,880,'advanced_filter','1',0),
	(20497,880,'title__show','1',0),
	(20498,880,'start__show','1',0),
	(20499,880,'deadline__show','1',0),
	(20500,880,'Owner__show','1',0),
	(20501,880,'plan_budget__show','1',0),
	(20502,880,'Tag-title__show','1',0),
	(20503,880,'project_status_id__show','1',0),
	(20504,880,'ProjectAchievement-description__show','1',0),
	(20505,880,'ProjectExpense-description__show','1',0),
	(20506,880,'_limit','-1',0),
	(20507,880,'_order_column','title',0),
	(20508,880,'_order_direction','ASC',0),
	(20509,880,'project_status_id','2',0),
	(20510,880,'project_status_id__show','1',0),
	(20511,881,'advanced_filter','1',0),
	(20512,881,'title__show','1',0),
	(20513,881,'start__show','1',0),
	(20514,881,'deadline__show','1',0),
	(20515,881,'Owner__show','1',0),
	(20516,881,'plan_budget__show','1',0),
	(20517,881,'Tag-title__show','1',0),
	(20518,881,'project_status_id__show','1',0),
	(20519,881,'ProjectAchievement-description__show','1',0),
	(20520,881,'ProjectExpense-description__show','1',0),
	(20521,881,'_limit','-1',0),
	(20522,881,'_order_column','title',0),
	(20523,881,'_order_direction','ASC',0),
	(20524,881,'project_status_id','3',0),
	(20525,881,'project_status_id__show','1',0),
	(20526,882,'advanced_filter','1',0),
	(20527,882,'title__show','1',0),
	(20528,882,'start__show','1',0),
	(20529,882,'deadline__show','1',0),
	(20530,882,'Owner__show','1',0),
	(20531,882,'plan_budget__show','1',0),
	(20532,882,'Tag-title__show','1',0),
	(20533,882,'project_status_id__show','1',0),
	(20534,882,'ProjectAchievement-description__show','1',0),
	(20535,882,'ProjectExpense-description__show','1',0),
	(20536,882,'_limit','-1',0),
	(20537,882,'_order_column','title',0),
	(20538,882,'_order_direction','ASC',0),
	(20539,882,'project_status_id','1',0),
	(20540,882,'project_status_id__show','1',0),
	(20541,883,'advanced_filter','1',0),
	(20542,883,'id__show','0',0),
	(20543,883,'TaskOwner__show','0',0),
	(20544,883,'completion__show','0',0),
	(20545,883,'date__show','0',0),
	(20546,883,'task_order__show','0',0),
	(20547,883,'description__show','1',0),
	(20548,883,'ObjectStatus_expired__show','0',0),
	(20549,883,'project_id__show','0',0),
	(20550,883,'Project-Owner__show','0',0),
	(20551,883,'Project-goal__show','0',0),
	(20552,883,'Project-start__show','0',0),
	(20553,883,'Project-deadline__show','0',0),
	(20554,883,'Project-project_status_id__show','0',0),
	(20555,883,'created__show','0',0),
	(20556,883,'modified__show','0',0),
	(20557,883,'comment_message__show','1',0),
	(20558,883,'last_comment__show','0',0),
	(20559,883,'attachment_filename__show','0',0),
	(20560,883,'last_attachment__show','0',0),
	(20561,883,'_limit','-1',0),
	(20562,883,'_order_column','description',0),
	(20563,883,'_order_direction','ASC',0),
	(20564,883,'last_comment','_minus_1_days_',0),
	(20565,883,'last_comment__comp_type','1',0),
	(20566,884,'advanced_filter','1',0),
	(20567,884,'id__show','0',0),
	(20568,884,'TaskOwner__show','0',0),
	(20569,884,'completion__show','0',0),
	(20570,884,'date__show','0',0),
	(20571,884,'task_order__show','0',0),
	(20572,884,'description__show','1',0),
	(20573,884,'ObjectStatus_expired__show','0',0),
	(20574,884,'project_id__show','0',0),
	(20575,884,'Project-Owner__show','0',0),
	(20576,884,'Project-goal__show','0',0),
	(20577,884,'Project-start__show','0',0),
	(20578,884,'Project-deadline__show','0',0),
	(20579,884,'Project-project_status_id__show','0',0),
	(20580,884,'created__show','0',0),
	(20581,884,'modified__show','0',0),
	(20582,884,'comment_message__show','0',0),
	(20583,884,'last_comment__show','0',0),
	(20584,884,'attachment_filename__show','1',0),
	(20585,884,'last_attachment__show','0',0),
	(20586,884,'_limit','-1',0),
	(20587,884,'_order_column','description',0),
	(20588,884,'_order_direction','ASC',0),
	(20589,884,'last_attachment','_minus_1_days_',0),
	(20590,884,'last_attachment__comp_type','1',0),
	(20591,885,'advanced_filter','1',0),
	(20592,885,'id__show','0',0),
	(20593,885,'TaskOwner__show','0',0),
	(20594,885,'completion__show','0',0),
	(20595,885,'date__show','0',0),
	(20596,885,'task_order__show','0',0),
	(20597,885,'description__show','1',0),
	(20598,885,'ObjectStatus_expired__show','0',0),
	(20599,885,'project_id__show','0',0),
	(20600,885,'Project-Owner__show','0',0),
	(20601,885,'Project-goal__show','0',0),
	(20602,885,'Project-start__show','0',0),
	(20603,885,'Project-deadline__show','0',0),
	(20604,885,'Project-project_status_id__show','0',0),
	(20605,885,'created__show','0',0),
	(20606,885,'modified__show','0',0),
	(20607,885,'comment_message__show','0',0),
	(20608,885,'last_comment__show','0',0),
	(20609,885,'attachment_filename__show','0',0),
	(20610,885,'last_attachment__show','0',0),
	(20611,885,'_limit','-1',0),
	(20612,885,'_order_column','description',0),
	(20613,885,'_order_direction','ASC',0),
	(20614,885,'modified','_minus_1_days_',0),
	(20615,885,'modified__comp_type','1',0),
	(20616,886,'advanced_filter','1',0),
	(20617,886,'id__show','0',0),
	(20618,886,'TaskOwner__show','0',0),
	(20619,886,'completion__show','0',0),
	(20620,886,'date__show','0',0),
	(20621,886,'task_order__show','0',0),
	(20622,886,'description__show','1',0),
	(20623,886,'ObjectStatus_expired__show','0',0),
	(20624,886,'project_id__show','0',0),
	(20625,886,'Project-Owner__show','0',0),
	(20626,886,'Project-goal__show','0',0),
	(20627,886,'Project-start__show','0',0),
	(20628,886,'Project-deadline__show','0',0),
	(20629,886,'Project-project_status_id__show','0',0),
	(20630,886,'created__show','0',0),
	(20631,886,'modified__show','0',0),
	(20632,886,'comment_message__show','0',0),
	(20633,886,'last_comment__show','0',0),
	(20634,886,'attachment_filename__show','0',0),
	(20635,886,'last_attachment__show','0',0),
	(20636,886,'_limit','-1',0),
	(20637,886,'_order_column','description',0),
	(20638,886,'_order_direction','ASC',0),
	(20639,886,'created','_minus_1_days_',0),
	(20640,886,'created__comp_type','1',0),
	(20641,887,'advanced_filter','1',0),
	(20642,887,'TaskOwner__show','1',0),
	(20643,887,'completion__show','1',0),
	(20644,887,'date__show','1',0),
	(20645,887,'task_order__show','1',0),
	(20646,887,'description__show','1',0),
	(20647,887,'ObjectStatus_expired__show','1',0),
	(20648,887,'project_id__show','1',0),
	(20649,887,'Project-Owner__show','1',0),
	(20650,887,'Project-goal__show','1',0),
	(20651,887,'Project-start__show','1',0),
	(20652,887,'Project-deadline__show','1',0),
	(20653,887,'Project-project_status_id__show','1',0),
	(20654,887,'_limit','-1',0),
	(20655,887,'_order_column','created',0),
	(20656,887,'_order_direction','DESC',0),
	(20657,888,'advanced_filter','1',0),
	(20658,888,'TaskOwner__show','1',0),
	(20659,888,'completion__show','1',0),
	(20660,888,'date__show','1',0),
	(20661,888,'task_order__show','1',0),
	(20662,888,'description__show','1',0),
	(20663,888,'ObjectStatus_expired__show','1',0),
	(20664,888,'project_id__show','1',0),
	(20665,888,'Project-Owner__show','1',0),
	(20666,888,'Project-goal__show','1',0),
	(20667,888,'Project-start__show','1',0),
	(20668,888,'Project-deadline__show','1',0),
	(20669,888,'Project-project_status_id__show','1',0),
	(20670,888,'_limit','-1',0),
	(20671,888,'_order_column','description',0),
	(20672,888,'_order_direction','ASC',0),
	(20673,888,'completion__comp_type','2',0),
	(20674,888,'completion','100',0),
	(20675,889,'advanced_filter','1',0),
	(20676,889,'TaskOwner__show','1',0),
	(20677,889,'completion__show','1',0),
	(20678,889,'date__show','1',0),
	(20679,889,'task_order__show','1',0),
	(20680,889,'description__show','1',0),
	(20681,889,'ObjectStatus_expired__show','1',0),
	(20682,889,'project_id__show','1',0),
	(20683,889,'Project-Owner__show','1',0),
	(20684,889,'Project-goal__show','1',0),
	(20685,889,'Project-start__show','1',0),
	(20686,889,'Project-deadline__show','1',0),
	(20687,889,'Project-project_status_id__show','1',0),
	(20688,889,'_limit','-1',0),
	(20689,889,'_order_column','description',0),
	(20690,889,'_order_direction','ASC',0),
	(20691,889,'date__comp_type','2',0),
	(20692,889,'date__use_calendar','0',0),
	(20693,889,'date','_today_',0),
	(20694,889,'completion__comp_type','2',0),
	(20695,889,'completion','100',0),
	(20696,890,'advanced_filter','1',0),
	(20697,890,'id__show','0',0),
	(20698,890,'amount__show','0',0),
	(20699,890,'description__show','1',0),
	(20700,890,'date__show','0',0),
	(20701,890,'project_id__show','0',0),
	(20702,890,'Project-Owner__show','0',0),
	(20703,890,'Project-goal__show','0',0),
	(20704,890,'Project-start__show','0',0),
	(20705,890,'Project-deadline__show','0',0),
	(20706,890,'Project-project_status_id__show','0',0),
	(20707,890,'created__show','0',0),
	(20708,890,'modified__show','0',0),
	(20709,890,'comment_message__show','1',0),
	(20710,890,'last_comment__show','0',0),
	(20711,890,'attachment_filename__show','0',0),
	(20712,890,'last_attachment__show','0',0),
	(20713,890,'_limit','-1',0),
	(20714,890,'_order_column','description',0),
	(20715,890,'_order_direction','ASC',0),
	(20716,890,'last_comment','_minus_1_days_',0),
	(20717,890,'last_comment__comp_type','1',0),
	(20718,891,'advanced_filter','1',0),
	(20719,891,'id__show','0',0),
	(20720,891,'amount__show','0',0),
	(20721,891,'description__show','1',0),
	(20722,891,'date__show','0',0),
	(20723,891,'project_id__show','0',0),
	(20724,891,'Project-Owner__show','0',0),
	(20725,891,'Project-goal__show','0',0),
	(20726,891,'Project-start__show','0',0),
	(20727,891,'Project-deadline__show','0',0),
	(20728,891,'Project-project_status_id__show','0',0),
	(20729,891,'created__show','0',0),
	(20730,891,'modified__show','0',0),
	(20731,891,'comment_message__show','0',0),
	(20732,891,'last_comment__show','0',0),
	(20733,891,'attachment_filename__show','1',0),
	(20734,891,'last_attachment__show','0',0),
	(20735,891,'_limit','-1',0),
	(20736,891,'_order_column','description',0),
	(20737,891,'_order_direction','ASC',0),
	(20738,891,'last_attachment','_minus_1_days_',0),
	(20739,891,'last_attachment__comp_type','1',0),
	(20740,892,'advanced_filter','1',0),
	(20741,892,'id__show','0',0),
	(20742,892,'amount__show','0',0),
	(20743,892,'description__show','1',0),
	(20744,892,'date__show','0',0),
	(20745,892,'project_id__show','0',0),
	(20746,892,'Project-Owner__show','0',0),
	(20747,892,'Project-goal__show','0',0),
	(20748,892,'Project-start__show','0',0),
	(20749,892,'Project-deadline__show','0',0),
	(20750,892,'Project-project_status_id__show','0',0),
	(20751,892,'created__show','0',0),
	(20752,892,'modified__show','0',0),
	(20753,892,'comment_message__show','0',0),
	(20754,892,'last_comment__show','0',0),
	(20755,892,'attachment_filename__show','0',0),
	(20756,892,'last_attachment__show','0',0),
	(20757,892,'_limit','-1',0),
	(20758,892,'_order_column','description',0),
	(20759,892,'_order_direction','ASC',0),
	(20760,892,'modified','_minus_1_days_',0),
	(20761,892,'modified__comp_type','1',0),
	(20762,893,'advanced_filter','1',0),
	(20763,893,'id__show','0',0),
	(20764,893,'amount__show','0',0),
	(20765,893,'description__show','1',0),
	(20766,893,'date__show','0',0),
	(20767,893,'project_id__show','0',0),
	(20768,893,'Project-Owner__show','0',0),
	(20769,893,'Project-goal__show','0',0),
	(20770,893,'Project-start__show','0',0),
	(20771,893,'Project-deadline__show','0',0),
	(20772,893,'Project-project_status_id__show','0',0),
	(20773,893,'created__show','0',0),
	(20774,893,'modified__show','0',0),
	(20775,893,'comment_message__show','0',0),
	(20776,893,'last_comment__show','0',0),
	(20777,893,'attachment_filename__show','0',0),
	(20778,893,'last_attachment__show','0',0),
	(20779,893,'_limit','-1',0),
	(20780,893,'_order_column','description',0),
	(20781,893,'_order_direction','ASC',0),
	(20782,893,'created','_minus_1_days_',0),
	(20783,893,'created__comp_type','1',0),
	(20784,894,'advanced_filter','1',0),
	(20785,894,'amount__show','1',0),
	(20786,894,'description__show','1',0),
	(20787,894,'date__show','1',0),
	(20788,894,'project_id__show','1',0),
	(20789,894,'Project-Owner__show','1',0),
	(20790,894,'Project-goal__show','1',0),
	(20791,894,'Project-start__show','1',0),
	(20792,894,'Project-deadline__show','1',0),
	(20793,894,'Project-project_status_id__show','1',0),
	(20794,894,'_limit','-1',0),
	(20795,894,'_order_column','created',0),
	(20796,894,'_order_direction','DESC',0),
	(20797,895,'advanced_filter','1',0),
	(20798,895,'id__show','0',0),
	(20799,895,'foreign_key__show','0',0),
	(20800,895,'date_start__show','0',0),
	(20801,895,'date_end__show','0',0),
	(20802,895,'user_id__show','0',0),
	(20803,895,'description__show','1',0),
	(20804,895,'status__show','0',0),
	(20805,895,'created__show','0',0),
	(20806,895,'modified__show','0',0),
	(20807,895,'comment_message__show','1',0),
	(20808,895,'last_comment__show','0',0),
	(20809,895,'attachment_filename__show','0',0),
	(20810,895,'last_attachment__show','0',0),
	(20811,895,'_limit','-1',0),
	(20812,895,'_order_column','description',0),
	(20813,895,'_order_direction','ASC',0),
	(20814,895,'last_comment','_minus_1_days_',0),
	(20815,895,'last_comment__comp_type','1',0),
	(20816,896,'advanced_filter','1',0),
	(20817,896,'id__show','0',0),
	(20818,896,'foreign_key__show','0',0),
	(20819,896,'date_start__show','0',0),
	(20820,896,'date_end__show','0',0),
	(20821,896,'user_id__show','0',0),
	(20822,896,'description__show','1',0),
	(20823,896,'status__show','0',0),
	(20824,896,'created__show','0',0),
	(20825,896,'modified__show','0',0),
	(20826,896,'comment_message__show','0',0),
	(20827,896,'last_comment__show','0',0),
	(20828,896,'attachment_filename__show','1',0),
	(20829,896,'last_attachment__show','0',0),
	(20830,896,'_limit','-1',0),
	(20831,896,'_order_column','description',0),
	(20832,896,'_order_direction','ASC',0),
	(20833,896,'last_attachment','_minus_1_days_',0),
	(20834,896,'last_attachment__comp_type','1',0),
	(20835,897,'advanced_filter','1',0),
	(20836,897,'id__show','0',0),
	(20837,897,'foreign_key__show','0',0),
	(20838,897,'date_start__show','0',0),
	(20839,897,'date_end__show','0',0),
	(20840,897,'user_id__show','0',0),
	(20841,897,'description__show','1',0),
	(20842,897,'status__show','0',0),
	(20843,897,'created__show','0',0),
	(20844,897,'modified__show','0',0),
	(20845,897,'comment_message__show','0',0),
	(20846,897,'last_comment__show','0',0),
	(20847,897,'attachment_filename__show','0',0),
	(20848,897,'last_attachment__show','0',0),
	(20849,897,'_limit','-1',0),
	(20850,897,'_order_column','description',0),
	(20851,897,'_order_direction','ASC',0),
	(20852,897,'modified','_minus_1_days_',0),
	(20853,897,'modified__comp_type','1',0),
	(20854,898,'advanced_filter','1',0),
	(20855,898,'id__show','0',0),
	(20856,898,'foreign_key__show','0',0),
	(20857,898,'date_start__show','0',0),
	(20858,898,'date_end__show','0',0),
	(20859,898,'user_id__show','0',0),
	(20860,898,'description__show','1',0),
	(20861,898,'status__show','0',0),
	(20862,898,'created__show','0',0),
	(20863,898,'modified__show','0',0),
	(20864,898,'comment_message__show','0',0),
	(20865,898,'last_comment__show','0',0),
	(20866,898,'attachment_filename__show','0',0),
	(20867,898,'last_attachment__show','0',0),
	(20868,898,'_limit','-1',0),
	(20869,898,'_order_column','description',0),
	(20870,898,'_order_direction','ASC',0),
	(20871,898,'created','_minus_1_days_',0),
	(20872,898,'created__comp_type','1',0),
	(20873,899,'advanced_filter','1',0),
	(20874,899,'date_start__show','1',0),
	(20875,899,'date_end__show','1',0),
	(20876,899,'user_id__show','1',0),
	(20877,899,'description__show','1',0),
	(20878,899,'status__show','1',0),
	(20879,899,'_limit','-1',0),
	(20880,899,'_order_column','created',0),
	(20881,899,'_order_direction','DESC',0),
	(20882,900,'advanced_filter','1',0),
	(20883,900,'id__show','0',0),
	(20884,900,'version__show','1',0),
	(20885,900,'description__show','0',0),
	(20886,900,'status__show','0',0),
	(20887,900,'created__show','0',0),
	(20888,900,'modified__show','0',0),
	(20889,900,'comment_message__show','1',0),
	(20890,900,'last_comment__show','0',0),
	(20891,900,'attachment_filename__show','0',0),
	(20892,900,'last_attachment__show','0',0),
	(20893,900,'_limit','-1',0),
	(20894,900,'_order_column','version',0),
	(20895,900,'_order_direction','ASC',0),
	(20896,900,'last_comment','_minus_1_days_',0),
	(20897,900,'last_comment__comp_type','1',0),
	(20898,901,'advanced_filter','1',0),
	(20899,901,'id__show','0',0),
	(20900,901,'version__show','1',0),
	(20901,901,'description__show','0',0),
	(20902,901,'status__show','0',0),
	(20903,901,'created__show','0',0),
	(20904,901,'modified__show','0',0),
	(20905,901,'comment_message__show','0',0),
	(20906,901,'last_comment__show','0',0),
	(20907,901,'attachment_filename__show','1',0),
	(20908,901,'last_attachment__show','0',0),
	(20909,901,'_limit','-1',0),
	(20910,901,'_order_column','version',0),
	(20911,901,'_order_direction','ASC',0),
	(20912,901,'last_attachment','_minus_1_days_',0),
	(20913,901,'last_attachment__comp_type','1',0),
	(20914,902,'advanced_filter','1',0),
	(20915,902,'id__show','0',0),
	(20916,902,'version__show','1',0),
	(20917,902,'description__show','0',0),
	(20918,902,'status__show','0',0),
	(20919,902,'created__show','0',0),
	(20920,902,'modified__show','0',0),
	(20921,902,'comment_message__show','0',0),
	(20922,902,'last_comment__show','0',0),
	(20923,902,'attachment_filename__show','0',0),
	(20924,902,'last_attachment__show','0',0),
	(20925,902,'_limit','-1',0),
	(20926,902,'_order_column','version',0),
	(20927,902,'_order_direction','ASC',0),
	(20928,902,'modified','_minus_1_days_',0),
	(20929,902,'modified__comp_type','1',0),
	(20930,903,'advanced_filter','1',0),
	(20931,903,'id__show','0',0),
	(20932,903,'version__show','1',0),
	(20933,903,'description__show','0',0),
	(20934,903,'status__show','0',0),
	(20935,903,'created__show','0',0),
	(20936,903,'modified__show','0',0),
	(20937,903,'comment_message__show','0',0),
	(20938,903,'last_comment__show','0',0),
	(20939,903,'attachment_filename__show','0',0),
	(20940,903,'last_attachment__show','0',0),
	(20941,903,'_limit','-1',0),
	(20942,903,'_order_column','version',0),
	(20943,903,'_order_direction','ASC',0),
	(20944,903,'created','_minus_1_days_',0),
	(20945,903,'created__comp_type','1',0),
	(20946,904,'advanced_filter','1',0),
	(20947,904,'version__show','1',0),
	(20948,904,'description__show','1',0),
	(20949,904,'status__show','1',0),
	(20950,904,'_limit','-1',0),
	(20951,904,'_order_column','created',0),
	(20952,904,'_order_direction','DESC',0),
	(20953,905,'advanced_filter','1',0),
	(20954,905,'id__show','0',0),
	(20955,905,'name__show','1',0),
	(20956,905,'description__show','0',0),
	(20957,905,'issue_source__show','0',0),
	(20958,905,'ProgramIssueType-type__show','0',0),
	(20959,905,'status__show','0',0),
	(20960,905,'created__show','0',0),
	(20961,905,'modified__show','0',0),
	(20962,905,'comment_message__show','1',0),
	(20963,905,'last_comment__show','0',0),
	(20964,905,'attachment_filename__show','0',0),
	(20965,905,'last_attachment__show','0',0),
	(20966,905,'_limit','-1',0),
	(20967,905,'_order_column','name',0),
	(20968,905,'_order_direction','ASC',0),
	(20969,905,'last_comment','_minus_1_days_',0),
	(20970,905,'last_comment__comp_type','1',0),
	(20971,906,'advanced_filter','1',0),
	(20972,906,'id__show','0',0),
	(20973,906,'name__show','1',0),
	(20974,906,'description__show','0',0),
	(20975,906,'issue_source__show','0',0),
	(20976,906,'ProgramIssueType-type__show','0',0),
	(20977,906,'status__show','0',0),
	(20978,906,'created__show','0',0),
	(20979,906,'modified__show','0',0),
	(20980,906,'comment_message__show','0',0),
	(20981,906,'last_comment__show','0',0),
	(20982,906,'attachment_filename__show','1',0),
	(20983,906,'last_attachment__show','0',0),
	(20984,906,'_limit','-1',0),
	(20985,906,'_order_column','name',0),
	(20986,906,'_order_direction','ASC',0),
	(20987,906,'last_attachment','_minus_1_days_',0),
	(20988,906,'last_attachment__comp_type','1',0),
	(20989,907,'advanced_filter','1',0),
	(20990,907,'id__show','0',0),
	(20991,907,'name__show','1',0),
	(20992,907,'description__show','0',0),
	(20993,907,'issue_source__show','0',0),
	(20994,907,'ProgramIssueType-type__show','0',0),
	(20995,907,'status__show','0',0),
	(20996,907,'created__show','0',0),
	(20997,907,'modified__show','0',0),
	(20998,907,'comment_message__show','0',0),
	(20999,907,'last_comment__show','0',0),
	(21000,907,'attachment_filename__show','0',0),
	(21001,907,'last_attachment__show','0',0),
	(21002,907,'_limit','-1',0),
	(21003,907,'_order_column','name',0),
	(21004,907,'_order_direction','ASC',0),
	(21005,907,'modified','_minus_1_days_',0),
	(21006,907,'modified__comp_type','1',0),
	(21007,908,'advanced_filter','1',0),
	(21008,908,'id__show','0',0),
	(21009,908,'name__show','1',0),
	(21010,908,'description__show','0',0),
	(21011,908,'issue_source__show','0',0),
	(21012,908,'ProgramIssueType-type__show','0',0),
	(21013,908,'status__show','0',0),
	(21014,908,'created__show','0',0),
	(21015,908,'modified__show','0',0),
	(21016,908,'comment_message__show','0',0),
	(21017,908,'last_comment__show','0',0),
	(21018,908,'attachment_filename__show','0',0),
	(21019,908,'last_attachment__show','0',0),
	(21020,908,'_limit','-1',0),
	(21021,908,'_order_column','name',0),
	(21022,908,'_order_direction','ASC',0),
	(21023,908,'created','_minus_1_days_',0),
	(21024,908,'created__comp_type','1',0),
	(21025,909,'advanced_filter','1',0),
	(21026,909,'name__show','1',0),
	(21027,909,'description__show','1',0),
	(21028,909,'issue_source__show','1',0),
	(21029,909,'ProgramIssueType-type__show','1',0),
	(21030,909,'status__show','1',0),
	(21031,909,'_limit','-1',0),
	(21032,909,'_order_column','created',0),
	(21033,909,'_order_direction','DESC',0),
	(21034,910,'advanced_filter','1',0),
	(21035,910,'id__show','0',0),
	(21036,910,'user_id__show','0',0),
	(21037,910,'role__show','1',0),
	(21038,910,'responsibilities__show','0',0),
	(21039,910,'competences__show','0',0),
	(21040,910,'status__show','0',0),
	(21041,910,'created__show','0',0),
	(21042,910,'modified__show','0',0),
	(21043,910,'comment_message__show','1',0),
	(21044,910,'last_comment__show','0',0),
	(21045,910,'attachment_filename__show','0',0),
	(21046,910,'last_attachment__show','0',0),
	(21047,910,'_limit','-1',0),
	(21048,910,'_order_column','role',0),
	(21049,910,'_order_direction','ASC',0),
	(21050,910,'last_comment','_minus_1_days_',0),
	(21051,910,'last_comment__comp_type','1',0),
	(21052,911,'advanced_filter','1',0),
	(21053,911,'id__show','0',0),
	(21054,911,'user_id__show','0',0),
	(21055,911,'role__show','1',0),
	(21056,911,'responsibilities__show','0',0),
	(21057,911,'competences__show','0',0),
	(21058,911,'status__show','0',0),
	(21059,911,'created__show','0',0),
	(21060,911,'modified__show','0',0),
	(21061,911,'comment_message__show','0',0),
	(21062,911,'last_comment__show','0',0),
	(21063,911,'attachment_filename__show','1',0),
	(21064,911,'last_attachment__show','0',0),
	(21065,911,'_limit','-1',0),
	(21066,911,'_order_column','role',0),
	(21067,911,'_order_direction','ASC',0),
	(21068,911,'last_attachment','_minus_1_days_',0),
	(21069,911,'last_attachment__comp_type','1',0),
	(21070,912,'advanced_filter','1',0),
	(21071,912,'id__show','0',0),
	(21072,912,'user_id__show','0',0),
	(21073,912,'role__show','1',0),
	(21074,912,'responsibilities__show','0',0),
	(21075,912,'competences__show','0',0),
	(21076,912,'status__show','0',0),
	(21077,912,'created__show','0',0),
	(21078,912,'modified__show','0',0),
	(21079,912,'comment_message__show','0',0),
	(21080,912,'last_comment__show','0',0),
	(21081,912,'attachment_filename__show','0',0),
	(21082,912,'last_attachment__show','0',0),
	(21083,912,'_limit','-1',0),
	(21084,912,'_order_column','role',0),
	(21085,912,'_order_direction','ASC',0),
	(21086,912,'modified','_minus_1_days_',0),
	(21087,912,'modified__comp_type','1',0),
	(21088,913,'advanced_filter','1',0),
	(21089,913,'id__show','0',0),
	(21090,913,'user_id__show','0',0),
	(21091,913,'role__show','1',0),
	(21092,913,'responsibilities__show','0',0),
	(21093,913,'competences__show','0',0),
	(21094,913,'status__show','0',0),
	(21095,913,'created__show','0',0),
	(21096,913,'modified__show','0',0),
	(21097,913,'comment_message__show','0',0),
	(21098,913,'last_comment__show','0',0),
	(21099,913,'attachment_filename__show','0',0),
	(21100,913,'last_attachment__show','0',0),
	(21101,913,'_limit','-1',0),
	(21102,913,'_order_column','role',0),
	(21103,913,'_order_direction','ASC',0),
	(21104,913,'created','_minus_1_days_',0),
	(21105,913,'created__comp_type','1',0),
	(21106,914,'advanced_filter','1',0),
	(21107,914,'user_id__show','1',0),
	(21108,914,'role__show','1',0),
	(21109,914,'responsibilities__show','1',0),
	(21110,914,'competences__show','1',0),
	(21111,914,'status__show','1',0),
	(21112,914,'_limit','-1',0),
	(21113,914,'_order_column','created',0),
	(21114,914,'_order_direction','DESC',0),
	(21115,915,'advanced_filter','1',0),
	(21116,915,'id__show','0',0),
	(21117,915,'title__show','1',0),
	(21118,915,'Requestor__show','0',0),
	(21119,915,'expiration__show','0',0),
	(21120,915,'Tag-title__show','0',0),
	(21121,915,'closure_date__show','0',0),
	(21122,915,'status__show','0',0),
	(21123,915,'ObjectStatus_expired__show','0',0),
	(21124,915,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(21125,915,'CompliancePackage-package_id__show','0',0),
	(21126,915,'CompliancePackage-name__show','0',0),
	(21127,915,'CompliancePackageItem-item_id__show','0',0),
	(21128,915,'CompliancePackageItem-name__show','0',0),
	(21129,915,'created__show','0',0),
	(21130,915,'modified__show','0',0),
	(21131,915,'comment_message__show','1',0),
	(21132,915,'last_comment__show','0',0),
	(21133,915,'attachment_filename__show','0',0),
	(21134,915,'last_attachment__show','0',0),
	(21135,915,'_limit','-1',0),
	(21136,915,'_order_column','title',0),
	(21137,915,'_order_direction','ASC',0),
	(21138,915,'last_comment','_minus_1_days_',0),
	(21139,915,'last_comment__comp_type','1',0),
	(21140,916,'advanced_filter','1',0),
	(21141,916,'id__show','0',0),
	(21142,916,'title__show','1',0),
	(21143,916,'Requestor__show','0',0),
	(21144,916,'expiration__show','0',0),
	(21145,916,'Tag-title__show','0',0),
	(21146,916,'closure_date__show','0',0),
	(21147,916,'status__show','0',0),
	(21148,916,'ObjectStatus_expired__show','0',0),
	(21149,916,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(21150,916,'CompliancePackage-package_id__show','0',0),
	(21151,916,'CompliancePackage-name__show','0',0),
	(21152,916,'CompliancePackageItem-item_id__show','0',0),
	(21153,916,'CompliancePackageItem-name__show','0',0),
	(21154,916,'created__show','0',0),
	(21155,916,'modified__show','0',0),
	(21156,916,'comment_message__show','0',0),
	(21157,916,'last_comment__show','0',0),
	(21158,916,'attachment_filename__show','1',0),
	(21159,916,'last_attachment__show','0',0),
	(21160,916,'_limit','-1',0),
	(21161,916,'_order_column','title',0),
	(21162,916,'_order_direction','ASC',0),
	(21163,916,'last_attachment','_minus_1_days_',0),
	(21164,916,'last_attachment__comp_type','1',0),
	(21165,917,'advanced_filter','1',0),
	(21166,917,'id__show','0',0),
	(21167,917,'title__show','1',0),
	(21168,917,'Requestor__show','0',0),
	(21169,917,'expiration__show','0',0),
	(21170,917,'Tag-title__show','0',0),
	(21171,917,'closure_date__show','0',0),
	(21172,917,'status__show','0',0),
	(21173,917,'ObjectStatus_expired__show','0',0),
	(21174,917,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(21175,917,'CompliancePackage-package_id__show','0',0),
	(21176,917,'CompliancePackage-name__show','0',0),
	(21177,917,'CompliancePackageItem-item_id__show','0',0),
	(21178,917,'CompliancePackageItem-name__show','0',0),
	(21179,917,'created__show','0',0),
	(21180,917,'modified__show','0',0),
	(21181,917,'comment_message__show','0',0),
	(21182,917,'last_comment__show','0',0),
	(21183,917,'attachment_filename__show','0',0),
	(21184,917,'last_attachment__show','0',0),
	(21185,917,'_limit','-1',0),
	(21186,917,'_order_column','title',0),
	(21187,917,'_order_direction','ASC',0),
	(21188,917,'modified','_minus_1_days_',0),
	(21189,917,'modified__comp_type','1',0),
	(21190,918,'advanced_filter','1',0),
	(21191,918,'id__show','0',0),
	(21192,918,'title__show','1',0),
	(21193,918,'Requestor__show','0',0),
	(21194,918,'expiration__show','0',0),
	(21195,918,'Tag-title__show','0',0),
	(21196,918,'closure_date__show','0',0),
	(21197,918,'status__show','0',0),
	(21198,918,'ObjectStatus_expired__show','0',0),
	(21199,918,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(21200,918,'CompliancePackage-package_id__show','0',0),
	(21201,918,'CompliancePackage-name__show','0',0),
	(21202,918,'CompliancePackageItem-item_id__show','0',0),
	(21203,918,'CompliancePackageItem-name__show','0',0),
	(21204,918,'created__show','0',0),
	(21205,918,'modified__show','0',0),
	(21206,918,'comment_message__show','0',0),
	(21207,918,'last_comment__show','0',0),
	(21208,918,'attachment_filename__show','0',0),
	(21209,918,'last_attachment__show','0',0),
	(21210,918,'_limit','-1',0),
	(21211,918,'_order_column','title',0),
	(21212,918,'_order_direction','ASC',0),
	(21213,918,'created','_minus_1_days_',0),
	(21214,918,'created__comp_type','1',0),
	(21215,919,'advanced_filter','1',0),
	(21216,919,'title__show','1',0),
	(21217,919,'Requestor__show','1',0),
	(21218,919,'expiration__show','1',0),
	(21219,919,'Tag-title__show','1',0),
	(21220,919,'closure_date__show','1',0),
	(21221,919,'status__show','1',0),
	(21222,919,'_limit','-1',0),
	(21223,919,'_order_column','created',0),
	(21224,919,'_order_direction','DESC',0),
	(21225,920,'advanced_filter','1',0),
	(21226,920,'title__show','1',0),
	(21227,920,'Requestor__show','1',0),
	(21228,920,'expiration__show','1',0),
	(21229,920,'Tag-title__show','1',0),
	(21230,920,'closure_date__show','1',0),
	(21231,920,'status__show','1',0),
	(21232,920,'_limit','-1',0),
	(21233,920,'_order_column','title',0),
	(21234,920,'_order_direction','ASC',0),
	(21235,920,'expiration','_plus_14_days_',0),
	(21236,920,'expiration__comp_type','2',0),
	(21237,920,'expiration__use_calendar','0',0),
	(21238,920,'status__comp_type','0',0),
	(21239,920,'status','1',0),
	(21240,921,'advanced_filter','1',0),
	(21241,921,'title__show','1',0),
	(21242,921,'Requestor__show','1',0),
	(21243,921,'expiration__show','1',0),
	(21244,921,'Tag-title__show','1',0),
	(21245,921,'closure_date__show','1',0),
	(21246,921,'status__show','1',0),
	(21247,921,'_limit','-1',0),
	(21248,921,'_order_column','title',0),
	(21249,921,'_order_direction','ASC',0),
	(21250,921,'ObjectStatus_expired','1',0),
	(21251,921,'ObjectStatus_expired__show','1',0),
	(21252,922,'advanced_filter','1',0),
	(21253,922,'id__show','0',0),
	(21254,922,'name__show','1',0),
	(21255,922,'description__show','0',0),
	(21256,922,'Owner__show','0',0),
	(21257,922,'Legal__show','0',0),
	(21258,922,'publisher_name__show','0',0),
	(21259,922,'version__show','0',0),
	(21260,922,'language__show','0',0),
	(21261,922,'url__show','0',0),
	(21262,922,'restriction__show','0',0),
	(21263,922,'created__show','0',0),
	(21264,922,'modified__show','0',0),
	(21265,922,'comment_message__show','1',0),
	(21266,922,'last_comment__show','0',0),
	(21267,922,'attachment_filename__show','0',0),
	(21268,922,'last_attachment__show','0',0),
	(21269,922,'_limit','-1',0),
	(21270,922,'_order_column','name',0),
	(21271,922,'_order_direction','ASC',0),
	(21272,922,'last_comment','_minus_1_days_',0),
	(21273,922,'last_comment__comp_type','1',0),
	(21274,923,'advanced_filter','1',0),
	(21275,923,'id__show','0',0),
	(21276,923,'name__show','1',0),
	(21277,923,'description__show','0',0),
	(21278,923,'Owner__show','0',0),
	(21279,923,'Legal__show','0',0),
	(21280,923,'publisher_name__show','0',0),
	(21281,923,'version__show','0',0),
	(21282,923,'language__show','0',0),
	(21283,923,'url__show','0',0),
	(21284,923,'restriction__show','0',0),
	(21285,923,'created__show','0',0),
	(21286,923,'modified__show','0',0),
	(21287,923,'comment_message__show','0',0),
	(21288,923,'last_comment__show','0',0),
	(21289,923,'attachment_filename__show','1',0),
	(21290,923,'last_attachment__show','0',0),
	(21291,923,'_limit','-1',0),
	(21292,923,'_order_column','name',0),
	(21293,923,'_order_direction','ASC',0),
	(21294,923,'last_attachment','_minus_1_days_',0),
	(21295,923,'last_attachment__comp_type','1',0),
	(21296,924,'advanced_filter','1',0),
	(21297,924,'id__show','0',0),
	(21298,924,'name__show','1',0),
	(21299,924,'description__show','0',0),
	(21300,924,'Owner__show','0',0),
	(21301,924,'Legal__show','0',0),
	(21302,924,'publisher_name__show','0',0),
	(21303,924,'version__show','0',0),
	(21304,924,'language__show','0',0),
	(21305,924,'url__show','0',0),
	(21306,924,'restriction__show','0',0),
	(21307,924,'created__show','0',0),
	(21308,924,'modified__show','0',0),
	(21309,924,'comment_message__show','0',0),
	(21310,924,'last_comment__show','0',0),
	(21311,924,'attachment_filename__show','0',0),
	(21312,924,'last_attachment__show','0',0),
	(21313,924,'_limit','-1',0),
	(21314,924,'_order_column','name',0),
	(21315,924,'_order_direction','ASC',0),
	(21316,924,'modified','_minus_1_days_',0),
	(21317,924,'modified__comp_type','1',0),
	(21318,925,'advanced_filter','1',0),
	(21319,925,'id__show','0',0),
	(21320,925,'name__show','1',0),
	(21321,925,'description__show','0',0),
	(21322,925,'Owner__show','0',0),
	(21323,925,'Legal__show','0',0),
	(21324,925,'publisher_name__show','0',0),
	(21325,925,'version__show','0',0),
	(21326,925,'language__show','0',0),
	(21327,925,'url__show','0',0),
	(21328,925,'restriction__show','0',0),
	(21329,925,'created__show','0',0),
	(21330,925,'modified__show','0',0),
	(21331,925,'comment_message__show','0',0),
	(21332,925,'last_comment__show','0',0),
	(21333,925,'attachment_filename__show','0',0),
	(21334,925,'last_attachment__show','0',0),
	(21335,925,'_limit','-1',0),
	(21336,925,'_order_column','name',0),
	(21337,925,'_order_direction','ASC',0),
	(21338,925,'created','_minus_1_days_',0),
	(21339,925,'created__comp_type','1',0),
	(21340,926,'advanced_filter','1',0),
	(21341,926,'name__show','1',0),
	(21342,926,'description__show','1',0),
	(21343,926,'Owner__show','1',0),
	(21344,926,'Legal__show','1',0),
	(21345,926,'publisher_name__show','1',0),
	(21346,926,'version__show','1',0),
	(21347,926,'_limit','-1',0),
	(21348,926,'_order_column','created',0),
	(21349,926,'_order_direction','DESC',0),
	(21350,927,'advanced_filter','1',0),
	(21351,927,'id__show','0',0),
	(21352,927,'third_party_id__show','0',0),
	(21353,927,'package_id__show','0',0),
	(21354,927,'name__show','1',0),
	(21355,927,'description__show','0',0),
	(21356,927,'item_id__show','0',0),
	(21357,927,'item_name__show','0',0),
	(21358,927,'item_description__show','0',0),
	(21359,927,'item_audit_questionaire__show','0',0),
	(21360,927,'created__show','0',0),
	(21361,927,'modified__show','0',0),
	(21362,927,'comment_message__show','1',0),
	(21363,927,'last_comment__show','0',0),
	(21364,927,'attachment_filename__show','0',0),
	(21365,927,'last_attachment__show','0',0),
	(21366,927,'_limit','-1',0),
	(21367,927,'_order_column','name',0),
	(21368,927,'_order_direction','ASC',0),
	(21369,927,'last_comment','_minus_1_days_',0),
	(21370,927,'last_comment__comp_type','1',0),
	(21371,928,'advanced_filter','1',0),
	(21372,928,'id__show','0',0),
	(21373,928,'third_party_id__show','0',0),
	(21374,928,'package_id__show','0',0),
	(21375,928,'name__show','1',0),
	(21376,928,'description__show','0',0),
	(21377,928,'item_id__show','0',0),
	(21378,928,'item_name__show','0',0),
	(21379,928,'item_description__show','0',0),
	(21380,928,'item_audit_questionaire__show','0',0),
	(21381,928,'created__show','0',0),
	(21382,928,'modified__show','0',0),
	(21383,928,'comment_message__show','0',0),
	(21384,928,'last_comment__show','0',0),
	(21385,928,'attachment_filename__show','1',0),
	(21386,928,'last_attachment__show','0',0),
	(21387,928,'_limit','-1',0),
	(21388,928,'_order_column','name',0),
	(21389,928,'_order_direction','ASC',0),
	(21390,928,'last_attachment','_minus_1_days_',0),
	(21391,928,'last_attachment__comp_type','1',0),
	(21392,929,'advanced_filter','1',0),
	(21393,929,'id__show','0',0),
	(21394,929,'third_party_id__show','0',0),
	(21395,929,'package_id__show','0',0),
	(21396,929,'name__show','1',0),
	(21397,929,'description__show','0',0),
	(21398,929,'item_id__show','0',0),
	(21399,929,'item_name__show','0',0),
	(21400,929,'item_description__show','0',0),
	(21401,929,'item_audit_questionaire__show','0',0),
	(21402,929,'created__show','0',0),
	(21403,929,'modified__show','0',0),
	(21404,929,'comment_message__show','0',0),
	(21405,929,'last_comment__show','0',0),
	(21406,929,'attachment_filename__show','0',0),
	(21407,929,'last_attachment__show','0',0),
	(21408,929,'_limit','-1',0),
	(21409,929,'_order_column','name',0),
	(21410,929,'_order_direction','ASC',0),
	(21411,929,'modified','_minus_1_days_',0),
	(21412,929,'modified__comp_type','1',0),
	(21413,930,'advanced_filter','1',0),
	(21414,930,'id__show','0',0),
	(21415,930,'third_party_id__show','0',0),
	(21416,930,'package_id__show','0',0),
	(21417,930,'name__show','1',0),
	(21418,930,'description__show','0',0),
	(21419,930,'item_id__show','0',0),
	(21420,930,'item_name__show','0',0),
	(21421,930,'item_description__show','0',0),
	(21422,930,'item_audit_questionaire__show','0',0),
	(21423,930,'created__show','0',0),
	(21424,930,'modified__show','0',0),
	(21425,930,'comment_message__show','0',0),
	(21426,930,'last_comment__show','0',0),
	(21427,930,'attachment_filename__show','0',0),
	(21428,930,'last_attachment__show','0',0),
	(21429,930,'_limit','-1',0),
	(21430,930,'_order_column','name',0),
	(21431,930,'_order_direction','ASC',0),
	(21432,930,'created','_minus_1_days_',0),
	(21433,930,'created__comp_type','1',0),
	(21434,931,'advanced_filter','1',0),
	(21435,931,'id__show','0',0),
	(21436,931,'CompliancePackage-compliance_package_regulator_id__show','1',0),
	(21437,931,'CompliancePackage-package_id__show','0',0),
	(21438,931,'CompliancePackage-name__show','0',0),
	(21439,931,'CompliancePackage-description__show','0',0),
	(21440,931,'CompliancePackageItem-item_id__show','0',0),
	(21441,931,'CompliancePackageItem-name__show','1',0),
	(21442,931,'CompliancePackageItem-description__show','0',0),
	(21443,931,'CompliancePackageItem-audit_questionaire__show','0',0),
	(21444,931,'efficacy__show','0',0),
	(21445,931,'Owner__show','0',0),
	(21446,931,'compliance_treatment_strategy_id__show','0',0),
	(21447,931,'description__show','0',0),
	(21448,931,'Project__show','0',0),
	(21449,931,'ProjectAchievement-description__show','0',0),
	(21450,931,'ObjectStatus_project_planned__show','0',0),
	(21451,931,'ObjectStatus_project_ongoing__show','0',0),
	(21452,931,'ObjectStatus_project_closed__show','0',0),
	(21453,931,'ObjectStatus_project_expired__show','0',0),
	(21454,931,'ObjectStatus_project_expired_tasks__show','0',0),
	(21455,931,'SecurityService__show','0',0),
	(21456,931,'SecurityService-objective__show','0',0),
	(21457,931,'ObjectStatus_security_service_audits_last_not_passed__show','0',0),
	(21458,931,'ObjectStatus_security_service_audits_last_missing__show','0',0),
	(21459,931,'ObjectStatus_security_service_control_with_issues__show','0',0),
	(21460,931,'ObjectStatus_security_service_maintenances_last_missing__show','0',0),
	(21461,931,'SecurityPolicy__show','0',0),
	(21462,931,'ObjectStatus_security_policy_expired_reviews__show','0',0),
	(21463,931,'ComplianceException__show','0',0),
	(21464,931,'ComplianceException-description__show','0',0),
	(21465,931,'ComplianceException-status__show','0',0),
	(21466,931,'ObjectStatus_compliance_exception_expired__show','0',0),
	(21467,931,'Risk__show','0',0),
	(21468,931,'ThirdPartyRisk__show','0',0),
	(21469,931,'BusinessContinuity__show','0',0),
	(21470,931,'legal_id__show','0',0),
	(21471,931,'Asset__show','0',0),
	(21472,931,'ComplianceAnalysisFinding__show','0',0),
	(21473,931,'ComplianceAnalysisFinding-due_date__show','0',0),
	(21474,931,'ComplianceAnalysisFinding-status__show','0',0),
	(21475,931,'ComplianceAnalysisFinding-expired__show','0',0),
	(21476,931,'created__show','0',0),
	(21477,931,'modified__show','0',0),
	(21478,931,'comment_message__show','1',0),
	(21479,931,'last_comment__show','0',0),
	(21480,931,'attachment_filename__show','0',0),
	(21481,931,'last_attachment__show','0',0),
	(21482,931,'_limit','-1',0),
	(21483,931,'_order_column','id',0),
	(21484,931,'_order_direction','ASC',0),
	(21485,931,'last_comment','_minus_1_days_',0),
	(21486,931,'last_comment__comp_type','1',0),
	(21487,932,'advanced_filter','1',0),
	(21488,932,'id__show','0',0),
	(21489,932,'CompliancePackage-compliance_package_regulator_id__show','1',0),
	(21490,932,'CompliancePackage-package_id__show','0',0),
	(21491,932,'CompliancePackage-name__show','0',0),
	(21492,932,'CompliancePackage-description__show','0',0),
	(21493,932,'CompliancePackageItem-item_id__show','0',0),
	(21494,932,'CompliancePackageItem-name__show','1',0),
	(21495,932,'CompliancePackageItem-description__show','0',0),
	(21496,932,'CompliancePackageItem-audit_questionaire__show','0',0),
	(21497,932,'efficacy__show','0',0),
	(21498,932,'Owner__show','0',0),
	(21499,932,'compliance_treatment_strategy_id__show','0',0),
	(21500,932,'description__show','0',0),
	(21501,932,'Project__show','0',0),
	(21502,932,'ProjectAchievement-description__show','0',0),
	(21503,932,'ObjectStatus_project_planned__show','0',0),
	(21504,932,'ObjectStatus_project_ongoing__show','0',0),
	(21505,932,'ObjectStatus_project_closed__show','0',0),
	(21506,932,'ObjectStatus_project_expired__show','0',0),
	(21507,932,'ObjectStatus_project_expired_tasks__show','0',0),
	(21508,932,'SecurityService__show','0',0),
	(21509,932,'SecurityService-objective__show','0',0),
	(21510,932,'ObjectStatus_security_service_audits_last_not_passed__show','0',0),
	(21511,932,'ObjectStatus_security_service_audits_last_missing__show','0',0),
	(21512,932,'ObjectStatus_security_service_control_with_issues__show','0',0),
	(21513,932,'ObjectStatus_security_service_maintenances_last_missing__show','0',0),
	(21514,932,'SecurityPolicy__show','0',0),
	(21515,932,'ObjectStatus_security_policy_expired_reviews__show','0',0),
	(21516,932,'ComplianceException__show','0',0),
	(21517,932,'ComplianceException-description__show','0',0),
	(21518,932,'ComplianceException-status__show','0',0),
	(21519,932,'ObjectStatus_compliance_exception_expired__show','0',0),
	(21520,932,'Risk__show','0',0),
	(21521,932,'ThirdPartyRisk__show','0',0),
	(21522,932,'BusinessContinuity__show','0',0),
	(21523,932,'legal_id__show','0',0),
	(21524,932,'Asset__show','0',0),
	(21525,932,'ComplianceAnalysisFinding__show','0',0),
	(21526,932,'ComplianceAnalysisFinding-due_date__show','0',0),
	(21527,932,'ComplianceAnalysisFinding-status__show','0',0),
	(21528,932,'ComplianceAnalysisFinding-expired__show','0',0),
	(21529,932,'created__show','0',0),
	(21530,932,'modified__show','0',0),
	(21531,932,'comment_message__show','0',0),
	(21532,932,'last_comment__show','0',0),
	(21533,932,'attachment_filename__show','1',0),
	(21534,932,'last_attachment__show','0',0),
	(21535,932,'_limit','-1',0),
	(21536,932,'_order_column','id',0),
	(21537,932,'_order_direction','ASC',0),
	(21538,932,'last_attachment','_minus_1_days_',0),
	(21539,932,'last_attachment__comp_type','1',0),
	(21540,933,'advanced_filter','1',0),
	(21541,933,'id__show','0',0),
	(21542,933,'CompliancePackage-compliance_package_regulator_id__show','1',0),
	(21543,933,'CompliancePackage-package_id__show','0',0),
	(21544,933,'CompliancePackage-name__show','0',0),
	(21545,933,'CompliancePackage-description__show','0',0),
	(21546,933,'CompliancePackageItem-item_id__show','0',0),
	(21547,933,'CompliancePackageItem-name__show','1',0),
	(21548,933,'CompliancePackageItem-description__show','0',0),
	(21549,933,'CompliancePackageItem-audit_questionaire__show','0',0),
	(21550,933,'efficacy__show','0',0),
	(21551,933,'Owner__show','0',0),
	(21552,933,'compliance_treatment_strategy_id__show','0',0),
	(21553,933,'description__show','0',0),
	(21554,933,'Project__show','0',0),
	(21555,933,'ProjectAchievement-description__show','0',0),
	(21556,933,'ObjectStatus_project_planned__show','0',0),
	(21557,933,'ObjectStatus_project_ongoing__show','0',0),
	(21558,933,'ObjectStatus_project_closed__show','0',0),
	(21559,933,'ObjectStatus_project_expired__show','0',0),
	(21560,933,'ObjectStatus_project_expired_tasks__show','0',0),
	(21561,933,'SecurityService__show','0',0),
	(21562,933,'SecurityService-objective__show','0',0),
	(21563,933,'ObjectStatus_security_service_audits_last_not_passed__show','0',0),
	(21564,933,'ObjectStatus_security_service_audits_last_missing__show','0',0),
	(21565,933,'ObjectStatus_security_service_control_with_issues__show','0',0),
	(21566,933,'ObjectStatus_security_service_maintenances_last_missing__show','0',0),
	(21567,933,'SecurityPolicy__show','0',0),
	(21568,933,'ObjectStatus_security_policy_expired_reviews__show','0',0),
	(21569,933,'ComplianceException__show','0',0),
	(21570,933,'ComplianceException-description__show','0',0),
	(21571,933,'ComplianceException-status__show','0',0),
	(21572,933,'ObjectStatus_compliance_exception_expired__show','0',0),
	(21573,933,'Risk__show','0',0),
	(21574,933,'ThirdPartyRisk__show','0',0),
	(21575,933,'BusinessContinuity__show','0',0),
	(21576,933,'legal_id__show','0',0),
	(21577,933,'Asset__show','0',0),
	(21578,933,'ComplianceAnalysisFinding__show','0',0),
	(21579,933,'ComplianceAnalysisFinding-due_date__show','0',0),
	(21580,933,'ComplianceAnalysisFinding-status__show','0',0),
	(21581,933,'ComplianceAnalysisFinding-expired__show','0',0),
	(21582,933,'created__show','0',0),
	(21583,933,'modified__show','0',0),
	(21584,933,'comment_message__show','0',0),
	(21585,933,'last_comment__show','0',0),
	(21586,933,'attachment_filename__show','0',0),
	(21587,933,'last_attachment__show','0',0),
	(21588,933,'_limit','-1',0),
	(21589,933,'_order_column','id',0),
	(21590,933,'_order_direction','ASC',0),
	(21591,933,'modified','_minus_1_days_',0),
	(21592,933,'modified__comp_type','1',0),
	(21593,934,'advanced_filter','1',0),
	(21594,934,'id__show','0',0),
	(21595,934,'CompliancePackage-compliance_package_regulator_id__show','1',0),
	(21596,934,'CompliancePackage-package_id__show','0',0),
	(21597,934,'CompliancePackage-name__show','0',0),
	(21598,934,'CompliancePackage-description__show','0',0),
	(21599,934,'CompliancePackageItem-item_id__show','0',0),
	(21600,934,'CompliancePackageItem-name__show','1',0),
	(21601,934,'CompliancePackageItem-description__show','0',0),
	(21602,934,'CompliancePackageItem-audit_questionaire__show','0',0),
	(21603,934,'efficacy__show','0',0),
	(21604,934,'Owner__show','0',0),
	(21605,934,'compliance_treatment_strategy_id__show','0',0),
	(21606,934,'description__show','0',0),
	(21607,934,'Project__show','0',0),
	(21608,934,'ProjectAchievement-description__show','0',0),
	(21609,934,'ObjectStatus_project_planned__show','0',0),
	(21610,934,'ObjectStatus_project_ongoing__show','0',0),
	(21611,934,'ObjectStatus_project_closed__show','0',0),
	(21612,934,'ObjectStatus_project_expired__show','0',0),
	(21613,934,'ObjectStatus_project_expired_tasks__show','0',0),
	(21614,934,'SecurityService__show','0',0),
	(21615,934,'SecurityService-objective__show','0',0),
	(21616,934,'ObjectStatus_security_service_audits_last_not_passed__show','0',0),
	(21617,934,'ObjectStatus_security_service_audits_last_missing__show','0',0),
	(21618,934,'ObjectStatus_security_service_control_with_issues__show','0',0),
	(21619,934,'ObjectStatus_security_service_maintenances_last_missing__show','0',0),
	(21620,934,'SecurityPolicy__show','0',0),
	(21621,934,'ObjectStatus_security_policy_expired_reviews__show','0',0),
	(21622,934,'ComplianceException__show','0',0),
	(21623,934,'ComplianceException-description__show','0',0),
	(21624,934,'ComplianceException-status__show','0',0),
	(21625,934,'ObjectStatus_compliance_exception_expired__show','0',0),
	(21626,934,'Risk__show','0',0),
	(21627,934,'ThirdPartyRisk__show','0',0),
	(21628,934,'BusinessContinuity__show','0',0),
	(21629,934,'legal_id__show','0',0),
	(21630,934,'Asset__show','0',0),
	(21631,934,'ComplianceAnalysisFinding__show','0',0),
	(21632,934,'ComplianceAnalysisFinding-due_date__show','0',0),
	(21633,934,'ComplianceAnalysisFinding-status__show','0',0),
	(21634,934,'ComplianceAnalysisFinding-expired__show','0',0),
	(21635,934,'created__show','0',0),
	(21636,934,'modified__show','0',0),
	(21637,934,'comment_message__show','0',0),
	(21638,934,'last_comment__show','0',0),
	(21639,934,'attachment_filename__show','0',0),
	(21640,934,'last_attachment__show','0',0),
	(21641,934,'_limit','-1',0),
	(21642,934,'_order_column','id',0),
	(21643,934,'_order_direction','ASC',0),
	(21644,934,'created','_minus_1_days_',0),
	(21645,934,'created__comp_type','1',0),
	(21646,935,'advanced_filter','1',0),
	(21647,935,'id__show','0',0),
	(21648,935,'title__show','1',0),
	(21649,935,'description__show','0',0),
	(21650,935,'due_date__show','0',0),
	(21651,935,'Tag-title__show','0',0),
	(21652,935,'Owner__show','0',0),
	(21653,935,'Collaborator__show','0',0),
	(21654,935,'status__show','0',0),
	(21655,935,'ObjectStatus_expired__show','0',0),
	(21656,935,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(21657,935,'CompliancePackage-package_id__show','0',0),
	(21658,935,'CompliancePackage-name__show','0',0),
	(21659,935,'CompliancePackageItem-item_id__show','0',0),
	(21660,935,'CompliancePackageItem-name__show','0',0),
	(21661,935,'created__show','0',0),
	(21662,935,'modified__show','0',0),
	(21663,935,'comment_message__show','1',0),
	(21664,935,'last_comment__show','0',0),
	(21665,935,'attachment_filename__show','0',0),
	(21666,935,'last_attachment__show','0',0),
	(21667,935,'_limit','-1',0),
	(21668,935,'_order_column','title',0),
	(21669,935,'_order_direction','ASC',0),
	(21670,935,'last_comment','_minus_1_days_',0),
	(21671,935,'last_comment__comp_type','1',0),
	(21672,936,'advanced_filter','1',0),
	(21673,936,'id__show','0',0),
	(21674,936,'title__show','1',0),
	(21675,936,'description__show','0',0),
	(21676,936,'due_date__show','0',0),
	(21677,936,'Tag-title__show','0',0),
	(21678,936,'Owner__show','0',0),
	(21679,936,'Collaborator__show','0',0),
	(21680,936,'status__show','0',0),
	(21681,936,'ObjectStatus_expired__show','0',0),
	(21682,936,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(21683,936,'CompliancePackage-package_id__show','0',0),
	(21684,936,'CompliancePackage-name__show','0',0),
	(21685,936,'CompliancePackageItem-item_id__show','0',0),
	(21686,936,'CompliancePackageItem-name__show','0',0),
	(21687,936,'created__show','0',0),
	(21688,936,'modified__show','0',0),
	(21689,936,'comment_message__show','0',0),
	(21690,936,'last_comment__show','0',0),
	(21691,936,'attachment_filename__show','1',0),
	(21692,936,'last_attachment__show','0',0),
	(21693,936,'_limit','-1',0),
	(21694,936,'_order_column','title',0),
	(21695,936,'_order_direction','ASC',0),
	(21696,936,'last_attachment','_minus_1_days_',0),
	(21697,936,'last_attachment__comp_type','1',0),
	(21698,937,'advanced_filter','1',0),
	(21699,937,'id__show','0',0),
	(21700,937,'title__show','1',0),
	(21701,937,'description__show','0',0),
	(21702,937,'due_date__show','0',0),
	(21703,937,'Tag-title__show','0',0),
	(21704,937,'Owner__show','0',0),
	(21705,937,'Collaborator__show','0',0),
	(21706,937,'status__show','0',0),
	(21707,937,'ObjectStatus_expired__show','0',0),
	(21708,937,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(21709,937,'CompliancePackage-package_id__show','0',0),
	(21710,937,'CompliancePackage-name__show','0',0),
	(21711,937,'CompliancePackageItem-item_id__show','0',0),
	(21712,937,'CompliancePackageItem-name__show','0',0),
	(21713,937,'created__show','0',0),
	(21714,937,'modified__show','0',0),
	(21715,937,'comment_message__show','0',0),
	(21716,937,'last_comment__show','0',0),
	(21717,937,'attachment_filename__show','0',0),
	(21718,937,'last_attachment__show','0',0),
	(21719,937,'_limit','-1',0),
	(21720,937,'_order_column','title',0),
	(21721,937,'_order_direction','ASC',0),
	(21722,937,'modified','_minus_1_days_',0),
	(21723,937,'modified__comp_type','1',0),
	(21724,938,'advanced_filter','1',0),
	(21725,938,'id__show','0',0),
	(21726,938,'title__show','1',0),
	(21727,938,'description__show','0',0),
	(21728,938,'due_date__show','0',0),
	(21729,938,'Tag-title__show','0',0),
	(21730,938,'Owner__show','0',0),
	(21731,938,'Collaborator__show','0',0),
	(21732,938,'status__show','0',0),
	(21733,938,'ObjectStatus_expired__show','0',0),
	(21734,938,'CompliancePackage-compliance_package_regulator_id__show','0',0),
	(21735,938,'CompliancePackage-package_id__show','0',0),
	(21736,938,'CompliancePackage-name__show','0',0),
	(21737,938,'CompliancePackageItem-item_id__show','0',0),
	(21738,938,'CompliancePackageItem-name__show','0',0),
	(21739,938,'created__show','0',0),
	(21740,938,'modified__show','0',0),
	(21741,938,'comment_message__show','0',0),
	(21742,938,'last_comment__show','0',0),
	(21743,938,'attachment_filename__show','0',0),
	(21744,938,'last_attachment__show','0',0),
	(21745,938,'_limit','-1',0),
	(21746,938,'_order_column','title',0),
	(21747,938,'_order_direction','ASC',0),
	(21748,938,'created','_minus_1_days_',0),
	(21749,938,'created__comp_type','1',0),
	(21750,939,'advanced_filter','1',0),
	(21751,939,'title__show','1',0),
	(21752,939,'description__show','1',0),
	(21753,939,'due_date__show','1',0),
	(21754,939,'Tag-title__show','1',0),
	(21755,939,'Owner__show','1',0),
	(21756,939,'Collaborator__show','1',0),
	(21757,939,'status__show','1',0),
	(21758,939,'_limit','-1',0),
	(21759,939,'_order_column','created',0),
	(21760,939,'_order_direction','DESC',0),
	(21761,940,'advanced_filter','1',0),
	(21762,940,'title__show','1',0),
	(21763,940,'description__show','1',0),
	(21764,940,'due_date__show','1',0),
	(21765,940,'Tag-title__show','1',0),
	(21766,940,'Owner__show','1',0),
	(21767,940,'Collaborator__show','1',0),
	(21768,940,'status__show','1',0),
	(21769,940,'_limit','-1',0),
	(21770,940,'_order_column','title',0),
	(21771,940,'_order_direction','ASC',0),
	(21772,940,'status','1',0),
	(21773,940,'status__show','1',0),
	(21774,940,'status__comp_type','0',0),
	(21775,940,'due_date','_plus_14_days_',0),
	(21776,940,'due_date__comp_type','2',0),
	(21777,940,'due_date__use_calendar','0',0),
	(21778,940,'due_date__show','1',0),
	(21779,941,'advanced_filter','1',0),
	(21780,941,'title__show','1',0),
	(21781,941,'description__show','1',0),
	(21782,941,'due_date__show','1',0),
	(21783,941,'Tag-title__show','1',0),
	(21784,941,'Owner__show','1',0),
	(21785,941,'Collaborator__show','1',0),
	(21786,941,'status__show','1',0),
	(21787,941,'_limit','-1',0),
	(21788,941,'_order_column','title',0),
	(21789,941,'_order_direction','ASC',0),
	(21790,941,'ObjectStatus_expired','1',0),
	(21791,941,'ObjectStatus_expired__show','1',0),
	(21792,941,'ObjectStatus_expired__comp_type','0',0),
	(21793,942,'advanced_filter','1',0),
	(21794,942,'id__show','0',0),
	(21795,942,'name__show','1',0),
	(21796,942,'description__show','0',0),
	(21797,942,'owner_id__show','0',0),
	(21798,942,'status__show','0',0),
	(21799,942,'audit_metric__show','0',0),
	(21800,942,'audit_criteria__show','0',0),
	(21801,942,'SecurityService__show','0',0),
	(21802,942,'Risk__show','0',0),
	(21803,942,'ThirdPartyRisk__show','0',0),
	(21804,942,'BusinessContinuity__show','0',0),
	(21805,942,'Project__show','0',0),
	(21806,942,'SecurityPolicy__show','0',0),
	(21807,942,'ProgramIssue__show','0',0),
	(21808,942,'created__show','0',0),
	(21809,942,'modified__show','0',0),
	(21810,942,'comment_message__show','1',0),
	(21811,942,'last_comment__show','0',0),
	(21812,942,'attachment_filename__show','0',0),
	(21813,942,'last_attachment__show','0',0),
	(21814,942,'_limit','-1',0),
	(21815,942,'_order_column','name',0),
	(21816,942,'_order_direction','ASC',0),
	(21817,942,'last_comment','_minus_1_days_',0),
	(21818,942,'last_comment__comp_type','1',0),
	(21819,943,'advanced_filter','1',0),
	(21820,943,'id__show','0',0),
	(21821,943,'name__show','1',0),
	(21822,943,'description__show','0',0),
	(21823,943,'owner_id__show','0',0),
	(21824,943,'status__show','0',0),
	(21825,943,'audit_metric__show','0',0),
	(21826,943,'audit_criteria__show','0',0),
	(21827,943,'SecurityService__show','0',0),
	(21828,943,'Risk__show','0',0),
	(21829,943,'ThirdPartyRisk__show','0',0),
	(21830,943,'BusinessContinuity__show','0',0),
	(21831,943,'Project__show','0',0),
	(21832,943,'SecurityPolicy__show','0',0),
	(21833,943,'ProgramIssue__show','0',0),
	(21834,943,'created__show','0',0),
	(21835,943,'modified__show','0',0),
	(21836,943,'comment_message__show','0',0),
	(21837,943,'last_comment__show','0',0),
	(21838,943,'attachment_filename__show','1',0),
	(21839,943,'last_attachment__show','0',0),
	(21840,943,'_limit','-1',0),
	(21841,943,'_order_column','name',0),
	(21842,943,'_order_direction','ASC',0),
	(21843,943,'last_attachment','_minus_1_days_',0),
	(21844,943,'last_attachment__comp_type','1',0),
	(21845,944,'advanced_filter','1',0),
	(21846,944,'id__show','0',0),
	(21847,944,'name__show','1',0),
	(21848,944,'description__show','0',0),
	(21849,944,'owner_id__show','0',0),
	(21850,944,'status__show','0',0),
	(21851,944,'audit_metric__show','0',0),
	(21852,944,'audit_criteria__show','0',0),
	(21853,944,'SecurityService__show','0',0),
	(21854,944,'Risk__show','0',0),
	(21855,944,'ThirdPartyRisk__show','0',0),
	(21856,944,'BusinessContinuity__show','0',0),
	(21857,944,'Project__show','0',0),
	(21858,944,'SecurityPolicy__show','0',0),
	(21859,944,'ProgramIssue__show','0',0),
	(21860,944,'created__show','0',0),
	(21861,944,'modified__show','0',0),
	(21862,944,'comment_message__show','0',0),
	(21863,944,'last_comment__show','0',0),
	(21864,944,'attachment_filename__show','0',0),
	(21865,944,'last_attachment__show','0',0),
	(21866,944,'_limit','-1',0),
	(21867,944,'_order_column','name',0),
	(21868,944,'_order_direction','ASC',0),
	(21869,944,'modified','_minus_1_days_',0),
	(21870,944,'modified__comp_type','1',0),
	(21871,945,'advanced_filter','1',0),
	(21872,945,'id__show','0',0),
	(21873,945,'name__show','1',0),
	(21874,945,'description__show','0',0),
	(21875,945,'owner_id__show','0',0),
	(21876,945,'status__show','0',0),
	(21877,945,'audit_metric__show','0',0),
	(21878,945,'audit_criteria__show','0',0),
	(21879,945,'SecurityService__show','0',0),
	(21880,945,'Risk__show','0',0),
	(21881,945,'ThirdPartyRisk__show','0',0),
	(21882,945,'BusinessContinuity__show','0',0),
	(21883,945,'Project__show','0',0),
	(21884,945,'SecurityPolicy__show','0',0),
	(21885,945,'ProgramIssue__show','0',0),
	(21886,945,'created__show','0',0),
	(21887,945,'modified__show','0',0),
	(21888,945,'comment_message__show','0',0),
	(21889,945,'last_comment__show','0',0),
	(21890,945,'attachment_filename__show','0',0),
	(21891,945,'last_attachment__show','0',0),
	(21892,945,'_limit','-1',0),
	(21893,945,'_order_column','name',0),
	(21894,945,'_order_direction','ASC',0),
	(21895,945,'created','_minus_1_days_',0),
	(21896,945,'created__comp_type','1',0),
	(21897,946,'advanced_filter','1',0),
	(21898,946,'name__show','1',0),
	(21899,946,'description__show','1',0),
	(21900,946,'owner_id__show','1',0),
	(21901,946,'status__show','1',0),
	(21902,946,'audit_metric__show','1',0),
	(21903,946,'audit_criteria__show','1',0),
	(21904,946,'SecurityService__show','1',0),
	(21905,946,'Risk__show','1',0),
	(21906,946,'ThirdPartyRisk__show','1',0),
	(21907,946,'BusinessContinuity__show','1',0),
	(21908,946,'Project__show','1',0),
	(21909,946,'SecurityPolicy__show','1',0),
	(21910,946,'ProgramIssue__show','1',0),
	(21911,946,'_limit','-1',0),
	(21912,946,'_order_column','created',0),
	(21913,946,'_order_direction','DESC',0),
	(21914,947,'advanced_filter','1',0),
	(21915,947,'id__show','0',0),
	(21916,947,'goal_id__show','1',0),
	(21917,947,'audit_metric_description__show','0',0),
	(21918,947,'audit_success_criteria__show','0',0),
	(21919,947,'planned_date__show','1',0),
	(21920,947,'start_date__show','0',0),
	(21921,947,'end_date__show','0',0),
	(21922,947,'result__show','0',0),
	(21923,947,'result_description__show','0',0),
	(21924,947,'created__show','0',0),
	(21925,947,'modified__show','0',0),
	(21926,947,'comment_message__show','1',0),
	(21927,947,'last_comment__show','0',0),
	(21928,947,'attachment_filename__show','0',0),
	(21929,947,'last_attachment__show','0',0),
	(21930,947,'_limit','-1',0),
	(21931,947,'_order_column','planned_date',0),
	(21932,947,'_order_direction','ASC',0),
	(21933,947,'last_comment','_minus_1_days_',0),
	(21934,947,'last_comment__comp_type','1',0),
	(21935,948,'advanced_filter','1',0),
	(21936,948,'id__show','0',0),
	(21937,948,'goal_id__show','1',0),
	(21938,948,'audit_metric_description__show','0',0),
	(21939,948,'audit_success_criteria__show','0',0),
	(21940,948,'planned_date__show','1',0),
	(21941,948,'start_date__show','0',0),
	(21942,948,'end_date__show','0',0),
	(21943,948,'result__show','0',0),
	(21944,948,'result_description__show','0',0),
	(21945,948,'created__show','0',0),
	(21946,948,'modified__show','0',0),
	(21947,948,'comment_message__show','0',0),
	(21948,948,'last_comment__show','0',0),
	(21949,948,'attachment_filename__show','1',0),
	(21950,948,'last_attachment__show','0',0),
	(21951,948,'_limit','-1',0),
	(21952,948,'_order_column','planned_date',0),
	(21953,948,'_order_direction','ASC',0),
	(21954,948,'last_attachment','_minus_1_days_',0),
	(21955,948,'last_attachment__comp_type','1',0),
	(21956,949,'advanced_filter','1',0),
	(21957,949,'id__show','0',0),
	(21958,949,'goal_id__show','1',0),
	(21959,949,'audit_metric_description__show','0',0),
	(21960,949,'audit_success_criteria__show','0',0),
	(21961,949,'planned_date__show','1',0),
	(21962,949,'start_date__show','0',0),
	(21963,949,'end_date__show','0',0),
	(21964,949,'result__show','0',0),
	(21965,949,'result_description__show','0',0),
	(21966,949,'created__show','0',0),
	(21967,949,'modified__show','0',0),
	(21968,949,'comment_message__show','0',0),
	(21969,949,'last_comment__show','0',0),
	(21970,949,'attachment_filename__show','0',0),
	(21971,949,'last_attachment__show','0',0),
	(21972,949,'_limit','-1',0),
	(21973,949,'_order_column','planned_date',0),
	(21974,949,'_order_direction','ASC',0),
	(21975,949,'modified','_minus_1_days_',0),
	(21976,949,'modified__comp_type','1',0),
	(21977,950,'advanced_filter','1',0),
	(21978,950,'id__show','0',0),
	(21979,950,'goal_id__show','1',0),
	(21980,950,'audit_metric_description__show','0',0),
	(21981,950,'audit_success_criteria__show','0',0),
	(21982,950,'planned_date__show','1',0),
	(21983,950,'start_date__show','0',0),
	(21984,950,'end_date__show','0',0),
	(21985,950,'result__show','0',0),
	(21986,950,'result_description__show','0',0),
	(21987,950,'created__show','0',0),
	(21988,950,'modified__show','0',0),
	(21989,950,'comment_message__show','0',0),
	(21990,950,'last_comment__show','0',0),
	(21991,950,'attachment_filename__show','0',0),
	(21992,950,'last_attachment__show','0',0),
	(21993,950,'_limit','-1',0),
	(21994,950,'_order_column','planned_date',0),
	(21995,950,'_order_direction','ASC',0),
	(21996,950,'created','_minus_1_days_',0),
	(21997,950,'created__comp_type','1',0),
	(21998,951,'advanced_filter','1',0),
	(21999,951,'goal_id__show','1',0),
	(22000,951,'audit_metric_description__show','1',0),
	(22001,951,'audit_success_criteria__show','1',0),
	(22002,951,'planned_date__show','1',0),
	(22003,951,'start_date__show','1',0),
	(22004,951,'end_date__show','1',0),
	(22005,951,'result__show','1',0),
	(22006,951,'result_description__show','1',0),
	(22007,951,'_limit','-1',0),
	(22008,951,'_order_column','created',0),
	(22009,951,'_order_direction','DESC',0),
	(22010,952,'advanced_filter','1',0),
	(22011,952,'id__show','0',0),
	(22012,952,'title__show','1',0),
	(22013,952,'description__show','0',0),
	(22014,952,'type__show','0',0),
	(22015,952,'Classification-name__show','0',0),
	(22016,952,'Owner__show','0',0),
	(22017,952,'reporter__show','0',0),
	(22018,952,'victim__show','0',0),
	(22019,952,'open_date__show','0',0),
	(22020,952,'closure_date__show','0',0),
	(22021,952,'security_incident_status_id__show','0',0),
	(22022,952,'ObjectStatus_lifecycle_incomplete__show','0',0),
	(22023,952,'AssetRisk__show','0',0),
	(22024,952,'AssetRisk-SecurityPolicyIncident__show','0',0),
	(22025,952,'ThirdPartyRisk__show','0',0),
	(22026,952,'ThirdPartyRisk-SecurityPolicyIncident__show','0',0),
	(22027,952,'BusinessContinuity__show','0',0),
	(22028,952,'BusinessContinuity-SecurityPolicyIncident__show','0',0),
	(22029,952,'SecurityService__show','0',0),
	(22030,952,'SecurityService-objective__show','0',0),
	(22031,952,'Asset__show','0',0),
	(22032,952,'ThirdParty__show','0',0),
	(22033,952,'created__show','0',0),
	(22034,952,'modified__show','0',0),
	(22035,952,'comment_message__show','1',0),
	(22036,952,'last_comment__show','0',0),
	(22037,952,'attachment_filename__show','0',0),
	(22038,952,'last_attachment__show','0',0),
	(22039,952,'_limit','-1',0),
	(22040,952,'_order_column','title',0),
	(22041,952,'_order_direction','ASC',0),
	(22042,952,'last_comment','_minus_1_days_',0),
	(22043,952,'last_comment__comp_type','1',0),
	(22044,953,'advanced_filter','1',0),
	(22045,953,'id__show','0',0),
	(22046,953,'title__show','1',0),
	(22047,953,'description__show','0',0),
	(22048,953,'type__show','0',0),
	(22049,953,'Classification-name__show','0',0),
	(22050,953,'Owner__show','0',0),
	(22051,953,'reporter__show','0',0),
	(22052,953,'victim__show','0',0),
	(22053,953,'open_date__show','0',0),
	(22054,953,'closure_date__show','0',0),
	(22055,953,'security_incident_status_id__show','0',0),
	(22056,953,'ObjectStatus_lifecycle_incomplete__show','0',0),
	(22057,953,'AssetRisk__show','0',0),
	(22058,953,'AssetRisk-SecurityPolicyIncident__show','0',0),
	(22059,953,'ThirdPartyRisk__show','0',0),
	(22060,953,'ThirdPartyRisk-SecurityPolicyIncident__show','0',0),
	(22061,953,'BusinessContinuity__show','0',0),
	(22062,953,'BusinessContinuity-SecurityPolicyIncident__show','0',0),
	(22063,953,'SecurityService__show','0',0),
	(22064,953,'SecurityService-objective__show','0',0),
	(22065,953,'Asset__show','0',0),
	(22066,953,'ThirdParty__show','0',0),
	(22067,953,'created__show','0',0),
	(22068,953,'modified__show','0',0),
	(22069,953,'comment_message__show','0',0),
	(22070,953,'last_comment__show','0',0),
	(22071,953,'attachment_filename__show','1',0),
	(22072,953,'last_attachment__show','0',0),
	(22073,953,'_limit','-1',0),
	(22074,953,'_order_column','title',0),
	(22075,953,'_order_direction','ASC',0),
	(22076,953,'last_attachment','_minus_1_days_',0),
	(22077,953,'last_attachment__comp_type','1',0),
	(22078,954,'advanced_filter','1',0),
	(22079,954,'id__show','0',0),
	(22080,954,'title__show','1',0),
	(22081,954,'description__show','0',0),
	(22082,954,'type__show','0',0),
	(22083,954,'Classification-name__show','0',0),
	(22084,954,'Owner__show','0',0),
	(22085,954,'reporter__show','0',0),
	(22086,954,'victim__show','0',0),
	(22087,954,'open_date__show','0',0),
	(22088,954,'closure_date__show','0',0),
	(22089,954,'security_incident_status_id__show','0',0),
	(22090,954,'ObjectStatus_lifecycle_incomplete__show','0',0),
	(22091,954,'AssetRisk__show','0',0),
	(22092,954,'AssetRisk-SecurityPolicyIncident__show','0',0),
	(22093,954,'ThirdPartyRisk__show','0',0),
	(22094,954,'ThirdPartyRisk-SecurityPolicyIncident__show','0',0),
	(22095,954,'BusinessContinuity__show','0',0),
	(22096,954,'BusinessContinuity-SecurityPolicyIncident__show','0',0),
	(22097,954,'SecurityService__show','0',0),
	(22098,954,'SecurityService-objective__show','0',0),
	(22099,954,'Asset__show','0',0),
	(22100,954,'ThirdParty__show','0',0),
	(22101,954,'created__show','0',0),
	(22102,954,'modified__show','0',0),
	(22103,954,'comment_message__show','0',0),
	(22104,954,'last_comment__show','0',0),
	(22105,954,'attachment_filename__show','0',0),
	(22106,954,'last_attachment__show','0',0),
	(22107,954,'_limit','-1',0),
	(22108,954,'_order_column','title',0),
	(22109,954,'_order_direction','ASC',0),
	(22110,954,'modified','_minus_1_days_',0),
	(22111,954,'modified__comp_type','1',0),
	(22112,955,'advanced_filter','1',0),
	(22113,955,'id__show','0',0),
	(22114,955,'title__show','1',0),
	(22115,955,'description__show','0',0),
	(22116,955,'type__show','0',0),
	(22117,955,'Classification-name__show','0',0),
	(22118,955,'Owner__show','0',0),
	(22119,955,'reporter__show','0',0),
	(22120,955,'victim__show','0',0),
	(22121,955,'open_date__show','0',0),
	(22122,955,'closure_date__show','0',0),
	(22123,955,'security_incident_status_id__show','0',0),
	(22124,955,'ObjectStatus_lifecycle_incomplete__show','0',0),
	(22125,955,'AssetRisk__show','0',0),
	(22126,955,'AssetRisk-SecurityPolicyIncident__show','0',0),
	(22127,955,'ThirdPartyRisk__show','0',0),
	(22128,955,'ThirdPartyRisk-SecurityPolicyIncident__show','0',0),
	(22129,955,'BusinessContinuity__show','0',0),
	(22130,955,'BusinessContinuity-SecurityPolicyIncident__show','0',0),
	(22131,955,'SecurityService__show','0',0),
	(22132,955,'SecurityService-objective__show','0',0),
	(22133,955,'Asset__show','0',0),
	(22134,955,'ThirdParty__show','0',0),
	(22135,955,'created__show','0',0),
	(22136,955,'modified__show','0',0),
	(22137,955,'comment_message__show','0',0),
	(22138,955,'last_comment__show','0',0),
	(22139,955,'attachment_filename__show','0',0),
	(22140,955,'last_attachment__show','0',0),
	(22141,955,'_limit','-1',0),
	(22142,955,'_order_column','title',0),
	(22143,955,'_order_direction','ASC',0),
	(22144,955,'created','_minus_1_days_',0),
	(22145,955,'created__comp_type','1',0),
	(22146,956,'advanced_filter','1',0),
	(22147,956,'title__show','1',0),
	(22148,956,'description__show','1',0),
	(22149,956,'open_date__show','1',0),
	(22150,956,'closure_date__show','1',0),
	(22151,956,'AssetRisk__show','1',0),
	(22152,956,'AssetRisk-SecurityPolicyIncident__show','1',0),
	(22153,956,'ThirdPartyRisk__show','1',0),
	(22154,956,'ThirdPartyRisk-SecurityPolicyIncident__show','1',0),
	(22155,956,'BusinessContinuity__show','1',0),
	(22156,956,'BusinessContinuity-SecurityPolicyIncident__show','1',0),
	(22157,956,'SecurityService__show','1',0),
	(22158,956,'Asset__show','1',0),
	(22159,956,'ThirdParty__show','1',0),
	(22160,956,'_limit','-1',0),
	(22161,956,'_order_column','created',0),
	(22162,956,'_order_direction','DESC',0),
	(22163,957,'advanced_filter','1',0),
	(22164,957,'title__show','1',0),
	(22165,957,'description__show','1',0),
	(22166,957,'open_date__show','1',0),
	(22167,957,'closure_date__show','1',0),
	(22168,957,'AssetRisk__show','1',0),
	(22169,957,'AssetRisk-SecurityPolicyIncident__show','1',0),
	(22170,957,'ThirdPartyRisk__show','1',0),
	(22171,957,'ThirdPartyRisk-SecurityPolicyIncident__show','1',0),
	(22172,957,'BusinessContinuity__show','1',0),
	(22173,957,'BusinessContinuity-SecurityPolicyIncident__show','1',0),
	(22174,957,'SecurityService__show','1',0),
	(22175,957,'Asset__show','1',0),
	(22176,957,'ThirdParty__show','1',0),
	(22177,957,'_limit','-1',0),
	(22178,957,'_order_column','title',0),
	(22179,957,'_order_direction','ASC',0),
	(22180,957,'security_incident_status_id','2',0),
	(22181,957,'security_incident_status_id__show','1',0),
	(22182,958,'advanced_filter','1',0),
	(22183,958,'title__show','1',0),
	(22184,958,'description__show','1',0),
	(22185,958,'open_date__show','1',0),
	(22186,958,'closure_date__show','1',0),
	(22187,958,'AssetRisk__show','1',0),
	(22188,958,'AssetRisk-SecurityPolicyIncident__show','1',0),
	(22189,958,'ThirdPartyRisk__show','1',0),
	(22190,958,'ThirdPartyRisk-SecurityPolicyIncident__show','1',0),
	(22191,958,'BusinessContinuity__show','1',0),
	(22192,958,'BusinessContinuity-SecurityPolicyIncident__show','1',0),
	(22193,958,'SecurityService__show','1',0),
	(22194,958,'Asset__show','1',0),
	(22195,958,'ThirdParty__show','1',0),
	(22196,958,'_limit','-1',0),
	(22197,958,'_order_column','title',0),
	(22198,958,'_order_direction','ASC',0),
	(22199,958,'security_incident_status_id','3',0),
	(22200,958,'security_incident_status_id__show','1',0),
	(22201,959,'advanced_filter','1',0),
	(22202,959,'title__show','1',0),
	(22203,959,'description__show','1',0),
	(22204,959,'open_date__show','1',0),
	(22205,959,'closure_date__show','1',0),
	(22206,959,'AssetRisk__show','1',0),
	(22207,959,'AssetRisk-SecurityPolicyIncident__show','1',0),
	(22208,959,'ThirdPartyRisk__show','1',0),
	(22209,959,'ThirdPartyRisk-SecurityPolicyIncident__show','1',0),
	(22210,959,'BusinessContinuity__show','1',0),
	(22211,959,'BusinessContinuity-SecurityPolicyIncident__show','1',0),
	(22212,959,'SecurityService__show','1',0),
	(22213,959,'Asset__show','1',0),
	(22214,959,'ThirdParty__show','1',0),
	(22215,959,'_limit','-1',0),
	(22216,959,'_order_column','title',0),
	(22217,959,'_order_direction','ASC',0),
	(22218,959,'security_incident_status_id','2',0),
	(22219,959,'security_incident_status_id__show','1',0),
	(22220,959,'ObjectStatus_lifecycle_incomplete','1',0),
	(22221,959,'ObjectStatus_lifecycle_incomplete__show','1',0),
	(22222,960,'advanced_filter','1',0),
	(22223,960,'id__show','0',0),
	(22224,960,'status__show','0',0),
	(22225,960,'security_incident_id__show','1',0),
	(22226,960,'SecurityIncidentStage-name__show','0',0),
	(22227,960,'SecurityIncidentStage-description__show','0',0),
	(22228,960,'created__show','0',0),
	(22229,960,'modified__show','0',0),
	(22230,960,'comment_message__show','1',0),
	(22231,960,'last_comment__show','0',0),
	(22232,960,'attachment_filename__show','0',0),
	(22233,960,'last_attachment__show','0',0),
	(22234,960,'_limit','-1',0),
	(22235,960,'_order_column','id',0),
	(22236,960,'_order_direction','ASC',0),
	(22237,960,'last_comment','_minus_1_days_',0),
	(22238,960,'last_comment__comp_type','1',0),
	(22239,961,'advanced_filter','1',0),
	(22240,961,'id__show','0',0),
	(22241,961,'status__show','0',0),
	(22242,961,'security_incident_id__show','1',0),
	(22243,961,'SecurityIncidentStage-name__show','0',0),
	(22244,961,'SecurityIncidentStage-description__show','0',0),
	(22245,961,'created__show','0',0),
	(22246,961,'modified__show','0',0),
	(22247,961,'comment_message__show','0',0),
	(22248,961,'last_comment__show','0',0),
	(22249,961,'attachment_filename__show','1',0),
	(22250,961,'last_attachment__show','0',0),
	(22251,961,'_limit','-1',0),
	(22252,961,'_order_column','id',0),
	(22253,961,'_order_direction','ASC',0),
	(22254,961,'last_attachment','_minus_1_days_',0),
	(22255,961,'last_attachment__comp_type','1',0),
	(22256,962,'advanced_filter','1',0),
	(22257,962,'id__show','0',0),
	(22258,962,'status__show','0',0),
	(22259,962,'security_incident_id__show','1',0),
	(22260,962,'SecurityIncidentStage-name__show','0',0),
	(22261,962,'SecurityIncidentStage-description__show','0',0),
	(22262,962,'created__show','0',0),
	(22263,962,'modified__show','0',0),
	(22264,962,'comment_message__show','0',0),
	(22265,962,'last_comment__show','0',0),
	(22266,962,'attachment_filename__show','0',0),
	(22267,962,'last_attachment__show','0',0),
	(22268,962,'_limit','-1',0),
	(22269,962,'_order_column','id',0),
	(22270,962,'_order_direction','ASC',0),
	(22271,962,'modified','_minus_1_days_',0),
	(22272,962,'modified__comp_type','1',0),
	(22273,963,'advanced_filter','1',0),
	(22274,963,'id__show','0',0),
	(22275,963,'status__show','0',0),
	(22276,963,'security_incident_id__show','1',0),
	(22277,963,'SecurityIncidentStage-name__show','0',0),
	(22278,963,'SecurityIncidentStage-description__show','0',0),
	(22279,963,'created__show','0',0),
	(22280,963,'modified__show','0',0),
	(22281,963,'comment_message__show','0',0),
	(22282,963,'last_comment__show','0',0),
	(22283,963,'attachment_filename__show','0',0),
	(22284,963,'last_attachment__show','0',0),
	(22285,963,'_limit','-1',0),
	(22286,963,'_order_column','id',0),
	(22287,963,'_order_direction','ASC',0),
	(22288,963,'created','_minus_1_days_',0),
	(22289,963,'created__comp_type','1',0),
	(22290,964,'advanced_filter','1',0),
	(22291,964,'status__show','1',0),
	(22292,964,'security_incident_id__show','1',0),
	(22293,964,'SecurityIncidentStage-name__show','1',0),
	(22294,964,'SecurityIncidentStage-description__show','1',0),
	(22295,964,'_limit','-1',0),
	(22296,964,'_order_column','created',0),
	(22297,964,'_order_direction','DESC',0),
	(22298,965,'advanced_filter','1',0),
	(22299,965,'id__show','0',0),
	(22300,965,'title__show','1',0),
	(22301,965,'objective__show','0',0),
	(22302,965,'launch_criteria__show','0',0),
	(22303,965,'Owner__show','0',0),
	(22304,965,'Sponsor__show','0',0),
	(22305,965,'LaunchInitiator__show','0',0),
	(22306,965,'opex__show','0',0),
	(22307,965,'capex__show','0',0),
	(22308,965,'resource_utilization__show','0',0),
	(22309,965,'security_service_type_id__show','0',0),
	(22310,965,'audit_success_criteria__show','0',0),
	(22311,965,'audit_metric__show','0',0),
	(22312,965,'ObjectStatus_audits_last_passed__show','0',0),
	(22313,965,'ObjectStatus_audits_last_missing__show','0',0),
	(22314,965,'created__show','0',0),
	(22315,965,'modified__show','0',0),
	(22316,965,'comment_message__show','1',0),
	(22317,965,'last_comment__show','0',0),
	(22318,965,'attachment_filename__show','0',0),
	(22319,965,'last_attachment__show','0',0),
	(22320,965,'_limit','-1',0),
	(22321,965,'_order_column','title',0),
	(22322,965,'_order_direction','ASC',0),
	(22323,965,'last_comment','_minus_1_days_',0),
	(22324,965,'last_comment__comp_type','1',0),
	(22325,966,'advanced_filter','1',0),
	(22326,966,'id__show','0',0),
	(22327,966,'title__show','1',0),
	(22328,966,'objective__show','0',0),
	(22329,966,'launch_criteria__show','0',0),
	(22330,966,'Owner__show','0',0),
	(22331,966,'Sponsor__show','0',0),
	(22332,966,'LaunchInitiator__show','0',0),
	(22333,966,'opex__show','0',0),
	(22334,966,'capex__show','0',0),
	(22335,966,'resource_utilization__show','0',0),
	(22336,966,'security_service_type_id__show','0',0),
	(22337,966,'audit_success_criteria__show','0',0),
	(22338,966,'audit_metric__show','0',0),
	(22339,966,'ObjectStatus_audits_last_passed__show','0',0),
	(22340,966,'ObjectStatus_audits_last_missing__show','0',0),
	(22341,966,'created__show','0',0),
	(22342,966,'modified__show','0',0),
	(22343,966,'comment_message__show','0',0),
	(22344,966,'last_comment__show','0',0),
	(22345,966,'attachment_filename__show','1',0),
	(22346,966,'last_attachment__show','0',0),
	(22347,966,'_limit','-1',0),
	(22348,966,'_order_column','title',0),
	(22349,966,'_order_direction','ASC',0),
	(22350,966,'last_attachment','_minus_1_days_',0),
	(22351,966,'last_attachment__comp_type','1',0),
	(22352,967,'advanced_filter','1',0),
	(22353,967,'id__show','0',0),
	(22354,967,'title__show','1',0),
	(22355,967,'objective__show','0',0),
	(22356,967,'launch_criteria__show','0',0),
	(22357,967,'Owner__show','0',0),
	(22358,967,'Sponsor__show','0',0),
	(22359,967,'LaunchInitiator__show','0',0),
	(22360,967,'opex__show','0',0),
	(22361,967,'capex__show','0',0),
	(22362,967,'resource_utilization__show','0',0),
	(22363,967,'security_service_type_id__show','0',0),
	(22364,967,'audit_success_criteria__show','0',0),
	(22365,967,'audit_metric__show','0',0),
	(22366,967,'ObjectStatus_audits_last_passed__show','0',0),
	(22367,967,'ObjectStatus_audits_last_missing__show','0',0),
	(22368,967,'created__show','0',0),
	(22369,967,'modified__show','0',0),
	(22370,967,'comment_message__show','0',0),
	(22371,967,'last_comment__show','0',0),
	(22372,967,'attachment_filename__show','0',0),
	(22373,967,'last_attachment__show','0',0),
	(22374,967,'_limit','-1',0),
	(22375,967,'_order_column','title',0),
	(22376,967,'_order_direction','ASC',0),
	(22377,967,'modified','_minus_1_days_',0),
	(22378,967,'modified__comp_type','1',0),
	(22379,968,'advanced_filter','1',0),
	(22380,968,'id__show','0',0),
	(22381,968,'title__show','1',0),
	(22382,968,'objective__show','0',0),
	(22383,968,'launch_criteria__show','0',0),
	(22384,968,'Owner__show','0',0),
	(22385,968,'Sponsor__show','0',0),
	(22386,968,'LaunchInitiator__show','0',0),
	(22387,968,'opex__show','0',0),
	(22388,968,'capex__show','0',0),
	(22389,968,'resource_utilization__show','0',0),
	(22390,968,'security_service_type_id__show','0',0),
	(22391,968,'audit_success_criteria__show','0',0),
	(22392,968,'audit_metric__show','0',0),
	(22393,968,'ObjectStatus_audits_last_passed__show','0',0),
	(22394,968,'ObjectStatus_audits_last_missing__show','0',0),
	(22395,968,'created__show','0',0),
	(22396,968,'modified__show','0',0),
	(22397,968,'comment_message__show','0',0),
	(22398,968,'last_comment__show','0',0),
	(22399,968,'attachment_filename__show','0',0),
	(22400,968,'last_attachment__show','0',0),
	(22401,968,'_limit','-1',0),
	(22402,968,'_order_column','title',0),
	(22403,968,'_order_direction','ASC',0),
	(22404,968,'created','_minus_1_days_',0),
	(22405,968,'created__comp_type','1',0),
	(22406,969,'advanced_filter','1',0),
	(22407,969,'title__show','1',0),
	(22408,969,'objective__show','1',0),
	(22409,969,'launch_criteria__show','1',0),
	(22410,969,'Owner__show','1',0),
	(22411,969,'Sponsor__show','1',0),
	(22412,969,'LaunchInitiator__show','1',0),
	(22413,969,'opex__show','1',0),
	(22414,969,'capex__show','1',0),
	(22415,969,'resource_utilization__show','1',0),
	(22416,969,'security_service_type_id__show','1',0),
	(22417,969,'audit_success_criteria__show','1',0),
	(22418,969,'audit_metric__show','1',0),
	(22419,969,'_limit','-1',0),
	(22420,969,'_order_column','created',0),
	(22421,969,'_order_direction','DESC',0),
	(22422,970,'advanced_filter','1',0),
	(22423,970,'id__show','0',0),
	(22424,970,'business_continuity_plan_id__show','1',0),
	(22425,970,'audit_metric_description__show','0',0),
	(22426,970,'audit_success_criteria__show','0',0),
	(22427,970,'planned_date__show','1',0),
	(22428,970,'start_date__show','0',0),
	(22429,970,'end_date__show','0',0),
	(22430,970,'result__show','0',0),
	(22431,970,'result_description__show','0',0),
	(22432,970,'ObjectStatus_audit_missing__show','0',0),
	(22433,970,'created__show','0',0),
	(22434,970,'modified__show','0',0),
	(22435,970,'comment_message__show','1',0),
	(22436,970,'last_comment__show','0',0),
	(22437,970,'attachment_filename__show','0',0),
	(22438,970,'last_attachment__show','0',0),
	(22439,970,'_limit','-1',0),
	(22440,970,'_order_column','planned_date',0),
	(22441,970,'_order_direction','ASC',0),
	(22442,970,'last_comment','_minus_1_days_',0),
	(22443,970,'last_comment__comp_type','1',0),
	(22444,971,'advanced_filter','1',0),
	(22445,971,'id__show','0',0),
	(22446,971,'business_continuity_plan_id__show','1',0),
	(22447,971,'audit_metric_description__show','0',0),
	(22448,971,'audit_success_criteria__show','0',0),
	(22449,971,'planned_date__show','1',0),
	(22450,971,'start_date__show','0',0),
	(22451,971,'end_date__show','0',0),
	(22452,971,'result__show','0',0),
	(22453,971,'result_description__show','0',0),
	(22454,971,'ObjectStatus_audit_missing__show','0',0),
	(22455,971,'created__show','0',0),
	(22456,971,'modified__show','0',0),
	(22457,971,'comment_message__show','0',0),
	(22458,971,'last_comment__show','0',0),
	(22459,971,'attachment_filename__show','1',0),
	(22460,971,'last_attachment__show','0',0),
	(22461,971,'_limit','-1',0),
	(22462,971,'_order_column','planned_date',0),
	(22463,971,'_order_direction','ASC',0),
	(22464,971,'last_attachment','_minus_1_days_',0),
	(22465,971,'last_attachment__comp_type','1',0),
	(22466,972,'advanced_filter','1',0),
	(22467,972,'id__show','0',0),
	(22468,972,'business_continuity_plan_id__show','1',0),
	(22469,972,'audit_metric_description__show','0',0),
	(22470,972,'audit_success_criteria__show','0',0),
	(22471,972,'planned_date__show','1',0),
	(22472,972,'start_date__show','0',0),
	(22473,972,'end_date__show','0',0),
	(22474,972,'result__show','0',0),
	(22475,972,'result_description__show','0',0),
	(22476,972,'ObjectStatus_audit_missing__show','0',0),
	(22477,972,'created__show','0',0),
	(22478,972,'modified__show','0',0),
	(22479,972,'comment_message__show','0',0),
	(22480,972,'last_comment__show','0',0),
	(22481,972,'attachment_filename__show','0',0),
	(22482,972,'last_attachment__show','0',0),
	(22483,972,'_limit','-1',0),
	(22484,972,'_order_column','planned_date',0),
	(22485,972,'_order_direction','ASC',0),
	(22486,972,'modified','_minus_1_days_',0),
	(22487,972,'modified__comp_type','1',0),
	(22488,973,'advanced_filter','1',0),
	(22489,973,'id__show','0',0),
	(22490,973,'business_continuity_plan_id__show','1',0),
	(22491,973,'audit_metric_description__show','0',0),
	(22492,973,'audit_success_criteria__show','0',0),
	(22493,973,'planned_date__show','1',0),
	(22494,973,'start_date__show','0',0),
	(22495,973,'end_date__show','0',0),
	(22496,973,'result__show','0',0),
	(22497,973,'result_description__show','0',0),
	(22498,973,'ObjectStatus_audit_missing__show','0',0),
	(22499,973,'created__show','0',0),
	(22500,973,'modified__show','0',0),
	(22501,973,'comment_message__show','0',0),
	(22502,973,'last_comment__show','0',0),
	(22503,973,'attachment_filename__show','0',0),
	(22504,973,'last_attachment__show','0',0),
	(22505,973,'_limit','-1',0),
	(22506,973,'_order_column','planned_date',0),
	(22507,973,'_order_direction','ASC',0),
	(22508,973,'created','_minus_1_days_',0),
	(22509,973,'created__comp_type','1',0),
	(22510,974,'advanced_filter','1',0),
	(22511,974,'business_continuity_plan_id__show','1',0),
	(22512,974,'audit_metric_description__show','1',0),
	(22513,974,'audit_success_criteria__show','1',0),
	(22514,974,'planned_date__show','1',0),
	(22515,974,'start_date__show','1',0),
	(22516,974,'end_date__show','1',0),
	(22517,974,'result__show','1',0),
	(22518,974,'result_description__show','1',0),
	(22519,974,'_limit','-1',0),
	(22520,974,'_order_column','created',0),
	(22521,974,'_order_direction','DESC',0),
	(22522,975,'advanced_filter','1',0),
	(22523,975,'id__show','0',0),
	(22524,975,'business_continuity_plan_id__show','1',0),
	(22525,975,'AwarenessRole__show','0',0),
	(22526,975,'step__show','1',0),
	(22527,975,'when__show','0',0),
	(22528,975,'does__show','0',0),
	(22529,975,'where__show','0',0),
	(22530,975,'how__show','0',0),
	(22531,975,'created__show','0',0),
	(22532,975,'modified__show','0',0),
	(22533,975,'comment_message__show','1',0),
	(22534,975,'last_comment__show','0',0),
	(22535,975,'attachment_filename__show','0',0),
	(22536,975,'last_attachment__show','0',0),
	(22537,975,'_limit','-1',0),
	(22538,975,'_order_column','step',0),
	(22539,975,'_order_direction','ASC',0),
	(22540,975,'last_comment','_minus_1_days_',0),
	(22541,975,'last_comment__comp_type','1',0),
	(22542,976,'advanced_filter','1',0),
	(22543,976,'id__show','0',0),
	(22544,976,'business_continuity_plan_id__show','1',0),
	(22545,976,'AwarenessRole__show','0',0),
	(22546,976,'step__show','1',0),
	(22547,976,'when__show','0',0),
	(22548,976,'does__show','0',0),
	(22549,976,'where__show','0',0),
	(22550,976,'how__show','0',0),
	(22551,976,'created__show','0',0),
	(22552,976,'modified__show','0',0),
	(22553,976,'comment_message__show','0',0),
	(22554,976,'last_comment__show','0',0),
	(22555,976,'attachment_filename__show','1',0),
	(22556,976,'last_attachment__show','0',0),
	(22557,976,'_limit','-1',0),
	(22558,976,'_order_column','step',0),
	(22559,976,'_order_direction','ASC',0),
	(22560,976,'last_attachment','_minus_1_days_',0),
	(22561,976,'last_attachment__comp_type','1',0),
	(22562,977,'advanced_filter','1',0),
	(22563,977,'id__show','0',0),
	(22564,977,'business_continuity_plan_id__show','1',0),
	(22565,977,'AwarenessRole__show','0',0),
	(22566,977,'step__show','1',0),
	(22567,977,'when__show','0',0),
	(22568,977,'does__show','0',0),
	(22569,977,'where__show','0',0),
	(22570,977,'how__show','0',0),
	(22571,977,'created__show','0',0),
	(22572,977,'modified__show','0',0),
	(22573,977,'comment_message__show','0',0),
	(22574,977,'last_comment__show','0',0),
	(22575,977,'attachment_filename__show','0',0),
	(22576,977,'last_attachment__show','0',0),
	(22577,977,'_limit','-1',0),
	(22578,977,'_order_column','step',0),
	(22579,977,'_order_direction','ASC',0),
	(22580,977,'modified','_minus_1_days_',0),
	(22581,977,'modified__comp_type','1',0),
	(22582,978,'advanced_filter','1',0),
	(22583,978,'id__show','0',0),
	(22584,978,'business_continuity_plan_id__show','1',0),
	(22585,978,'AwarenessRole__show','0',0),
	(22586,978,'step__show','1',0),
	(22587,978,'when__show','0',0),
	(22588,978,'does__show','0',0),
	(22589,978,'where__show','0',0),
	(22590,978,'how__show','0',0),
	(22591,978,'created__show','0',0),
	(22592,978,'modified__show','0',0),
	(22593,978,'comment_message__show','0',0),
	(22594,978,'last_comment__show','0',0),
	(22595,978,'attachment_filename__show','0',0),
	(22596,978,'last_attachment__show','0',0),
	(22597,978,'_limit','-1',0),
	(22598,978,'_order_column','step',0),
	(22599,978,'_order_direction','ASC',0),
	(22600,978,'created','_minus_1_days_',0),
	(22601,978,'created__comp_type','1',0),
	(22602,979,'advanced_filter','1',0),
	(22603,979,'business_continuity_plan_id__show','1',0),
	(22604,979,'AwarenessRole__show','1',0),
	(22605,979,'step__show','1',0),
	(22606,979,'when__show','1',0),
	(22607,979,'does__show','1',0),
	(22608,979,'where__show','1',0),
	(22609,979,'how__show','1',0),
	(22610,979,'_limit','-1',0),
	(22611,979,'_order_column','created',0),
	(22612,979,'_order_direction','DESC',0),
	(22613,980,'advanced_filter','1',0),
	(22614,980,'id__show','0',0),
	(22615,980,'login__show','0',0),
	(22616,980,'system_logs__show','0',0),
	(22617,980,'name__show','0',0),
	(22618,980,'surname__show','0',0),
	(22619,980,'email__show','0',0),
	(22620,980,'local_account__show','0',0),
	(22621,980,'Portal__show','0',0),
	(22622,980,'Group__show','0',0),
	(22623,980,'status__show','0',0),
	(22624,980,'LdapSynchronization__show','0',0),
	(22625,980,'LdapSynchronization-ldap_auth_connector_id__show','0',0),
	(22626,980,'LdapSynchronization-ldap_group_connector_id__show','0',0),
	(22627,980,'LdapSynchronization-ldap_group__show','0',0),
	(22628,980,'LdapSynchronization-status__show','0',0),
	(22629,980,'created__show','0',0),
	(22630,980,'modified__show','0',0),
	(22631,980,'comment_message__show','1',0),
	(22632,980,'last_comment__show','0',0),
	(22633,980,'attachment_filename__show','0',0),
	(22634,980,'last_attachment__show','0',0),
	(22635,980,'_limit','-1',0),
	(22636,980,'_order_column','full_name_with_type',0),
	(22637,980,'_order_direction','ASC',0),
	(22638,980,'last_comment','_minus_1_days_',0),
	(22639,980,'last_comment__comp_type','1',0),
	(22640,981,'advanced_filter','1',0),
	(22641,981,'id__show','0',0),
	(22642,981,'login__show','0',0),
	(22643,981,'system_logs__show','0',0),
	(22644,981,'name__show','0',0),
	(22645,981,'surname__show','0',0),
	(22646,981,'email__show','0',0),
	(22647,981,'local_account__show','0',0),
	(22648,981,'Portal__show','0',0),
	(22649,981,'Group__show','0',0),
	(22650,981,'status__show','0',0),
	(22651,981,'LdapSynchronization__show','0',0),
	(22652,981,'LdapSynchronization-ldap_auth_connector_id__show','0',0),
	(22653,981,'LdapSynchronization-ldap_group_connector_id__show','0',0),
	(22654,981,'LdapSynchronization-ldap_group__show','0',0),
	(22655,981,'LdapSynchronization-status__show','0',0),
	(22656,981,'created__show','0',0),
	(22657,981,'modified__show','0',0),
	(22658,981,'comment_message__show','0',0),
	(22659,981,'last_comment__show','0',0),
	(22660,981,'attachment_filename__show','1',0),
	(22661,981,'last_attachment__show','0',0),
	(22662,981,'_limit','-1',0),
	(22663,981,'_order_column','full_name_with_type',0),
	(22664,981,'_order_direction','ASC',0),
	(22665,981,'last_attachment','_minus_1_days_',0),
	(22666,981,'last_attachment__comp_type','1',0),
	(22667,982,'advanced_filter','1',0),
	(22668,982,'id__show','0',0),
	(22669,982,'login__show','0',0),
	(22670,982,'system_logs__show','0',0),
	(22671,982,'name__show','0',0),
	(22672,982,'surname__show','0',0),
	(22673,982,'email__show','0',0),
	(22674,982,'local_account__show','0',0),
	(22675,982,'Portal__show','0',0),
	(22676,982,'Group__show','0',0),
	(22677,982,'status__show','0',0),
	(22678,982,'LdapSynchronization__show','0',0),
	(22679,982,'LdapSynchronization-ldap_auth_connector_id__show','0',0),
	(22680,982,'LdapSynchronization-ldap_group_connector_id__show','0',0),
	(22681,982,'LdapSynchronization-ldap_group__show','0',0),
	(22682,982,'LdapSynchronization-status__show','0',0),
	(22683,982,'created__show','0',0),
	(22684,982,'modified__show','0',0),
	(22685,982,'comment_message__show','0',0),
	(22686,982,'last_comment__show','0',0),
	(22687,982,'attachment_filename__show','0',0),
	(22688,982,'last_attachment__show','0',0),
	(22689,982,'_limit','-1',0),
	(22690,982,'_order_column','full_name_with_type',0),
	(22691,982,'_order_direction','ASC',0),
	(22692,982,'modified','_minus_1_days_',0),
	(22693,982,'modified__comp_type','1',0),
	(22694,983,'advanced_filter','1',0),
	(22695,983,'id__show','0',0),
	(22696,983,'login__show','0',0),
	(22697,983,'system_logs__show','0',0),
	(22698,983,'name__show','0',0),
	(22699,983,'surname__show','0',0),
	(22700,983,'email__show','0',0),
	(22701,983,'local_account__show','0',0),
	(22702,983,'Portal__show','0',0),
	(22703,983,'Group__show','0',0),
	(22704,983,'status__show','0',0),
	(22705,983,'LdapSynchronization__show','0',0),
	(22706,983,'LdapSynchronization-ldap_auth_connector_id__show','0',0),
	(22707,983,'LdapSynchronization-ldap_group_connector_id__show','0',0),
	(22708,983,'LdapSynchronization-ldap_group__show','0',0),
	(22709,983,'LdapSynchronization-status__show','0',0),
	(22710,983,'created__show','0',0),
	(22711,983,'modified__show','0',0),
	(22712,983,'comment_message__show','0',0),
	(22713,983,'last_comment__show','0',0),
	(22714,983,'attachment_filename__show','0',0),
	(22715,983,'last_attachment__show','0',0),
	(22716,983,'_limit','-1',0),
	(22717,983,'_order_column','full_name_with_type',0),
	(22718,983,'_order_direction','ASC',0),
	(22719,983,'created','_minus_1_days_',0),
	(22720,983,'created__comp_type','1',0),
	(22721,984,'advanced_filter','1',0),
	(22722,984,'login__show','1',0),
	(22723,984,'name__show','1',0),
	(22724,984,'surname__show','1',0),
	(22725,984,'email__show','1',0),
	(22726,984,'local_account__show','1',0),
	(22727,984,'Portal__show','1',0),
	(22728,984,'Group__show','1',0),
	(22729,984,'status__show','1',0),
	(22730,984,'LdapSynchronization__show','1',0),
	(22731,984,'_limit','-1',0),
	(22732,984,'_order_column','created',0),
	(22733,984,'_order_direction','DESC',0),
	(22734,985,'advanced_filter','1',0),
	(22735,985,'action__show','1',0),
	(22736,985,'sub_foreign_key__show','1',0),
	(22737,985,'user_id__show','1',0),
	(22738,985,'message__show','1',0),
	(22739,985,'created__show','1',0),
	(22740,985,'_limit','-1',0),
	(22741,985,'_order_column','created',0),
	(22742,985,'_order_direction','DESC',0),
	(22743,986,'advanced_filter','1',0),
	(22744,986,'id__show','0',0),
	(22745,986,'name__show','0',0),
	(22746,986,'description__show','0',0),
	(22747,986,'access_list__show','0',0),
	(22748,986,'created__show','0',0),
	(22749,986,'modified__show','0',0),
	(22750,986,'comment_message__show','1',0),
	(22751,986,'last_comment__show','0',0),
	(22752,986,'attachment_filename__show','0',0),
	(22753,986,'last_attachment__show','0',0),
	(22754,986,'_limit','-1',0),
	(22755,986,'_order_column','full_name_with_type',0),
	(22756,986,'_order_direction','ASC',0),
	(22757,986,'last_comment','_minus_1_days_',0),
	(22758,986,'last_comment__comp_type','1',0),
	(22759,987,'advanced_filter','1',0),
	(22760,987,'id__show','0',0),
	(22761,987,'name__show','0',0),
	(22762,987,'description__show','0',0),
	(22763,987,'access_list__show','0',0),
	(22764,987,'created__show','0',0),
	(22765,987,'modified__show','0',0),
	(22766,987,'comment_message__show','0',0),
	(22767,987,'last_comment__show','0',0),
	(22768,987,'attachment_filename__show','1',0),
	(22769,987,'last_attachment__show','0',0),
	(22770,987,'_limit','-1',0),
	(22771,987,'_order_column','full_name_with_type',0),
	(22772,987,'_order_direction','ASC',0),
	(22773,987,'last_attachment','_minus_1_days_',0),
	(22774,987,'last_attachment__comp_type','1',0),
	(22775,988,'advanced_filter','1',0),
	(22776,988,'id__show','0',0),
	(22777,988,'name__show','0',0),
	(22778,988,'description__show','0',0),
	(22779,988,'access_list__show','0',0),
	(22780,988,'created__show','0',0),
	(22781,988,'modified__show','0',0),
	(22782,988,'comment_message__show','0',0),
	(22783,988,'last_comment__show','0',0),
	(22784,988,'attachment_filename__show','0',0),
	(22785,988,'last_attachment__show','0',0),
	(22786,988,'_limit','-1',0),
	(22787,988,'_order_column','full_name_with_type',0),
	(22788,988,'_order_direction','ASC',0),
	(22789,988,'modified','_minus_1_days_',0),
	(22790,988,'modified__comp_type','1',0),
	(22791,989,'advanced_filter','1',0),
	(22792,989,'id__show','0',0),
	(22793,989,'name__show','0',0),
	(22794,989,'description__show','0',0),
	(22795,989,'access_list__show','0',0),
	(22796,989,'created__show','0',0),
	(22797,989,'modified__show','0',0),
	(22798,989,'comment_message__show','0',0),
	(22799,989,'last_comment__show','0',0),
	(22800,989,'attachment_filename__show','0',0),
	(22801,989,'last_attachment__show','0',0),
	(22802,989,'_limit','-1',0),
	(22803,989,'_order_column','full_name_with_type',0),
	(22804,989,'_order_direction','ASC',0),
	(22805,989,'created','_minus_1_days_',0),
	(22806,989,'created__comp_type','1',0),
	(22807,990,'advanced_filter','1',0),
	(22808,990,'name__show','1',0),
	(22809,990,'description__show','1',0),
	(22810,990,'_limit','-1',0),
	(22811,990,'_order_column','created',0),
	(22812,990,'_order_direction','DESC',0),
	(22813,991,'advanced_filter','1',0),
	(22814,991,'queue_id__show','1',0),
	(22815,991,'model__show','1',0),
	(22816,991,'foreign_key__show','1',0),
	(22817,991,'description__show','1',0),
	(22818,991,'status__show','1',0),
	(22819,991,'created__show','1',0),
	(22820,991,'_limit','-1',0),
	(22821,991,'_order_column','id',0),
	(22822,991,'_order_direction','ASC',0),
	(22823,991,'status','1',0),
	(22824,992,'advanced_filter','1',0),
	(22825,992,'queue_id__show','1',0),
	(22826,992,'model__show','1',0),
	(22827,992,'foreign_key__show','1',0),
	(22828,992,'description__show','1',0),
	(22829,992,'status__show','1',0),
	(22830,992,'created__show','1',0),
	(22831,992,'_limit','-1',0),
	(22832,992,'_order_column','id',0),
	(22833,992,'_order_direction','ASC',0),
	(22834,992,'status','0',0),
	(22835,993,'advanced_filter','1',0),
	(22836,993,'id__show','1',0),
	(22837,993,'created__show','0',0),
	(22838,993,'type__show','0',0),
	(22839,993,'execution_time__show','0',0),
	(22840,993,'status__show','0',0),
	(22841,993,'message__show','0',0),
	(22842,993,'_limit','-1',0),
	(22843,993,'_order_column','id',0),
	(22844,993,'_order_direction','ASC',0),
	(22845,993,'last_comment','_minus_1_days_',0),
	(22846,993,'last_comment__comp_type','1',0),
	(22847,994,'advanced_filter','1',0),
	(22848,994,'id__show','1',0),
	(22849,994,'created__show','0',0),
	(22850,994,'type__show','0',0),
	(22851,994,'execution_time__show','0',0),
	(22852,994,'status__show','0',0),
	(22853,994,'message__show','0',0),
	(22854,994,'_limit','-1',0),
	(22855,994,'_order_column','id',0),
	(22856,994,'_order_direction','ASC',0),
	(22857,994,'last_attachment','_minus_1_days_',0),
	(22858,994,'last_attachment__comp_type','1',0),
	(22859,995,'advanced_filter','1',0),
	(22860,995,'id__show','1',0),
	(22861,995,'created__show','0',0),
	(22862,995,'type__show','0',0),
	(22863,995,'execution_time__show','0',0),
	(22864,995,'status__show','0',0),
	(22865,995,'message__show','0',0),
	(22866,995,'_limit','-1',0),
	(22867,995,'_order_column','id',0),
	(22868,995,'_order_direction','ASC',0),
	(22869,995,'created','_minus_1_days_',0),
	(22870,995,'created__comp_type','1',0),
	(22871,996,'advanced_filter','1',0),
	(22872,996,'created__show','1',0),
	(22873,996,'type__show','1',0),
	(22874,996,'execution_time__show','1',0),
	(22875,996,'status__show','1',0),
	(22876,996,'message__show','1',0),
	(22877,996,'_limit','-1',0),
	(22878,996,'_order_column','created',0),
	(22879,996,'_order_direction','DESC',0),
	(22880,997,'advanced_filter','1',0),
	(22881,997,'created__show','1',0),
	(22882,997,'type__show','1',0),
	(22883,997,'execution_time__show','1',0),
	(22884,997,'status__show','1',0),
	(22885,997,'message__show','1',0),
	(22886,997,'_limit','-1',0),
	(22887,997,'_order_column','id',0),
	(22888,997,'_order_direction','ASC',0),
	(22889,997,'status','error',0),
	(22890,998,'advanced_filter','1',0),
	(22891,998,'id__show','0',0),
	(22892,998,'name__show','1',0),
	(22893,998,'client_id__show','0',0),
	(22894,998,'client_secret__show','0',0),
	(22895,998,'provider__show','0',0),
	(22896,998,'status__show','0',0),
	(22897,998,'created__show','0',0),
	(22898,998,'modified__show','0',0),
	(22899,998,'comment_message__show','1',0),
	(22900,998,'last_comment__show','0',0),
	(22901,998,'attachment_filename__show','0',0),
	(22902,998,'last_attachment__show','0',0),
	(22903,998,'_limit','-1',0),
	(22904,998,'_order_column','name',0),
	(22905,998,'_order_direction','ASC',0),
	(22906,998,'last_comment','_minus_1_days_',0),
	(22907,998,'last_comment__comp_type','1',0),
	(22908,999,'advanced_filter','1',0),
	(22909,999,'id__show','0',0),
	(22910,999,'name__show','1',0),
	(22911,999,'client_id__show','0',0),
	(22912,999,'client_secret__show','0',0),
	(22913,999,'provider__show','0',0),
	(22914,999,'status__show','0',0),
	(22915,999,'created__show','0',0),
	(22916,999,'modified__show','0',0),
	(22917,999,'comment_message__show','0',0),
	(22918,999,'last_comment__show','0',0),
	(22919,999,'attachment_filename__show','1',0),
	(22920,999,'last_attachment__show','0',0),
	(22921,999,'_limit','-1',0),
	(22922,999,'_order_column','name',0),
	(22923,999,'_order_direction','ASC',0),
	(22924,999,'last_attachment','_minus_1_days_',0),
	(22925,999,'last_attachment__comp_type','1',0),
	(22926,1000,'advanced_filter','1',0),
	(22927,1000,'id__show','0',0),
	(22928,1000,'name__show','1',0),
	(22929,1000,'client_id__show','0',0),
	(22930,1000,'client_secret__show','0',0),
	(22931,1000,'provider__show','0',0),
	(22932,1000,'status__show','0',0),
	(22933,1000,'created__show','0',0),
	(22934,1000,'modified__show','0',0),
	(22935,1000,'comment_message__show','0',0),
	(22936,1000,'last_comment__show','0',0),
	(22937,1000,'attachment_filename__show','0',0),
	(22938,1000,'last_attachment__show','0',0),
	(22939,1000,'_limit','-1',0),
	(22940,1000,'_order_column','name',0),
	(22941,1000,'_order_direction','ASC',0),
	(22942,1000,'modified','_minus_1_days_',0),
	(22943,1000,'modified__comp_type','1',0),
	(22944,1001,'advanced_filter','1',0),
	(22945,1001,'id__show','0',0),
	(22946,1001,'name__show','1',0),
	(22947,1001,'client_id__show','0',0),
	(22948,1001,'client_secret__show','0',0),
	(22949,1001,'provider__show','0',0),
	(22950,1001,'status__show','0',0),
	(22951,1001,'created__show','0',0),
	(22952,1001,'modified__show','0',0),
	(22953,1001,'comment_message__show','0',0),
	(22954,1001,'last_comment__show','0',0),
	(22955,1001,'attachment_filename__show','0',0),
	(22956,1001,'last_attachment__show','0',0),
	(22957,1001,'_limit','-1',0),
	(22958,1001,'_order_column','name',0),
	(22959,1001,'_order_direction','ASC',0),
	(22960,1001,'created','_minus_1_days_',0),
	(22961,1001,'created__comp_type','1',0),
	(22962,1002,'advanced_filter','1',0),
	(22963,1002,'name__show','1',0),
	(22964,1002,'client_id__show','1',0),
	(22965,1002,'client_secret__show','1',0),
	(22966,1002,'provider__show','1',0),
	(22967,1002,'status__show','1',0),
	(22968,1002,'_limit','-1',0),
	(22969,1002,'_order_column','created',0),
	(22970,1002,'_order_direction','DESC',0),
	(22971,1003,'advanced_filter','1',0),
	(22972,1003,'id__show','0',0),
	(22973,1003,'name__show','1',0),
	(22974,1003,'description__show','0',0),
	(22975,1003,'host__show','0',0),
	(22976,1003,'domain__show','0',0),
	(22977,1003,'port__show','0',0),
	(22978,1003,'ldap_bind_dn__show','0',0),
	(22979,1003,'ldap_bind_pw__show','0',0),
	(22980,1003,'ldap_base_dn__show','0',0),
	(22981,1003,'type__show','0',0),
	(22982,1003,'ldap_auth_filter__show','0',0),
	(22983,1003,'ldap_auth_attribute__show','0',0),
	(22984,1003,'ldap_name_attribute__show','0',0),
	(22985,1003,'ldap_email_attribute__show','0',0),
	(22986,1003,'ldap_memberof_attribute__show','0',0),
	(22987,1003,'ldap_grouplist_filter__show','0',0),
	(22988,1003,'ldap_grouplist_name__show','0',0),
	(22989,1003,'ldap_groupmemberlist_filter__show','0',0),
	(22990,1003,'ldap_group_account_attribute__show','0',0),
	(22991,1003,'ldap_group_email_attribute__show','0',0),
	(22992,1003,'ldap_group_fetch_email_type__show','0',0),
	(22993,1003,'ldap_group_mail_domain__show','0',0),
	(22994,1003,'status__show','0',0),
	(22995,1003,'created__show','0',0),
	(22996,1003,'modified__show','0',0),
	(22997,1003,'comment_message__show','1',0),
	(22998,1003,'last_comment__show','0',0),
	(22999,1003,'attachment_filename__show','0',0),
	(23000,1003,'last_attachment__show','0',0),
	(23001,1003,'_limit','-1',0),
	(23002,1003,'_order_column','name',0),
	(23003,1003,'_order_direction','ASC',0),
	(23004,1003,'last_comment','_minus_1_days_',0),
	(23005,1003,'last_comment__comp_type','1',0),
	(23006,1004,'advanced_filter','1',0),
	(23007,1004,'id__show','0',0),
	(23008,1004,'name__show','1',0),
	(23009,1004,'description__show','0',0),
	(23010,1004,'host__show','0',0),
	(23011,1004,'domain__show','0',0),
	(23012,1004,'port__show','0',0),
	(23013,1004,'ldap_bind_dn__show','0',0),
	(23014,1004,'ldap_bind_pw__show','0',0),
	(23015,1004,'ldap_base_dn__show','0',0),
	(23016,1004,'type__show','0',0),
	(23017,1004,'ldap_auth_filter__show','0',0),
	(23018,1004,'ldap_auth_attribute__show','0',0),
	(23019,1004,'ldap_name_attribute__show','0',0),
	(23020,1004,'ldap_email_attribute__show','0',0),
	(23021,1004,'ldap_memberof_attribute__show','0',0),
	(23022,1004,'ldap_grouplist_filter__show','0',0),
	(23023,1004,'ldap_grouplist_name__show','0',0),
	(23024,1004,'ldap_groupmemberlist_filter__show','0',0),
	(23025,1004,'ldap_group_account_attribute__show','0',0),
	(23026,1004,'ldap_group_email_attribute__show','0',0),
	(23027,1004,'ldap_group_fetch_email_type__show','0',0),
	(23028,1004,'ldap_group_mail_domain__show','0',0),
	(23029,1004,'status__show','0',0),
	(23030,1004,'created__show','0',0),
	(23031,1004,'modified__show','0',0),
	(23032,1004,'comment_message__show','0',0),
	(23033,1004,'last_comment__show','0',0),
	(23034,1004,'attachment_filename__show','1',0),
	(23035,1004,'last_attachment__show','0',0),
	(23036,1004,'_limit','-1',0),
	(23037,1004,'_order_column','name',0),
	(23038,1004,'_order_direction','ASC',0),
	(23039,1004,'last_attachment','_minus_1_days_',0),
	(23040,1004,'last_attachment__comp_type','1',0),
	(23041,1005,'advanced_filter','1',0),
	(23042,1005,'id__show','0',0),
	(23043,1005,'name__show','1',0),
	(23044,1005,'description__show','0',0),
	(23045,1005,'host__show','0',0),
	(23046,1005,'domain__show','0',0),
	(23047,1005,'port__show','0',0),
	(23048,1005,'ldap_bind_dn__show','0',0),
	(23049,1005,'ldap_bind_pw__show','0',0),
	(23050,1005,'ldap_base_dn__show','0',0),
	(23051,1005,'type__show','0',0),
	(23052,1005,'ldap_auth_filter__show','0',0),
	(23053,1005,'ldap_auth_attribute__show','0',0),
	(23054,1005,'ldap_name_attribute__show','0',0),
	(23055,1005,'ldap_email_attribute__show','0',0),
	(23056,1005,'ldap_memberof_attribute__show','0',0),
	(23057,1005,'ldap_grouplist_filter__show','0',0),
	(23058,1005,'ldap_grouplist_name__show','0',0),
	(23059,1005,'ldap_groupmemberlist_filter__show','0',0),
	(23060,1005,'ldap_group_account_attribute__show','0',0),
	(23061,1005,'ldap_group_email_attribute__show','0',0),
	(23062,1005,'ldap_group_fetch_email_type__show','0',0),
	(23063,1005,'ldap_group_mail_domain__show','0',0),
	(23064,1005,'status__show','0',0),
	(23065,1005,'created__show','0',0),
	(23066,1005,'modified__show','0',0),
	(23067,1005,'comment_message__show','0',0),
	(23068,1005,'last_comment__show','0',0),
	(23069,1005,'attachment_filename__show','0',0),
	(23070,1005,'last_attachment__show','0',0),
	(23071,1005,'_limit','-1',0),
	(23072,1005,'_order_column','name',0),
	(23073,1005,'_order_direction','ASC',0),
	(23074,1005,'modified','_minus_1_days_',0),
	(23075,1005,'modified__comp_type','1',0),
	(23076,1006,'advanced_filter','1',0),
	(23077,1006,'id__show','0',0),
	(23078,1006,'name__show','1',0),
	(23079,1006,'description__show','0',0),
	(23080,1006,'host__show','0',0),
	(23081,1006,'domain__show','0',0),
	(23082,1006,'port__show','0',0),
	(23083,1006,'ldap_bind_dn__show','0',0),
	(23084,1006,'ldap_bind_pw__show','0',0),
	(23085,1006,'ldap_base_dn__show','0',0),
	(23086,1006,'type__show','0',0),
	(23087,1006,'ldap_auth_filter__show','0',0),
	(23088,1006,'ldap_auth_attribute__show','0',0),
	(23089,1006,'ldap_name_attribute__show','0',0),
	(23090,1006,'ldap_email_attribute__show','0',0),
	(23091,1006,'ldap_memberof_attribute__show','0',0),
	(23092,1006,'ldap_grouplist_filter__show','0',0),
	(23093,1006,'ldap_grouplist_name__show','0',0),
	(23094,1006,'ldap_groupmemberlist_filter__show','0',0),
	(23095,1006,'ldap_group_account_attribute__show','0',0),
	(23096,1006,'ldap_group_email_attribute__show','0',0),
	(23097,1006,'ldap_group_fetch_email_type__show','0',0),
	(23098,1006,'ldap_group_mail_domain__show','0',0),
	(23099,1006,'status__show','0',0),
	(23100,1006,'created__show','0',0),
	(23101,1006,'modified__show','0',0),
	(23102,1006,'comment_message__show','0',0),
	(23103,1006,'last_comment__show','0',0),
	(23104,1006,'attachment_filename__show','0',0),
	(23105,1006,'last_attachment__show','0',0),
	(23106,1006,'_limit','-1',0),
	(23107,1006,'_order_column','name',0),
	(23108,1006,'_order_direction','ASC',0),
	(23109,1006,'created','_minus_1_days_',0),
	(23110,1006,'created__comp_type','1',0),
	(23111,1007,'advanced_filter','1',0),
	(23112,1007,'name__show','1',0),
	(23113,1007,'description__show','1',0),
	(23114,1007,'type__show','1',0),
	(23115,1007,'status__show','1',0),
	(23116,1007,'_limit','-1',0),
	(23117,1007,'_order_column','created',0),
	(23118,1007,'_order_direction','DESC',0),
	(23119,1008,'advanced_filter','1',0),
	(23120,1008,'id__show','0',0),
	(23121,1008,'DataAssetInstance-asset_id__show','0',0),
	(23122,1008,'data_asset_status_id__show','0',0),
	(23123,1008,'title__show','1',0),
	(23124,1008,'description__show','0',0),
	(23125,1008,'order__show','0',0),
	(23126,1008,'BusinessUnit__show','0',0),
	(23127,1008,'ThirdParty__show','0',0),
	(23128,1008,'Risk__show','0',0),
	(23129,1008,'ThirdPartyRisk__show','0',0),
	(23130,1008,'BusinessContinuity__show','0',0),
	(23131,1008,'Project__show','0',0),
	(23132,1008,'ProjectAchievement-description__show','0',0),
	(23133,1008,'ObjectStatus_project_planned__show','0',0),
	(23134,1008,'ObjectStatus_project_ongoing__show','0',0),
	(23135,1008,'ObjectStatus_project_closed__show','0',0),
	(23136,1008,'ObjectStatus_project_expired__show','0',0),
	(23137,1008,'ObjectStatus_project_expired_tasks__show','0',0),
	(23138,1008,'SecurityService__show','0',0),
	(23139,1008,'SecurityService-objective__show','0',0),
	(23140,1008,'SecurityPolicy__show','0',0),
	(23141,1008,'DataAssetGdprDataType-data_type__show','0',0),
	(23142,1008,'DataAssetGdpr-purpose__show','0',0),
	(23143,1008,'DataAssetGdpr-right_to_be_informed__show','0',0),
	(23144,1008,'DataAssetGdpr-data_subject__show','0',0),
	(23145,1008,'DataAssetGdprCollectionMethod-collection_method__show','0',0),
	(23146,1008,'DataAssetGdpr-volume__show','0',0),
	(23147,1008,'DataAssetGdpr-recived_data__show','0',0),
	(23148,1008,'DataAssetGdprLawfulBase-lawful_base__show','0',0),
	(23149,1008,'DataAssetGdpr-contracts__show','0',0),
	(23150,1008,'DataAssetGdpr-stakeholders__show','0',0),
	(23151,1008,'DataAssetGdpr-accuracy__show','0',0),
	(23152,1008,'DataAssetGdpr-right_to_access__show','0',0),
	(23153,1008,'DataAssetGdpr-right_to_rectification__show','0',0),
	(23154,1008,'DataAssetGdpr-right_to_decision__show','0',0),
	(23155,1008,'DataAssetGdpr-right_to_object__show','0',0),
	(23156,1008,'DataAssetGdpr-retention__show','0',0),
	(23157,1008,'DataAssetGdpr-encryption__show','0',0),
	(23158,1008,'DataAssetGdpr-right_to_erasure__show','0',0),
	(23159,1008,'DataAssetGdprArchivingDriver-archiving_driver__show','0',0),
	(23160,1008,'DataAssetGdpr-origin__show','0',0),
	(23161,1008,'DataAssetGdpr-destination__show','0',0),
	(23162,1008,'DataAssetGdpr-transfer_outside_eea__show','0',0),
	(23163,1008,'ThirdPartyInvolved-country_id__show','0',0),
	(23164,1008,'DataAssetGdpr-third_party_involved_all__show','0',0),
	(23165,1008,'DataAssetGdprThirdPartyCountry-third_party_country__show','0',0),
	(23166,1008,'DataAssetGdpr-security__show','0',0),
	(23167,1008,'DataAssetGdpr-right_to_portability__show','0',0),
	(23168,1008,'created__show','0',0),
	(23169,1008,'modified__show','0',0),
	(23170,1008,'comment_message__show','1',0),
	(23171,1008,'last_comment__show','0',0),
	(23172,1008,'attachment_filename__show','0',0),
	(23173,1008,'last_attachment__show','0',0),
	(23174,1008,'_limit','-1',0),
	(23175,1008,'_order_column','title',0),
	(23176,1008,'_order_direction','ASC',0),
	(23177,1008,'last_comment','_minus_1_days_',0),
	(23178,1008,'last_comment__comp_type','1',0),
	(23179,1009,'advanced_filter','1',0),
	(23180,1009,'id__show','0',0),
	(23181,1009,'DataAssetInstance-asset_id__show','0',0),
	(23182,1009,'data_asset_status_id__show','0',0),
	(23183,1009,'title__show','1',0),
	(23184,1009,'description__show','0',0),
	(23185,1009,'order__show','0',0),
	(23186,1009,'BusinessUnit__show','0',0),
	(23187,1009,'ThirdParty__show','0',0),
	(23188,1009,'Risk__show','0',0),
	(23189,1009,'ThirdPartyRisk__show','0',0),
	(23190,1009,'BusinessContinuity__show','0',0),
	(23191,1009,'Project__show','0',0),
	(23192,1009,'ProjectAchievement-description__show','0',0),
	(23193,1009,'ObjectStatus_project_planned__show','0',0),
	(23194,1009,'ObjectStatus_project_ongoing__show','0',0),
	(23195,1009,'ObjectStatus_project_closed__show','0',0),
	(23196,1009,'ObjectStatus_project_expired__show','0',0),
	(23197,1009,'ObjectStatus_project_expired_tasks__show','0',0),
	(23198,1009,'SecurityService__show','0',0),
	(23199,1009,'SecurityService-objective__show','0',0),
	(23200,1009,'SecurityPolicy__show','0',0),
	(23201,1009,'DataAssetGdprDataType-data_type__show','0',0),
	(23202,1009,'DataAssetGdpr-purpose__show','0',0),
	(23203,1009,'DataAssetGdpr-right_to_be_informed__show','0',0),
	(23204,1009,'DataAssetGdpr-data_subject__show','0',0),
	(23205,1009,'DataAssetGdprCollectionMethod-collection_method__show','0',0),
	(23206,1009,'DataAssetGdpr-volume__show','0',0),
	(23207,1009,'DataAssetGdpr-recived_data__show','0',0),
	(23208,1009,'DataAssetGdprLawfulBase-lawful_base__show','0',0),
	(23209,1009,'DataAssetGdpr-contracts__show','0',0),
	(23210,1009,'DataAssetGdpr-stakeholders__show','0',0),
	(23211,1009,'DataAssetGdpr-accuracy__show','0',0),
	(23212,1009,'DataAssetGdpr-right_to_access__show','0',0),
	(23213,1009,'DataAssetGdpr-right_to_rectification__show','0',0),
	(23214,1009,'DataAssetGdpr-right_to_decision__show','0',0),
	(23215,1009,'DataAssetGdpr-right_to_object__show','0',0),
	(23216,1009,'DataAssetGdpr-retention__show','0',0),
	(23217,1009,'DataAssetGdpr-encryption__show','0',0),
	(23218,1009,'DataAssetGdpr-right_to_erasure__show','0',0),
	(23219,1009,'DataAssetGdprArchivingDriver-archiving_driver__show','0',0),
	(23220,1009,'DataAssetGdpr-origin__show','0',0),
	(23221,1009,'DataAssetGdpr-destination__show','0',0),
	(23222,1009,'DataAssetGdpr-transfer_outside_eea__show','0',0),
	(23223,1009,'ThirdPartyInvolved-country_id__show','0',0),
	(23224,1009,'DataAssetGdpr-third_party_involved_all__show','0',0),
	(23225,1009,'DataAssetGdprThirdPartyCountry-third_party_country__show','0',0),
	(23226,1009,'DataAssetGdpr-security__show','0',0),
	(23227,1009,'DataAssetGdpr-right_to_portability__show','0',0),
	(23228,1009,'created__show','0',0),
	(23229,1009,'modified__show','0',0),
	(23230,1009,'comment_message__show','0',0),
	(23231,1009,'last_comment__show','0',0),
	(23232,1009,'attachment_filename__show','1',0),
	(23233,1009,'last_attachment__show','0',0),
	(23234,1009,'_limit','-1',0),
	(23235,1009,'_order_column','title',0),
	(23236,1009,'_order_direction','ASC',0),
	(23237,1009,'last_attachment','_minus_1_days_',0),
	(23238,1009,'last_attachment__comp_type','1',0),
	(23239,1010,'advanced_filter','1',0),
	(23240,1010,'id__show','0',0),
	(23241,1010,'DataAssetInstance-asset_id__show','0',0),
	(23242,1010,'data_asset_status_id__show','0',0),
	(23243,1010,'title__show','1',0),
	(23244,1010,'description__show','0',0),
	(23245,1010,'order__show','0',0),
	(23246,1010,'BusinessUnit__show','0',0),
	(23247,1010,'ThirdParty__show','0',0),
	(23248,1010,'Risk__show','0',0),
	(23249,1010,'ThirdPartyRisk__show','0',0),
	(23250,1010,'BusinessContinuity__show','0',0),
	(23251,1010,'Project__show','0',0),
	(23252,1010,'ProjectAchievement-description__show','0',0),
	(23253,1010,'ObjectStatus_project_planned__show','0',0),
	(23254,1010,'ObjectStatus_project_ongoing__show','0',0),
	(23255,1010,'ObjectStatus_project_closed__show','0',0),
	(23256,1010,'ObjectStatus_project_expired__show','0',0),
	(23257,1010,'ObjectStatus_project_expired_tasks__show','0',0),
	(23258,1010,'SecurityService__show','0',0),
	(23259,1010,'SecurityService-objective__show','0',0),
	(23260,1010,'SecurityPolicy__show','0',0),
	(23261,1010,'DataAssetGdprDataType-data_type__show','0',0),
	(23262,1010,'DataAssetGdpr-purpose__show','0',0),
	(23263,1010,'DataAssetGdpr-right_to_be_informed__show','0',0),
	(23264,1010,'DataAssetGdpr-data_subject__show','0',0),
	(23265,1010,'DataAssetGdprCollectionMethod-collection_method__show','0',0),
	(23266,1010,'DataAssetGdpr-volume__show','0',0),
	(23267,1010,'DataAssetGdpr-recived_data__show','0',0),
	(23268,1010,'DataAssetGdprLawfulBase-lawful_base__show','0',0),
	(23269,1010,'DataAssetGdpr-contracts__show','0',0),
	(23270,1010,'DataAssetGdpr-stakeholders__show','0',0),
	(23271,1010,'DataAssetGdpr-accuracy__show','0',0),
	(23272,1010,'DataAssetGdpr-right_to_access__show','0',0),
	(23273,1010,'DataAssetGdpr-right_to_rectification__show','0',0),
	(23274,1010,'DataAssetGdpr-right_to_decision__show','0',0),
	(23275,1010,'DataAssetGdpr-right_to_object__show','0',0),
	(23276,1010,'DataAssetGdpr-retention__show','0',0),
	(23277,1010,'DataAssetGdpr-encryption__show','0',0),
	(23278,1010,'DataAssetGdpr-right_to_erasure__show','0',0),
	(23279,1010,'DataAssetGdprArchivingDriver-archiving_driver__show','0',0),
	(23280,1010,'DataAssetGdpr-origin__show','0',0),
	(23281,1010,'DataAssetGdpr-destination__show','0',0),
	(23282,1010,'DataAssetGdpr-transfer_outside_eea__show','0',0),
	(23283,1010,'ThirdPartyInvolved-country_id__show','0',0),
	(23284,1010,'DataAssetGdpr-third_party_involved_all__show','0',0),
	(23285,1010,'DataAssetGdprThirdPartyCountry-third_party_country__show','0',0),
	(23286,1010,'DataAssetGdpr-security__show','0',0),
	(23287,1010,'DataAssetGdpr-right_to_portability__show','0',0),
	(23288,1010,'created__show','0',0),
	(23289,1010,'modified__show','0',0),
	(23290,1010,'comment_message__show','0',0),
	(23291,1010,'last_comment__show','0',0),
	(23292,1010,'attachment_filename__show','0',0),
	(23293,1010,'last_attachment__show','0',0),
	(23294,1010,'_limit','-1',0),
	(23295,1010,'_order_column','title',0),
	(23296,1010,'_order_direction','ASC',0),
	(23297,1010,'modified','_minus_1_days_',0),
	(23298,1010,'modified__comp_type','1',0),
	(23299,1011,'advanced_filter','1',0),
	(23300,1011,'id__show','0',0),
	(23301,1011,'DataAssetInstance-asset_id__show','0',0),
	(23302,1011,'data_asset_status_id__show','0',0),
	(23303,1011,'title__show','1',0),
	(23304,1011,'description__show','0',0),
	(23305,1011,'order__show','0',0),
	(23306,1011,'BusinessUnit__show','0',0),
	(23307,1011,'ThirdParty__show','0',0),
	(23308,1011,'Risk__show','0',0),
	(23309,1011,'ThirdPartyRisk__show','0',0),
	(23310,1011,'BusinessContinuity__show','0',0),
	(23311,1011,'Project__show','0',0),
	(23312,1011,'ProjectAchievement-description__show','0',0),
	(23313,1011,'ObjectStatus_project_planned__show','0',0),
	(23314,1011,'ObjectStatus_project_ongoing__show','0',0),
	(23315,1011,'ObjectStatus_project_closed__show','0',0),
	(23316,1011,'ObjectStatus_project_expired__show','0',0),
	(23317,1011,'ObjectStatus_project_expired_tasks__show','0',0),
	(23318,1011,'SecurityService__show','0',0),
	(23319,1011,'SecurityService-objective__show','0',0),
	(23320,1011,'SecurityPolicy__show','0',0),
	(23321,1011,'DataAssetGdprDataType-data_type__show','0',0),
	(23322,1011,'DataAssetGdpr-purpose__show','0',0),
	(23323,1011,'DataAssetGdpr-right_to_be_informed__show','0',0),
	(23324,1011,'DataAssetGdpr-data_subject__show','0',0),
	(23325,1011,'DataAssetGdprCollectionMethod-collection_method__show','0',0),
	(23326,1011,'DataAssetGdpr-volume__show','0',0),
	(23327,1011,'DataAssetGdpr-recived_data__show','0',0),
	(23328,1011,'DataAssetGdprLawfulBase-lawful_base__show','0',0),
	(23329,1011,'DataAssetGdpr-contracts__show','0',0),
	(23330,1011,'DataAssetGdpr-stakeholders__show','0',0),
	(23331,1011,'DataAssetGdpr-accuracy__show','0',0),
	(23332,1011,'DataAssetGdpr-right_to_access__show','0',0),
	(23333,1011,'DataAssetGdpr-right_to_rectification__show','0',0),
	(23334,1011,'DataAssetGdpr-right_to_decision__show','0',0),
	(23335,1011,'DataAssetGdpr-right_to_object__show','0',0),
	(23336,1011,'DataAssetGdpr-retention__show','0',0),
	(23337,1011,'DataAssetGdpr-encryption__show','0',0),
	(23338,1011,'DataAssetGdpr-right_to_erasure__show','0',0),
	(23339,1011,'DataAssetGdprArchivingDriver-archiving_driver__show','0',0),
	(23340,1011,'DataAssetGdpr-origin__show','0',0),
	(23341,1011,'DataAssetGdpr-destination__show','0',0),
	(23342,1011,'DataAssetGdpr-transfer_outside_eea__show','0',0),
	(23343,1011,'ThirdPartyInvolved-country_id__show','0',0),
	(23344,1011,'DataAssetGdpr-third_party_involved_all__show','0',0),
	(23345,1011,'DataAssetGdprThirdPartyCountry-third_party_country__show','0',0),
	(23346,1011,'DataAssetGdpr-security__show','0',0),
	(23347,1011,'DataAssetGdpr-right_to_portability__show','0',0),
	(23348,1011,'created__show','0',0),
	(23349,1011,'modified__show','0',0),
	(23350,1011,'comment_message__show','0',0),
	(23351,1011,'last_comment__show','0',0),
	(23352,1011,'attachment_filename__show','0',0),
	(23353,1011,'last_attachment__show','0',0),
	(23354,1011,'_limit','-1',0),
	(23355,1011,'_order_column','title',0),
	(23356,1011,'_order_direction','ASC',0),
	(23357,1011,'created','_minus_1_days_',0),
	(23358,1011,'created__comp_type','1',0),
	(23359,1012,'advanced_filter','1',0),
	(23360,1012,'data_asset_status_id__show','1',0),
	(23361,1012,'title__show','1',0),
	(23362,1012,'_limit','-1',0),
	(23363,1012,'_order_column','created',0),
	(23364,1012,'_order_direction','DESC',0),
	(23365,1013,'advanced_filter','1',0),
	(23366,1013,'data_asset_status_id__show','1',0),
	(23367,1013,'title__show','1',0),
	(23368,1013,'_limit','-1',0),
	(23369,1013,'_order_column','title',0),
	(23370,1013,'_order_direction','ASC',0),
	(23371,1013,'data_asset_status_id','1',0),
	(23372,1014,'advanced_filter','1',0),
	(23373,1014,'data_asset_status_id__show','1',0),
	(23374,1014,'title__show','1',0),
	(23375,1014,'_limit','-1',0),
	(23376,1014,'_order_column','title',0),
	(23377,1014,'_order_direction','ASC',0),
	(23378,1014,'data_asset_status_id','2',0),
	(23379,1015,'advanced_filter','1',0),
	(23380,1015,'data_asset_status_id__show','1',0),
	(23381,1015,'title__show','1',0),
	(23382,1015,'_limit','-1',0),
	(23383,1015,'_order_column','title',0),
	(23384,1015,'_order_direction','ASC',0),
	(23385,1015,'data_asset_status_id','3',0),
	(23386,1016,'advanced_filter','1',0),
	(23387,1016,'data_asset_status_id__show','1',0),
	(23388,1016,'title__show','1',0),
	(23389,1016,'_limit','-1',0),
	(23390,1016,'_order_column','title',0),
	(23391,1016,'_order_direction','ASC',0),
	(23392,1016,'data_asset_status_id','4',0),
	(23393,1017,'advanced_filter','1',0),
	(23394,1017,'data_asset_status_id__show','1',0),
	(23395,1017,'title__show','1',0),
	(23396,1017,'_limit','-1',0),
	(23397,1017,'_order_column','title',0),
	(23398,1017,'_order_direction','ASC',0),
	(23399,1017,'data_asset_status_id','5',0),
	(23400,1018,'advanced_filter','1',0),
	(23401,1018,'id__show','0',0),
	(23402,1018,'asset_id__show','1',0),
	(23403,1018,'Asset-AssetOwner__show','0',0),
	(23404,1018,'ObjectStatus_asset_missing_review__show','0',0),
	(23405,1018,'ObjectStatus_incomplete_analysis__show','0',0),
	(23406,1018,'DataAssetSetting-gdpr_enabled__show','0',0),
	(23407,1018,'DataAssetSetting-driver_for_compliance__show','0',0),
	(23408,1018,'DataAssetSetting-Dpo__show','0',0),
	(23409,1018,'DataAssetSetting-Processor__show','0',0),
	(23410,1018,'DataAssetSetting-Controller__show','0',0),
	(23411,1018,'DataAssetSetting-ControllerRepresentative__show','0',0),
	(23412,1018,'SupervisoryAuthority-country_id__show','0',0),
	(23413,1018,'ObjectStatus_incomplete_gdpr_analysis__show','0',0),
	(23414,1018,'DataAsset-Risk__show','0',0),
	(23415,1018,'ObjectStatus_risk_expired_reviews__show','0',0),
	(23416,1018,'DataAsset-ThirdPartyRisk__show','0',0),
	(23417,1018,'ObjectStatus_third_party_risk_expired_reviews__show','0',0),
	(23418,1018,'DataAsset-BusinessContinuity__show','0',0),
	(23419,1018,'ObjectStatus_business_continuity_expired_reviews__show','0',0),
	(23420,1018,'DataAsset-SecurityService__show','0',0),
	(23421,1018,'ObjectStatus_controls_with_issues__show','0',0),
	(23422,1018,'ObjectStatus_controls_with_failed_audits__show','0',0),
	(23423,1018,'ObjectStatus_controls_with_missing_audits__show','0',0),
	(23424,1018,'DataAsset-SecurityPolicy__show','0',0),
	(23425,1018,'ObjectStatus_policies_with_missing_reviews__show','0',0),
	(23426,1018,'DataAsset-Project__show','0',0),
	(23427,1018,'Project-ProjectAchievement__show','0',0),
	(23428,1018,'ObjectStatus_project_planned__show','0',0),
	(23429,1018,'ObjectStatus_project_ongoing__show','0',0),
	(23430,1018,'ObjectStatus_project_closed__show','0',0),
	(23431,1018,'ObjectStatus_project_expired__show','0',0),
	(23432,1018,'ObjectStatus_project_expired_tasks__show','0',0),
	(23433,1018,'created__show','0',0),
	(23434,1018,'modified__show','0',0),
	(23435,1018,'comment_message__show','1',0),
	(23436,1018,'last_comment__show','0',0),
	(23437,1018,'attachment_filename__show','0',0),
	(23438,1018,'last_attachment__show','0',0),
	(23439,1018,'_limit','-1',0),
	(23440,1018,'_order_column','id',0),
	(23441,1018,'_order_direction','ASC',0),
	(23442,1018,'last_comment','_minus_1_days_',0),
	(23443,1018,'last_comment__comp_type','1',0),
	(23444,1019,'advanced_filter','1',0),
	(23445,1019,'id__show','0',0),
	(23446,1019,'asset_id__show','1',0),
	(23447,1019,'Asset-AssetOwner__show','0',0),
	(23448,1019,'ObjectStatus_asset_missing_review__show','0',0),
	(23449,1019,'ObjectStatus_incomplete_analysis__show','0',0),
	(23450,1019,'DataAssetSetting-gdpr_enabled__show','0',0),
	(23451,1019,'DataAssetSetting-driver_for_compliance__show','0',0),
	(23452,1019,'DataAssetSetting-Dpo__show','0',0),
	(23453,1019,'DataAssetSetting-Processor__show','0',0),
	(23454,1019,'DataAssetSetting-Controller__show','0',0),
	(23455,1019,'DataAssetSetting-ControllerRepresentative__show','0',0),
	(23456,1019,'SupervisoryAuthority-country_id__show','0',0),
	(23457,1019,'ObjectStatus_incomplete_gdpr_analysis__show','0',0),
	(23458,1019,'DataAsset-Risk__show','0',0),
	(23459,1019,'ObjectStatus_risk_expired_reviews__show','0',0),
	(23460,1019,'DataAsset-ThirdPartyRisk__show','0',0),
	(23461,1019,'ObjectStatus_third_party_risk_expired_reviews__show','0',0),
	(23462,1019,'DataAsset-BusinessContinuity__show','0',0),
	(23463,1019,'ObjectStatus_business_continuity_expired_reviews__show','0',0),
	(23464,1019,'DataAsset-SecurityService__show','0',0),
	(23465,1019,'ObjectStatus_controls_with_issues__show','0',0),
	(23466,1019,'ObjectStatus_controls_with_failed_audits__show','0',0),
	(23467,1019,'ObjectStatus_controls_with_missing_audits__show','0',0),
	(23468,1019,'DataAsset-SecurityPolicy__show','0',0),
	(23469,1019,'ObjectStatus_policies_with_missing_reviews__show','0',0),
	(23470,1019,'DataAsset-Project__show','0',0),
	(23471,1019,'Project-ProjectAchievement__show','0',0),
	(23472,1019,'ObjectStatus_project_planned__show','0',0),
	(23473,1019,'ObjectStatus_project_ongoing__show','0',0),
	(23474,1019,'ObjectStatus_project_closed__show','0',0),
	(23475,1019,'ObjectStatus_project_expired__show','0',0),
	(23476,1019,'ObjectStatus_project_expired_tasks__show','0',0),
	(23477,1019,'created__show','0',0),
	(23478,1019,'modified__show','0',0),
	(23479,1019,'comment_message__show','0',0),
	(23480,1019,'last_comment__show','0',0),
	(23481,1019,'attachment_filename__show','1',0),
	(23482,1019,'last_attachment__show','0',0),
	(23483,1019,'_limit','-1',0),
	(23484,1019,'_order_column','id',0),
	(23485,1019,'_order_direction','ASC',0),
	(23486,1019,'last_attachment','_minus_1_days_',0),
	(23487,1019,'last_attachment__comp_type','1',0),
	(23488,1020,'advanced_filter','1',0),
	(23489,1020,'id__show','0',0),
	(23490,1020,'asset_id__show','1',0),
	(23491,1020,'Asset-AssetOwner__show','0',0),
	(23492,1020,'ObjectStatus_asset_missing_review__show','0',0),
	(23493,1020,'ObjectStatus_incomplete_analysis__show','0',0),
	(23494,1020,'DataAssetSetting-gdpr_enabled__show','0',0),
	(23495,1020,'DataAssetSetting-driver_for_compliance__show','0',0),
	(23496,1020,'DataAssetSetting-Dpo__show','0',0),
	(23497,1020,'DataAssetSetting-Processor__show','0',0),
	(23498,1020,'DataAssetSetting-Controller__show','0',0),
	(23499,1020,'DataAssetSetting-ControllerRepresentative__show','0',0),
	(23500,1020,'SupervisoryAuthority-country_id__show','0',0),
	(23501,1020,'ObjectStatus_incomplete_gdpr_analysis__show','0',0),
	(23502,1020,'DataAsset-Risk__show','0',0),
	(23503,1020,'ObjectStatus_risk_expired_reviews__show','0',0),
	(23504,1020,'DataAsset-ThirdPartyRisk__show','0',0),
	(23505,1020,'ObjectStatus_third_party_risk_expired_reviews__show','0',0),
	(23506,1020,'DataAsset-BusinessContinuity__show','0',0),
	(23507,1020,'ObjectStatus_business_continuity_expired_reviews__show','0',0),
	(23508,1020,'DataAsset-SecurityService__show','0',0),
	(23509,1020,'ObjectStatus_controls_with_issues__show','0',0),
	(23510,1020,'ObjectStatus_controls_with_failed_audits__show','0',0),
	(23511,1020,'ObjectStatus_controls_with_missing_audits__show','0',0),
	(23512,1020,'DataAsset-SecurityPolicy__show','0',0),
	(23513,1020,'ObjectStatus_policies_with_missing_reviews__show','0',0),
	(23514,1020,'DataAsset-Project__show','0',0),
	(23515,1020,'Project-ProjectAchievement__show','0',0),
	(23516,1020,'ObjectStatus_project_planned__show','0',0),
	(23517,1020,'ObjectStatus_project_ongoing__show','0',0),
	(23518,1020,'ObjectStatus_project_closed__show','0',0),
	(23519,1020,'ObjectStatus_project_expired__show','0',0),
	(23520,1020,'ObjectStatus_project_expired_tasks__show','0',0),
	(23521,1020,'created__show','0',0),
	(23522,1020,'modified__show','0',0),
	(23523,1020,'comment_message__show','0',0),
	(23524,1020,'last_comment__show','0',0),
	(23525,1020,'attachment_filename__show','0',0),
	(23526,1020,'last_attachment__show','0',0),
	(23527,1020,'_limit','-1',0),
	(23528,1020,'_order_column','id',0),
	(23529,1020,'_order_direction','ASC',0),
	(23530,1020,'modified','_minus_1_days_',0),
	(23531,1020,'modified__comp_type','1',0),
	(23532,1021,'advanced_filter','1',0),
	(23533,1021,'id__show','0',0),
	(23534,1021,'asset_id__show','1',0),
	(23535,1021,'Asset-AssetOwner__show','0',0),
	(23536,1021,'ObjectStatus_asset_missing_review__show','0',0),
	(23537,1021,'ObjectStatus_incomplete_analysis__show','0',0),
	(23538,1021,'DataAssetSetting-gdpr_enabled__show','0',0),
	(23539,1021,'DataAssetSetting-driver_for_compliance__show','0',0),
	(23540,1021,'DataAssetSetting-Dpo__show','0',0),
	(23541,1021,'DataAssetSetting-Processor__show','0',0),
	(23542,1021,'DataAssetSetting-Controller__show','0',0),
	(23543,1021,'DataAssetSetting-ControllerRepresentative__show','0',0),
	(23544,1021,'SupervisoryAuthority-country_id__show','0',0),
	(23545,1021,'ObjectStatus_incomplete_gdpr_analysis__show','0',0),
	(23546,1021,'DataAsset-Risk__show','0',0),
	(23547,1021,'ObjectStatus_risk_expired_reviews__show','0',0),
	(23548,1021,'DataAsset-ThirdPartyRisk__show','0',0),
	(23549,1021,'ObjectStatus_third_party_risk_expired_reviews__show','0',0),
	(23550,1021,'DataAsset-BusinessContinuity__show','0',0),
	(23551,1021,'ObjectStatus_business_continuity_expired_reviews__show','0',0),
	(23552,1021,'DataAsset-SecurityService__show','0',0),
	(23553,1021,'ObjectStatus_controls_with_issues__show','0',0),
	(23554,1021,'ObjectStatus_controls_with_failed_audits__show','0',0),
	(23555,1021,'ObjectStatus_controls_with_missing_audits__show','0',0),
	(23556,1021,'DataAsset-SecurityPolicy__show','0',0),
	(23557,1021,'ObjectStatus_policies_with_missing_reviews__show','0',0),
	(23558,1021,'DataAsset-Project__show','0',0),
	(23559,1021,'Project-ProjectAchievement__show','0',0),
	(23560,1021,'ObjectStatus_project_planned__show','0',0),
	(23561,1021,'ObjectStatus_project_ongoing__show','0',0),
	(23562,1021,'ObjectStatus_project_closed__show','0',0),
	(23563,1021,'ObjectStatus_project_expired__show','0',0),
	(23564,1021,'ObjectStatus_project_expired_tasks__show','0',0),
	(23565,1021,'created__show','0',0),
	(23566,1021,'modified__show','0',0),
	(23567,1021,'comment_message__show','0',0),
	(23568,1021,'last_comment__show','0',0),
	(23569,1021,'attachment_filename__show','0',0),
	(23570,1021,'last_attachment__show','0',0),
	(23571,1021,'_limit','-1',0),
	(23572,1021,'_order_column','id',0),
	(23573,1021,'_order_direction','ASC',0),
	(23574,1021,'created','_minus_1_days_',0),
	(23575,1021,'created__comp_type','1',0),
	(23576,1022,'advanced_filter','1',0),
	(23577,1022,'asset_id__show','1',0),
	(23578,1022,'Asset-AssetOwner__show','1',0),
	(23579,1022,'DataAssetSetting-gdpr_enabled__show','1',0),
	(23580,1022,'DataAssetSetting-driver_for_compliance__show','1',0),
	(23581,1022,'DataAssetSetting-Dpo__show','1',0),
	(23582,1022,'DataAssetSetting-Processor__show','1',0),
	(23583,1022,'DataAssetSetting-Controller__show','1',0),
	(23584,1022,'DataAssetSetting-ControllerRepresentative__show','1',0),
	(23585,1022,'SupervisoryAuthority-country_id__show','1',0),
	(23586,1022,'_limit','-1',0),
	(23587,1022,'_order_column','created',0),
	(23588,1022,'_order_direction','DESC',0),
	(23589,1023,'advanced_filter','1',0),
	(23590,1023,'asset_id__show','1',0),
	(23591,1023,'Asset-AssetOwner__show','1',0),
	(23592,1023,'DataAssetSetting-gdpr_enabled__show','1',0),
	(23593,1023,'DataAssetSetting-driver_for_compliance__show','1',0),
	(23594,1023,'DataAssetSetting-Dpo__show','1',0),
	(23595,1023,'DataAssetSetting-Processor__show','1',0),
	(23596,1023,'DataAssetSetting-Controller__show','1',0),
	(23597,1023,'DataAssetSetting-ControllerRepresentative__show','1',0),
	(23598,1023,'SupervisoryAuthority-country_id__show','1',0),
	(23599,1023,'_limit','-1',0),
	(23600,1023,'_order_column','id',0),
	(23601,1023,'_order_direction','ASC',0),
	(23602,1023,'DataAssetSetting-gdpr_enabled','1',0),
	(23603,1024,'advanced_filter','1',0),
	(23604,1024,'id__show','0',0),
	(23605,1024,'title__show','1',0),
	(23606,1024,'description__show','0',0),
	(23607,1024,'recurrence__show','0',0),
	(23608,1024,'reminder_apart__show','0',0),
	(23609,1024,'reminder_amount__show','0',0),
	(23610,1024,'awareness_training_count__show','0',0),
	(23611,1024,'ldap_connector_id__show','0',0),
	(23612,1024,'video__show','0',0),
	(23613,1024,'questionnaire__show','0',0),
	(23614,1024,'text_file__show','0',0),
	(23615,1024,'active_users__show','0',0),
	(23616,1024,'ignored_users__show','0',0),
	(23617,1024,'compliant_users__show','0',0),
	(23618,1024,'not_compliant_users__show','0',0),
	(23619,1024,'active_users_percentage__show','0',0),
	(23620,1024,'ignored_users_percentage__show','0',0),
	(23621,1024,'compliant_users_percentage__show','0',0),
	(23622,1024,'not_compliant_users_percentage__show','0',0),
	(23623,1024,'SecurityPolicy__show','0',0),
	(23624,1024,'created__show','0',0),
	(23625,1024,'modified__show','0',0),
	(23626,1024,'comment_message__show','1',0),
	(23627,1024,'last_comment__show','0',0),
	(23628,1024,'attachment_filename__show','0',0),
	(23629,1024,'last_attachment__show','0',0),
	(23630,1024,'_limit','-1',0),
	(23631,1024,'_order_column','title',0),
	(23632,1024,'_order_direction','ASC',0),
	(23633,1024,'last_comment','_minus_1_days_',0),
	(23634,1024,'last_comment__comp_type','1',0),
	(23635,1025,'advanced_filter','1',0),
	(23636,1025,'id__show','0',0),
	(23637,1025,'title__show','1',0),
	(23638,1025,'description__show','0',0),
	(23639,1025,'recurrence__show','0',0),
	(23640,1025,'reminder_apart__show','0',0),
	(23641,1025,'reminder_amount__show','0',0),
	(23642,1025,'awareness_training_count__show','0',0),
	(23643,1025,'ldap_connector_id__show','0',0),
	(23644,1025,'video__show','0',0),
	(23645,1025,'questionnaire__show','0',0),
	(23646,1025,'text_file__show','0',0),
	(23647,1025,'active_users__show','0',0),
	(23648,1025,'ignored_users__show','0',0),
	(23649,1025,'compliant_users__show','0',0),
	(23650,1025,'not_compliant_users__show','0',0),
	(23651,1025,'active_users_percentage__show','0',0),
	(23652,1025,'ignored_users_percentage__show','0',0),
	(23653,1025,'compliant_users_percentage__show','0',0),
	(23654,1025,'not_compliant_users_percentage__show','0',0),
	(23655,1025,'SecurityPolicy__show','0',0),
	(23656,1025,'created__show','0',0),
	(23657,1025,'modified__show','0',0),
	(23658,1025,'comment_message__show','0',0),
	(23659,1025,'last_comment__show','0',0),
	(23660,1025,'attachment_filename__show','1',0),
	(23661,1025,'last_attachment__show','0',0),
	(23662,1025,'_limit','-1',0),
	(23663,1025,'_order_column','title',0),
	(23664,1025,'_order_direction','ASC',0),
	(23665,1025,'last_attachment','_minus_1_days_',0),
	(23666,1025,'last_attachment__comp_type','1',0),
	(23667,1026,'advanced_filter','1',0),
	(23668,1026,'id__show','0',0),
	(23669,1026,'title__show','1',0),
	(23670,1026,'description__show','0',0),
	(23671,1026,'recurrence__show','0',0),
	(23672,1026,'reminder_apart__show','0',0),
	(23673,1026,'reminder_amount__show','0',0),
	(23674,1026,'awareness_training_count__show','0',0),
	(23675,1026,'ldap_connector_id__show','0',0),
	(23676,1026,'video__show','0',0),
	(23677,1026,'questionnaire__show','0',0),
	(23678,1026,'text_file__show','0',0),
	(23679,1026,'active_users__show','0',0),
	(23680,1026,'ignored_users__show','0',0),
	(23681,1026,'compliant_users__show','0',0),
	(23682,1026,'not_compliant_users__show','0',0),
	(23683,1026,'active_users_percentage__show','0',0),
	(23684,1026,'ignored_users_percentage__show','0',0),
	(23685,1026,'compliant_users_percentage__show','0',0),
	(23686,1026,'not_compliant_users_percentage__show','0',0),
	(23687,1026,'SecurityPolicy__show','0',0),
	(23688,1026,'created__show','0',0),
	(23689,1026,'modified__show','0',0),
	(23690,1026,'comment_message__show','0',0),
	(23691,1026,'last_comment__show','0',0),
	(23692,1026,'attachment_filename__show','0',0),
	(23693,1026,'last_attachment__show','0',0),
	(23694,1026,'_limit','-1',0),
	(23695,1026,'_order_column','title',0),
	(23696,1026,'_order_direction','ASC',0),
	(23697,1026,'modified','_minus_1_days_',0),
	(23698,1026,'modified__comp_type','1',0),
	(23699,1027,'advanced_filter','1',0),
	(23700,1027,'id__show','0',0),
	(23701,1027,'title__show','1',0),
	(23702,1027,'description__show','0',0),
	(23703,1027,'recurrence__show','0',0),
	(23704,1027,'reminder_apart__show','0',0),
	(23705,1027,'reminder_amount__show','0',0),
	(23706,1027,'awareness_training_count__show','0',0),
	(23707,1027,'ldap_connector_id__show','0',0),
	(23708,1027,'video__show','0',0),
	(23709,1027,'questionnaire__show','0',0),
	(23710,1027,'text_file__show','0',0),
	(23711,1027,'active_users__show','0',0),
	(23712,1027,'ignored_users__show','0',0),
	(23713,1027,'compliant_users__show','0',0),
	(23714,1027,'not_compliant_users__show','0',0),
	(23715,1027,'active_users_percentage__show','0',0),
	(23716,1027,'ignored_users_percentage__show','0',0),
	(23717,1027,'compliant_users_percentage__show','0',0),
	(23718,1027,'not_compliant_users_percentage__show','0',0),
	(23719,1027,'SecurityPolicy__show','0',0),
	(23720,1027,'created__show','0',0),
	(23721,1027,'modified__show','0',0),
	(23722,1027,'comment_message__show','0',0),
	(23723,1027,'last_comment__show','0',0),
	(23724,1027,'attachment_filename__show','0',0),
	(23725,1027,'last_attachment__show','0',0),
	(23726,1027,'_limit','-1',0),
	(23727,1027,'_order_column','title',0),
	(23728,1027,'_order_direction','ASC',0),
	(23729,1027,'created','_minus_1_days_',0),
	(23730,1027,'created__comp_type','1',0),
	(23731,1028,'advanced_filter','1',0),
	(23732,1028,'title__show','1',0),
	(23733,1028,'description__show','1',0),
	(23734,1028,'recurrence__show','1',0),
	(23735,1028,'reminder_apart__show','1',0),
	(23736,1028,'reminder_amount__show','1',0),
	(23737,1028,'active_users__show','1',0),
	(23738,1028,'ignored_users__show','1',0),
	(23739,1028,'compliant_users__show','1',0),
	(23740,1028,'not_compliant_users__show','1',0),
	(23741,1028,'SecurityPolicy__show','1',0),
	(23742,1028,'_limit','-1',0),
	(23743,1028,'_order_column','created',0),
	(23744,1028,'_order_direction','DESC',0),
	(23745,1029,'advanced_filter','1',0),
	(23746,1029,'id__show','0',0),
	(23747,1029,'awareness_program_id__show','1',0),
	(23748,1029,'uid__show','1',0),
	(23749,1029,'email__show','0',0),
	(23750,1029,'name__show','0',0),
	(23751,1029,'Awareness Program Status__show','0',0),
	(23752,1029,'reminder__show','0',0),
	(23753,1029,'created__show','0',0),
	(23754,1029,'comment_message__show','1',0),
	(23755,1029,'last_comment__show','0',0),
	(23756,1029,'attachment_filename__show','0',0),
	(23757,1029,'last_attachment__show','0',0),
	(23758,1029,'_limit','-1',0),
	(23759,1029,'_order_column','name',0),
	(23760,1029,'_order_direction','ASC',0),
	(23761,1029,'last_comment','_minus_1_days_',0),
	(23762,1029,'last_comment__comp_type','1',0),
	(23763,1030,'advanced_filter','1',0),
	(23764,1030,'id__show','0',0),
	(23765,1030,'awareness_program_id__show','1',0),
	(23766,1030,'uid__show','1',0),
	(23767,1030,'email__show','0',0),
	(23768,1030,'name__show','0',0),
	(23769,1030,'Awareness Program Status__show','0',0),
	(23770,1030,'reminder__show','0',0),
	(23771,1030,'created__show','0',0),
	(23772,1030,'comment_message__show','0',0),
	(23773,1030,'last_comment__show','0',0),
	(23774,1030,'attachment_filename__show','1',0),
	(23775,1030,'last_attachment__show','0',0),
	(23776,1030,'_limit','-1',0),
	(23777,1030,'_order_column','name',0),
	(23778,1030,'_order_direction','ASC',0),
	(23779,1030,'last_attachment','_minus_1_days_',0),
	(23780,1030,'last_attachment__comp_type','1',0),
	(23781,1031,'advanced_filter','1',0),
	(23782,1031,'id__show','0',0),
	(23783,1031,'awareness_program_id__show','1',0),
	(23784,1031,'uid__show','1',0),
	(23785,1031,'email__show','0',0),
	(23786,1031,'name__show','0',0),
	(23787,1031,'Awareness Program Status__show','0',0),
	(23788,1031,'reminder__show','0',0),
	(23789,1031,'created__show','0',0),
	(23790,1031,'comment_message__show','0',0),
	(23791,1031,'last_comment__show','0',0),
	(23792,1031,'attachment_filename__show','0',0),
	(23793,1031,'last_attachment__show','0',0),
	(23794,1031,'_limit','-1',0),
	(23795,1031,'_order_column','name',0),
	(23796,1031,'_order_direction','ASC',0),
	(23797,1031,'created','_minus_1_days_',0),
	(23798,1031,'created__comp_type','1',0),
	(23799,1032,'advanced_filter','1',0),
	(23800,1032,'awareness_program_id__show','1',0),
	(23801,1032,'uid__show','1',0),
	(23802,1032,'email__show','1',0),
	(23803,1032,'name__show','1',0),
	(23804,1032,'reminder__show','1',0),
	(23805,1032,'_limit','-1',0),
	(23806,1032,'_order_column','created',0),
	(23807,1032,'_order_direction','DESC',0),
	(23808,1032,'AwarenessProgram-status','started',0),
	(23809,1032,'AwarenessProgram-status__comp_type','5',0),
	(23810,1033,'advanced_filter','1',0),
	(23811,1033,'awareness_program_id__show','1',0),
	(23812,1033,'uid__show','1',0),
	(23813,1033,'email__show','1',0),
	(23814,1033,'name__show','1',0),
	(23815,1033,'reminder__show','1',0),
	(23816,1033,'_limit','-1',0),
	(23817,1033,'_order_column','name',0),
	(23818,1033,'_order_direction','ASC',0),
	(23819,1033,'modified','_minus_7_days_',0),
	(23820,1033,'modified__comp_type','1',0),
	(23821,1034,'advanced_filter','1',0),
	(23822,1034,'awareness_program_id__show','1',0),
	(23823,1034,'uid__show','1',0),
	(23824,1034,'email__show','1',0),
	(23825,1034,'name__show','1',0),
	(23826,1034,'reminder__show','1',0),
	(23827,1034,'_limit','-1',0),
	(23828,1034,'_order_column','name',0),
	(23829,1034,'_order_direction','ASC',0),
	(23830,1034,'created','_minus_7_days_',0),
	(23831,1034,'created__comp_type','1',0),
	(23832,1035,'advanced_filter','1',0),
	(23833,1035,'id__show','0',0),
	(23834,1035,'awareness_program_id__show','1',0),
	(23835,1035,'uid__show','1',0),
	(23836,1035,'Awareness Program Status__show','0',0),
	(23837,1035,'reminder__show','0',0),
	(23838,1035,'created__show','0',0),
	(23839,1035,'comment_message__show','1',0),
	(23840,1035,'last_comment__show','0',0),
	(23841,1035,'attachment_filename__show','0',0),
	(23842,1035,'last_attachment__show','0',0),
	(23843,1035,'_limit','-1',0),
	(23844,1035,'_order_column','uid',0),
	(23845,1035,'_order_direction','ASC',0),
	(23846,1035,'last_comment','_minus_1_days_',0),
	(23847,1035,'last_comment__comp_type','1',0),
	(23848,1036,'advanced_filter','1',0),
	(23849,1036,'id__show','0',0),
	(23850,1036,'awareness_program_id__show','1',0),
	(23851,1036,'uid__show','1',0),
	(23852,1036,'Awareness Program Status__show','0',0),
	(23853,1036,'reminder__show','0',0),
	(23854,1036,'created__show','0',0),
	(23855,1036,'comment_message__show','0',0),
	(23856,1036,'last_comment__show','0',0),
	(23857,1036,'attachment_filename__show','1',0),
	(23858,1036,'last_attachment__show','0',0),
	(23859,1036,'_limit','-1',0),
	(23860,1036,'_order_column','uid',0),
	(23861,1036,'_order_direction','ASC',0),
	(23862,1036,'last_attachment','_minus_1_days_',0),
	(23863,1036,'last_attachment__comp_type','1',0),
	(23864,1037,'advanced_filter','1',0),
	(23865,1037,'id__show','0',0),
	(23866,1037,'awareness_program_id__show','1',0),
	(23867,1037,'uid__show','1',0),
	(23868,1037,'Awareness Program Status__show','0',0),
	(23869,1037,'reminder__show','0',0),
	(23870,1037,'created__show','0',0),
	(23871,1037,'comment_message__show','0',0),
	(23872,1037,'last_comment__show','0',0),
	(23873,1037,'attachment_filename__show','0',0),
	(23874,1037,'last_attachment__show','0',0),
	(23875,1037,'_limit','-1',0),
	(23876,1037,'_order_column','uid',0),
	(23877,1037,'_order_direction','ASC',0),
	(23878,1037,'created','_minus_1_days_',0),
	(23879,1037,'created__comp_type','1',0),
	(23880,1038,'advanced_filter','1',0),
	(23881,1038,'awareness_program_id__show','1',0),
	(23882,1038,'uid__show','1',0),
	(23883,1038,'reminder__show','1',0),
	(23884,1038,'_limit','-1',0),
	(23885,1038,'_order_column','created',0),
	(23886,1038,'_order_direction','DESC',0),
	(23887,1038,'AwarenessProgram-status','started',0),
	(23888,1038,'AwarenessProgram-status__comp_type','5',0),
	(23889,1039,'advanced_filter','1',0),
	(23890,1039,'awareness_program_id__show','1',0),
	(23891,1039,'uid__show','1',0),
	(23892,1039,'reminder__show','1',0),
	(23893,1039,'_limit','-1',0),
	(23894,1039,'_order_column','uid',0),
	(23895,1039,'_order_direction','ASC',0),
	(23896,1039,'modified','_minus_7_days_',0),
	(23897,1039,'modified__comp_type','1',0),
	(23898,1040,'advanced_filter','1',0),
	(23899,1040,'awareness_program_id__show','1',0),
	(23900,1040,'uid__show','1',0),
	(23901,1040,'reminder__show','1',0),
	(23902,1040,'_limit','-1',0),
	(23903,1040,'_order_column','uid',0),
	(23904,1040,'_order_direction','ASC',0),
	(23905,1040,'created','_minus_7_days_',0),
	(23906,1040,'created__comp_type','1',0),
	(23907,1041,'advanced_filter','1',0),
	(23908,1041,'id__show','0',0),
	(23909,1041,'awareness_program_id__show','1',0),
	(23910,1041,'uid__show','1',0),
	(23911,1041,'Awareness Program Status__show','0',0),
	(23912,1041,'reminder__show','0',0),
	(23913,1041,'created__show','0',0),
	(23914,1041,'comment_message__show','1',0),
	(23915,1041,'last_comment__show','0',0),
	(23916,1041,'attachment_filename__show','0',0),
	(23917,1041,'last_attachment__show','0',0),
	(23918,1041,'_limit','-1',0),
	(23919,1041,'_order_column','uid',0),
	(23920,1041,'_order_direction','ASC',0),
	(23921,1041,'last_comment','_minus_1_days_',0),
	(23922,1041,'last_comment__comp_type','1',0),
	(23923,1042,'advanced_filter','1',0),
	(23924,1042,'id__show','0',0),
	(23925,1042,'awareness_program_id__show','1',0),
	(23926,1042,'uid__show','1',0),
	(23927,1042,'Awareness Program Status__show','0',0),
	(23928,1042,'reminder__show','0',0),
	(23929,1042,'created__show','0',0),
	(23930,1042,'comment_message__show','0',0),
	(23931,1042,'last_comment__show','0',0),
	(23932,1042,'attachment_filename__show','1',0),
	(23933,1042,'last_attachment__show','0',0),
	(23934,1042,'_limit','-1',0),
	(23935,1042,'_order_column','uid',0),
	(23936,1042,'_order_direction','ASC',0),
	(23937,1042,'last_attachment','_minus_1_days_',0),
	(23938,1042,'last_attachment__comp_type','1',0),
	(23939,1043,'advanced_filter','1',0),
	(23940,1043,'id__show','0',0),
	(23941,1043,'awareness_program_id__show','1',0),
	(23942,1043,'uid__show','1',0),
	(23943,1043,'Awareness Program Status__show','0',0),
	(23944,1043,'reminder__show','0',0),
	(23945,1043,'created__show','0',0),
	(23946,1043,'comment_message__show','0',0),
	(23947,1043,'last_comment__show','0',0),
	(23948,1043,'attachment_filename__show','0',0),
	(23949,1043,'last_attachment__show','0',0),
	(23950,1043,'_limit','-1',0),
	(23951,1043,'_order_column','uid',0),
	(23952,1043,'_order_direction','ASC',0),
	(23953,1043,'created','_minus_1_days_',0),
	(23954,1043,'created__comp_type','1',0),
	(23955,1044,'advanced_filter','1',0),
	(23956,1044,'awareness_program_id__show','1',0),
	(23957,1044,'uid__show','1',0),
	(23958,1044,'reminder__show','1',0),
	(23959,1044,'_limit','-1',0),
	(23960,1044,'_order_column','created',0),
	(23961,1044,'_order_direction','DESC',0),
	(23962,1044,'AwarenessProgram-status','started',0),
	(23963,1044,'AwarenessProgram-status__comp_type','5',0),
	(23964,1045,'advanced_filter','1',0),
	(23965,1045,'awareness_program_id__show','1',0),
	(23966,1045,'uid__show','1',0),
	(23967,1045,'reminder__show','1',0),
	(23968,1045,'_limit','-1',0),
	(23969,1045,'_order_column','uid',0),
	(23970,1045,'_order_direction','ASC',0),
	(23971,1045,'modified','_minus_7_days_',0),
	(23972,1045,'modified__comp_type','1',0),
	(23973,1046,'advanced_filter','1',0),
	(23974,1046,'awareness_program_id__show','1',0),
	(23975,1046,'uid__show','1',0),
	(23976,1046,'reminder__show','1',0),
	(23977,1046,'_limit','-1',0),
	(23978,1046,'_order_column','uid',0),
	(23979,1046,'_order_direction','ASC',0),
	(23980,1046,'created','_minus_7_days_',0),
	(23981,1046,'created__comp_type','1',0),
	(23982,1047,'advanced_filter','1',0),
	(23983,1047,'id__show','0',0),
	(23984,1047,'awareness_program_id__show','1',0),
	(23985,1047,'uid__show','1',0),
	(23986,1047,'Awareness Program Status__show','0',0),
	(23987,1047,'reminder__show','0',0),
	(23988,1047,'created__show','0',0),
	(23989,1047,'comment_message__show','1',0),
	(23990,1047,'last_comment__show','0',0),
	(23991,1047,'attachment_filename__show','0',0),
	(23992,1047,'last_attachment__show','0',0),
	(23993,1047,'_limit','-1',0),
	(23994,1047,'_order_column','uid',0),
	(23995,1047,'_order_direction','ASC',0),
	(23996,1047,'last_comment','_minus_1_days_',0),
	(23997,1047,'last_comment__comp_type','1',0),
	(23998,1048,'advanced_filter','1',0),
	(23999,1048,'id__show','0',0),
	(24000,1048,'awareness_program_id__show','1',0),
	(24001,1048,'uid__show','1',0),
	(24002,1048,'Awareness Program Status__show','0',0),
	(24003,1048,'reminder__show','0',0),
	(24004,1048,'created__show','0',0),
	(24005,1048,'comment_message__show','0',0),
	(24006,1048,'last_comment__show','0',0),
	(24007,1048,'attachment_filename__show','1',0),
	(24008,1048,'last_attachment__show','0',0),
	(24009,1048,'_limit','-1',0),
	(24010,1048,'_order_column','uid',0),
	(24011,1048,'_order_direction','ASC',0),
	(24012,1048,'last_attachment','_minus_1_days_',0),
	(24013,1048,'last_attachment__comp_type','1',0),
	(24014,1049,'advanced_filter','1',0),
	(24015,1049,'id__show','0',0),
	(24016,1049,'awareness_program_id__show','1',0),
	(24017,1049,'uid__show','1',0),
	(24018,1049,'Awareness Program Status__show','0',0),
	(24019,1049,'reminder__show','0',0),
	(24020,1049,'created__show','0',0),
	(24021,1049,'comment_message__show','0',0),
	(24022,1049,'last_comment__show','0',0),
	(24023,1049,'attachment_filename__show','0',0),
	(24024,1049,'last_attachment__show','0',0),
	(24025,1049,'_limit','-1',0),
	(24026,1049,'_order_column','uid',0),
	(24027,1049,'_order_direction','ASC',0),
	(24028,1049,'created','_minus_1_days_',0),
	(24029,1049,'created__comp_type','1',0),
	(24030,1050,'advanced_filter','1',0),
	(24031,1050,'awareness_program_id__show','1',0),
	(24032,1050,'uid__show','1',0),
	(24033,1050,'reminder__show','1',0),
	(24034,1050,'_limit','-1',0),
	(24035,1050,'_order_column','created',0),
	(24036,1050,'_order_direction','DESC',0),
	(24037,1050,'AwarenessProgram-status','started',0),
	(24038,1050,'AwarenessProgram-status__comp_type','5',0),
	(24039,1051,'advanced_filter','1',0),
	(24040,1051,'awareness_program_id__show','1',0),
	(24041,1051,'uid__show','1',0),
	(24042,1051,'reminder__show','1',0),
	(24043,1051,'_limit','-1',0),
	(24044,1051,'_order_column','uid',0),
	(24045,1051,'_order_direction','ASC',0),
	(24046,1051,'modified','_minus_7_days_',0),
	(24047,1051,'modified__comp_type','1',0),
	(24048,1052,'advanced_filter','1',0),
	(24049,1052,'awareness_program_id__show','1',0),
	(24050,1052,'uid__show','1',0),
	(24051,1052,'reminder__show','1',0),
	(24052,1052,'_limit','-1',0),
	(24053,1052,'_order_column','uid',0),
	(24054,1052,'_order_direction','ASC',0),
	(24055,1052,'created','_minus_7_days_',0),
	(24056,1052,'created__comp_type','1',0),
	(24057,1053,'advanced_filter','1',0),
	(24058,1053,'id__show','0',0),
	(24059,1053,'awareness_program_id__show','1',0),
	(24060,1053,'uid__show','1',0),
	(24061,1053,'demo__show','0',0),
	(24062,1053,'reminder_type__show','0',0),
	(24063,1053,'created__show','0',0),
	(24064,1053,'Awareness Program Status__show','0',0),
	(24065,1053,'_limit','-1',0),
	(24066,1053,'_order_column','uid',0),
	(24067,1053,'_order_direction','ASC',0),
	(24068,1053,'last_comment','_minus_1_days_',0),
	(24069,1053,'last_comment__comp_type','1',0),
	(24070,1054,'advanced_filter','1',0),
	(24071,1054,'id__show','0',0),
	(24072,1054,'awareness_program_id__show','1',0),
	(24073,1054,'uid__show','1',0),
	(24074,1054,'demo__show','0',0),
	(24075,1054,'reminder_type__show','0',0),
	(24076,1054,'created__show','0',0),
	(24077,1054,'Awareness Program Status__show','0',0),
	(24078,1054,'_limit','-1',0),
	(24079,1054,'_order_column','uid',0),
	(24080,1054,'_order_direction','ASC',0),
	(24081,1054,'last_attachment','_minus_1_days_',0),
	(24082,1054,'last_attachment__comp_type','1',0),
	(24083,1055,'advanced_filter','1',0),
	(24084,1055,'id__show','0',0),
	(24085,1055,'awareness_program_id__show','1',0),
	(24086,1055,'uid__show','1',0),
	(24087,1055,'demo__show','0',0),
	(24088,1055,'reminder_type__show','0',0),
	(24089,1055,'created__show','0',0),
	(24090,1055,'Awareness Program Status__show','0',0),
	(24091,1055,'_limit','-1',0),
	(24092,1055,'_order_column','uid',0),
	(24093,1055,'_order_direction','ASC',0),
	(24094,1055,'created','_minus_1_days_',0),
	(24095,1055,'created__comp_type','1',0),
	(24096,1056,'advanced_filter','1',0),
	(24097,1056,'awareness_program_id__show','1',0),
	(24098,1056,'uid__show','1',0),
	(24099,1056,'demo__show','1',0),
	(24100,1056,'reminder_type__show','1',0),
	(24101,1056,'created__show','1',0),
	(24102,1056,'_limit','-1',0),
	(24103,1056,'_order_column','created',0),
	(24104,1056,'_order_direction','DESC',0),
	(24105,1056,'AwarenessProgram-status','started',0),
	(24106,1056,'AwarenessProgram-status__comp_type','5',0),
	(24107,1057,'advanced_filter','1',0),
	(24108,1057,'awareness_program_id__show','1',0),
	(24109,1057,'uid__show','1',0),
	(24110,1057,'demo__show','1',0),
	(24111,1057,'reminder_type__show','1',0),
	(24112,1057,'created__show','1',0),
	(24113,1057,'_limit','-1',0),
	(24114,1057,'_order_column','uid',0),
	(24115,1057,'_order_direction','ASC',0),
	(24116,1057,'modified','_minus_7_days_',0),
	(24117,1057,'modified__comp_type','1',0),
	(24118,1058,'advanced_filter','1',0),
	(24119,1058,'awareness_program_id__show','1',0),
	(24120,1058,'uid__show','1',0),
	(24121,1058,'demo__show','1',0),
	(24122,1058,'reminder_type__show','1',0),
	(24123,1058,'created__show','1',0),
	(24124,1058,'_limit','-1',0),
	(24125,1058,'_order_column','uid',0),
	(24126,1058,'_order_direction','ASC',0),
	(24127,1058,'created','_minus_7_days_',0),
	(24128,1058,'created__comp_type','1',0),
	(24129,1059,'advanced_filter','1',0),
	(24130,1059,'action__show','1',0),
	(24131,1059,'foreign_key__show','1',0),
	(24132,1059,'message__show','1',0),
	(24133,1059,'created__show','1',0),
	(24134,1059,'_limit','-1',0),
	(24135,1059,'_order_column','id',0),
	(24136,1059,'_order_direction','DESC',0),
	(24137,1060,'advanced_filter','1',0),
	(24138,1060,'id__show','0',0),
	(24139,1060,'name__show','1',0),
	(24140,1060,'type__show','0',0),
	(24141,1060,'status__show','0',0),
	(24142,1060,'_limit','-1',0),
	(24143,1060,'_order_column','name',0),
	(24144,1060,'_order_direction','ASC',0),
	(24145,1060,'last_comment','_minus_1_days_',0),
	(24146,1060,'last_comment__comp_type','1',0),
	(24147,1061,'advanced_filter','1',0),
	(24148,1061,'id__show','0',0),
	(24149,1061,'name__show','1',0),
	(24150,1061,'type__show','0',0),
	(24151,1061,'status__show','0',0),
	(24152,1061,'_limit','-1',0),
	(24153,1061,'_order_column','name',0),
	(24154,1061,'_order_direction','ASC',0),
	(24155,1061,'last_attachment','_minus_1_days_',0),
	(24156,1061,'last_attachment__comp_type','1',0),
	(24157,1062,'advanced_filter','1',0),
	(24158,1062,'id__show','0',0),
	(24159,1062,'name__show','1',0),
	(24160,1062,'type__show','0',0),
	(24161,1062,'status__show','0',0),
	(24162,1062,'_limit','-1',0),
	(24163,1062,'_order_column','name',0),
	(24164,1062,'_order_direction','ASC',0),
	(24165,1062,'modified','_minus_1_days_',0),
	(24166,1062,'modified__comp_type','1',0),
	(24167,1063,'advanced_filter','1',0),
	(24168,1063,'id__show','0',0),
	(24169,1063,'name__show','1',0),
	(24170,1063,'type__show','0',0),
	(24171,1063,'status__show','0',0),
	(24172,1063,'_limit','-1',0),
	(24173,1063,'_order_column','name',0),
	(24174,1063,'_order_direction','ASC',0),
	(24175,1063,'created','_minus_1_days_',0),
	(24176,1063,'created__comp_type','1',0),
	(24177,1064,'advanced_filter','1',0),
	(24178,1064,'name__show','1',0),
	(24179,1064,'type__show','1',0),
	(24180,1064,'status__show','1',0),
	(24181,1064,'_limit','-1',0),
	(24182,1064,'_order_column','created',0),
	(24183,1064,'_order_direction','DESC',0),
	(24184,1065,'advanced_filter','1',0),
	(24185,1065,'id__show','0',0),
	(24186,1065,'name__show','1',0),
	(24187,1065,'status__show','0',0),
	(24188,1065,'created__show','0',0),
	(24189,1065,'comment_message__show','1',0),
	(24190,1065,'last_comment__show','0',0),
	(24191,1065,'attachment_filename__show','0',0),
	(24192,1065,'last_attachment__show','0',0),
	(24193,1065,'_limit','-1',0),
	(24194,1065,'_order_column','name',0),
	(24195,1065,'_order_direction','ASC',0),
	(24196,1065,'last_comment','_minus_1_days_',0),
	(24197,1065,'last_comment__comp_type','1',0),
	(24198,1066,'advanced_filter','1',0),
	(24199,1066,'id__show','0',0),
	(24200,1066,'name__show','1',0),
	(24201,1066,'status__show','0',0),
	(24202,1066,'created__show','0',0),
	(24203,1066,'comment_message__show','0',0),
	(24204,1066,'last_comment__show','0',0),
	(24205,1066,'attachment_filename__show','1',0),
	(24206,1066,'last_attachment__show','0',0),
	(24207,1066,'_limit','-1',0),
	(24208,1066,'_order_column','name',0),
	(24209,1066,'_order_direction','ASC',0),
	(24210,1066,'last_attachment','_minus_1_days_',0),
	(24211,1066,'last_attachment__comp_type','1',0),
	(24212,1067,'advanced_filter','1',0),
	(24213,1067,'id__show','0',0),
	(24214,1067,'name__show','1',0),
	(24215,1067,'status__show','0',0),
	(24216,1067,'created__show','0',0),
	(24217,1067,'comment_message__show','0',0),
	(24218,1067,'last_comment__show','0',0),
	(24219,1067,'attachment_filename__show','0',0),
	(24220,1067,'last_attachment__show','0',0),
	(24221,1067,'_limit','-1',0),
	(24222,1067,'_order_column','name',0),
	(24223,1067,'_order_direction','ASC',0),
	(24224,1067,'modified','_minus_1_days_',0),
	(24225,1067,'modified__comp_type','1',0),
	(24226,1068,'advanced_filter','1',0),
	(24227,1068,'id__show','0',0),
	(24228,1068,'name__show','1',0),
	(24229,1068,'status__show','0',0),
	(24230,1068,'created__show','0',0),
	(24231,1068,'comment_message__show','0',0),
	(24232,1068,'last_comment__show','0',0),
	(24233,1068,'attachment_filename__show','0',0),
	(24234,1068,'last_attachment__show','0',0),
	(24235,1068,'_limit','-1',0),
	(24236,1068,'_order_column','name',0),
	(24237,1068,'_order_direction','ASC',0),
	(24238,1068,'created','_minus_1_days_',0),
	(24239,1068,'created__comp_type','1',0),
	(24240,1069,'advanced_filter','1',0),
	(24241,1069,'name__show','1',0),
	(24242,1069,'status__show','1',0),
	(24243,1069,'_limit','-1',0),
	(24244,1069,'_order_column','created',0),
	(24245,1069,'_order_direction','DESC',0);
ALTER TABLE `advanced_filter_values` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `app_notification_params` WRITE;
ALTER TABLE `app_notification_params` DISABLE KEYS;
ALTER TABLE `app_notification_params` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `app_notification_views` WRITE;
ALTER TABLE `app_notification_views` DISABLE KEYS;
ALTER TABLE `app_notification_views` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `app_notifications` WRITE;
ALTER TABLE `app_notifications` DISABLE KEYS;
ALTER TABLE `app_notifications` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `aros` WRITE;
ALTER TABLE `aros` DISABLE KEYS;
INSERT INTO `aros` (`id`, `parent_id`, `model`, `foreign_key`, `alias`, `lft`, `rght`) VALUES 
	(1,NULL,'Group',10,NULL,1,20),
	(2,11,'User',1,NULL,2,5),
	(3,NULL,'Group',11,NULL,21,24),
	(4,NULL,'Group',12,NULL,25,28),
	(5,NULL,'Group',13,NULL,29,32),
	(6,2,'CustomRolesUser',1,NULL,3,4),
	(7,1,'CustomRolesGroup',1,NULL,18,19),
	(8,3,'CustomRolesGroup',2,NULL,22,23),
	(9,4,'CustomRolesGroup',3,NULL,26,27),
	(10,5,'CustomRolesGroup',4,NULL,30,31),
	(11,NULL,'Group',14,NULL,33,36),
	(12,11,'CustomRolesGroup',5,NULL,34,35),
	(13,NULL,'Group',15,NULL,37,40),
	(14,13,'CustomRolesGroup',6,NULL,38,39),
	(15,NULL,'Group',16,NULL,41,44),
	(16,15,'CustomRolesGroup',7,NULL,42,43),
	(17,NULL,'Group',17,NULL,45,48),
	(18,17,'CustomRolesGroup',8,NULL,46,47),
	(19,NULL,'Group',18,NULL,49,52),
	(20,19,'CustomRolesGroup',9,NULL,50,51),
	(21,NULL,'Group',19,NULL,53,56),
	(22,21,'CustomRolesGroup',10,NULL,54,55);
ALTER TABLE `aros` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `aros_acos` WRITE;
ALTER TABLE `aros_acos` DISABLE KEYS;
INSERT INTO `aros_acos` (`id`, `aro_id`, `aco_id`, `_create`, `_read`, `_update`, `_delete`) VALUES 
	(1,1,1,'1','1','1','1'),
	(7,3,3,'1','1','1','1'),
	(9,5,1,'1','1','1','1'),
	(11,5,469,'-1','-1','-1','-1'),
	(12,5,470,'-1','-1','-1','-1'),
	(13,5,466,'-1','-1','-1','-1'),
	(14,5,464,'-1','-1','-1','-1'),
	(15,5,463,'-1','-1','-1','-1'),
	(17,5,465,'-1','-1','-1','-1'),
	(18,5,468,'-1','-1','-1','-1'),
	(19,5,471,'-1','-1','-1','-1'),
	(20,5,472,'-1','-1','-1','-1'),
	(21,5,467,'-1','-1','-1','-1'),
	(29,4,696,'1','1','1','1'),
	(30,3,696,'1','1','1','1'),
	(31,4,514,'1','1','1','1'),
	(32,3,514,'1','1','1','1'),
	(33,3,512,'1','1','1','1'),
	(34,4,512,'1','1','1','1'),
	(35,4,513,'1','1','1','1'),
	(36,3,513,'1','1','1','1'),
	(37,4,515,'1','1','1','1'),
	(38,3,515,'1','1','1','1'),
	(41,5,2021,'-1','-1','-1','-1'),
	(42,5,2022,'-1','-1','-1','-1'),
	(43,5,1553,'-1','-1','-1','-1'),
	(44,5,237,'-1','-1','-1','-1'),
	(45,5,238,'-1','-1','-1','-1'),
	(46,5,239,'-1','-1','-1','-1'),
	(47,5,240,'-1','-1','-1','-1'),
	(49,5,242,'-1','-1','-1','-1'),
	(50,5,507,'-1','-1','-1','-1'),
	(51,5,510,'-1','-1','-1','-1'),
	(52,5,508,'-1','-1','-1','-1'),
	(53,5,509,'-1','-1','-1','-1'),
	(54,5,225,'-1','-1','-1','-1'),
	(55,5,228,'-1','-1','-1','-1'),
	(56,5,226,'-1','-1','-1','-1'),
	(57,5,227,'-1','-1','-1','-1'),
	(58,5,1967,'-1','-1','-1','-1'),
	(59,1,2104,'1','1','1','1'),
	(60,3,2105,'1','0','0','0'),
	(61,4,2105,'1','0','0','0'),
	(62,5,2105,'1','0','0','0'),
	(63,5,2328,'-1','-1','-1','-1'),
	(64,3,2513,'-1','-1','-1','-1'),
	(65,4,2513,'-1','-1','-1','-1'),
	(66,5,2513,'-1','-1','-1','-1'),
	(67,11,2105,'1','0','0','0'),
	(68,11,408,'1','1','1','1'),
	(69,11,419,'1','1','1','1'),
	(70,13,2105,'1','0','0','0'),
	(72,15,2105,'1','0','0','0'),
	(73,15,429,'1','1','1','1'),
	(74,15,434,'1','1','1','1'),
	(75,15,439,'1','1','1','1'),
	(76,15,2455,'1','1','1','1'),
	(77,17,2105,'1','0','0','0'),
	(78,17,76,'1','1','1','1'),
	(79,17,360,'1','1','1','1'),
	(80,17,492,'1','1','1','1'),
	(81,17,2227,'1','1','1','1'),
	(82,17,2400,'1','1','1','1'),
	(83,17,2490,'1','1','1','1'),
	(84,19,2105,'1','0','0','0'),
	(85,19,312,'1','1','1','1'),
	(86,19,324,'1','1','1','1'),
	(87,2,2906,'1','1','1','1'),
	(88,21,2105,'1','0','0','0'),
	(89,21,463,'1','1','1','1'),
	(90,21,508,'1','1','1','1'),
	(91,21,2516,'1','1','1','1'),
	(92,21,510,'1','1','1','1'),
	(93,21,2517,'1','1','1','1'),
	(94,21,509,'1','1','1','1'),
	(95,21,507,'1','1','1','1'),
	(96,21,1484,'1','1','1','1'),
	(97,21,1042,'1','1','1','1'),
	(98,21,1565,'1','1','1','1'),
	(99,21,1566,'1','1','1','1'),
	(100,21,2653,'1','1','1','1'),
	(101,21,2584,'1','1','1','1'),
	(102,21,2867,'1','1','1','1'),
	(103,21,2586,'1','1','1','1'),
	(104,21,2587,'1','1','1','1'),
	(105,21,2580,'1','1','1','1'),
	(106,21,2577,'1','1','1','1'),
	(107,21,2578,'1','1','1','1'),
	(108,21,2576,'1','1','1','1'),
	(109,21,2573,'1','1','1','1'),
	(110,21,2840,'1','1','1','1'),
	(111,21,2609,'1','1','1','1'),
	(112,21,2610,'1','1','1','1'),
	(113,21,2608,'1','1','1','1'),
	(114,21,2595,'1','1','1','1'),
	(115,21,2596,'1','1','1','1'),
	(116,21,2597,'1','1','1','1'),
	(117,21,2593,'1','1','1','1'),
	(118,21,2594,'1','1','1','1'),
	(119,5,1143,'-1','-1','-1','-1'),
	(120,5,2834,'-1','-1','-1','-1'),
	(121,5,2340,'-1','-1','-1','-1'),
	(122,5,2341,'-1','-1','-1','-1'),
	(123,5,2342,'-1','-1','-1','-1'),
	(124,5,2339,'-1','-1','-1','-1'),
	(125,5,2602,'-1','-1','-1','-1'),
	(126,5,2049,'-1','-1','-1','-1'),
	(127,5,2048,'-1','-1','-1','-1'),
	(128,5,2601,'-1','-1','-1','-1'),
	(129,5,2916,'-1','-1','-1','-1'),
	(130,5,2917,'-1','-1','-1','-1'),
	(131,5,2918,'-1','-1','-1','-1'),
	(132,5,2919,'-1','-1','-1','-1'),
	(133,5,2920,'-1','-1','-1','-1'),
	(134,5,2921,'-1','-1','-1','-1'),
	(135,5,2886,'-1','-1','-1','-1'),
	(136,5,2888,'-1','-1','-1','-1'),
	(137,5,2890,'-1','-1','-1','-1'),
	(138,5,2891,'-1','-1','-1','-1'),
	(139,5,2889,'-1','-1','-1','-1'),
	(140,5,2887,'-1','-1','-1','-1'),
	(141,5,2885,'-1','-1','-1','-1'),
	(142,5,2922,'-1','-1','-1','-1'),
	(143,5,2923,'-1','-1','-1','-1'),
	(144,5,2924,'-1','-1','-1','-1'),
	(145,5,2925,'-1','-1','-1','-1'),
	(146,5,2926,'-1','-1','-1','-1'),
	(147,5,2909,'-1','-1','-1','-1'),
	(148,5,2911,'-1','-1','-1','-1'),
	(149,5,2915,'-1','-1','-1','-1'),
	(150,5,2910,'-1','-1','-1','-1'),
	(151,5,2912,'-1','-1','-1','-1'),
	(152,5,2908,'-1','-1','-1','-1'),
	(153,5,2914,'-1','-1','-1','-1'),
	(154,5,2913,'-1','-1','-1','-1'),
	(155,5,2619,'-1','-1','-1','-1'),
	(156,5,1476,'-1','-1','-1','-1'),
	(157,5,2875,'-1','-1','-1','-1'),
	(158,5,2874,'-1','-1','-1','-1'),
	(159,5,2877,'-1','-1','-1','-1'),
	(160,5,2879,'-1','-1','-1','-1'),
	(161,5,2882,'-1','-1','-1','-1'),
	(162,5,2878,'-1','-1','-1','-1'),
	(163,5,2880,'-1','-1','-1','-1'),
	(164,5,2881,'-1','-1','-1','-1'),
	(165,21,2937,'1','1','1','1');
ALTER TABLE `aros_acos` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `asset_classification_types` WRITE;
ALTER TABLE `asset_classification_types` DISABLE KEYS;
ALTER TABLE `asset_classification_types` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `asset_classifications` WRITE;
ALTER TABLE `asset_classifications` DISABLE KEYS;
ALTER TABLE `asset_classifications` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `asset_classifications_assets` WRITE;
ALTER TABLE `asset_classifications_assets` DISABLE KEYS;
ALTER TABLE `asset_classifications_assets` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `asset_labels` WRITE;
ALTER TABLE `asset_labels` DISABLE KEYS;
ALTER TABLE `asset_labels` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `asset_media_types` WRITE;
ALTER TABLE `asset_media_types` DISABLE KEYS;
INSERT INTO `asset_media_types` (`id`, `name`, `editable`, `created`, `modified`) VALUES 
	(1,'Data Asset',0,NULL,NULL),
	(2,'Facilities',0,NULL,NULL),
	(3,'People',0,NULL,NULL),
	(4,'Hardware',0,NULL,NULL),
	(5,'Software',0,NULL,NULL),
	(6,'IT Service',0,NULL,NULL),
	(7,'Network',0,NULL,NULL),
	(8,'Financial',0,NULL,NULL);
ALTER TABLE `asset_media_types` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `asset_media_types_threats` WRITE;
ALTER TABLE `asset_media_types_threats` DISABLE KEYS;
INSERT INTO `asset_media_types_threats` (`id`, `asset_media_type_id`, `threat_id`) VALUES 
	(1,1,6),
	(2,1,7),
	(3,1,10),
	(4,1,16),
	(5,1,27),
	(6,2,2),
	(7,2,3),
	(8,2,18),
	(9,2,19),
	(10,2,20),
	(12,2,30),
	(13,2,31),
	(14,2,32),
	(15,3,1),
	(16,3,2),
	(17,3,3),
	(18,3,4),
	(19,3,5),
	(20,3,6),
	(21,3,7),
	(22,3,13),
	(23,3,14),
	(24,3,15),
	(25,3,16),
	(26,3,17),
	(27,3,21),
	(28,3,26),
	(29,3,27),
	(30,3,30),
	(31,3,32),
	(32,3,33),
	(33,3,34),
	(34,3,35),
	(35,4,4),
	(36,4,5),
	(37,4,14),
	(38,4,15),
	(39,5,8),
	(40,5,9),
	(41,5,10),
	(42,5,14),
	(43,5,15),
	(44,5,21),
	(45,5,22),
	(46,5,23),
	(47,5,33),
	(48,6,8),
	(49,6,9),
	(50,6,10),
	(51,6,13),
	(52,6,14),
	(53,6,15),
	(54,6,21),
	(55,6,22),
	(56,6,23),
	(57,6,26),
	(58,6,30),
	(59,6,33),
	(60,7,8),
	(61,7,9),
	(62,7,10),
	(63,7,11),
	(64,7,12),
	(65,7,14),
	(66,7,15),
	(67,7,21),
	(68,7,22),
	(69,7,24),
	(70,7,25),
	(71,7,26),
	(72,8,16),
	(73,8,27);
ALTER TABLE `asset_media_types_threats` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `asset_media_types_vulnerabilities` WRITE;
ALTER TABLE `asset_media_types_vulnerabilities` DISABLE KEYS;
INSERT INTO `asset_media_types_vulnerabilities` (`id`, `asset_media_type_id`, `vulnerability_id`) VALUES 
	(1,1,2),
	(2,1,3),
	(3,3,1),
	(4,3,3),
	(5,5,2),
	(6,5,3),
	(7,6,2),
	(8,6,3),
	(9,7,3),
	(10,8,3),
	(11,8,2);
ALTER TABLE `asset_media_types_vulnerabilities` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `assets` WRITE;
ALTER TABLE `assets` DISABLE KEYS;
ALTER TABLE `assets` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `assets_business_units` WRITE;
ALTER TABLE `assets_business_units` DISABLE KEYS;
ALTER TABLE `assets_business_units` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `assets_compliance_managements` WRITE;
ALTER TABLE `assets_compliance_managements` DISABLE KEYS;
ALTER TABLE `assets_compliance_managements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `assets_legals` WRITE;
ALTER TABLE `assets_legals` DISABLE KEYS;
ALTER TABLE `assets_legals` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `assets_policy_exceptions` WRITE;
ALTER TABLE `assets_policy_exceptions` DISABLE KEYS;
ALTER TABLE `assets_policy_exceptions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `assets_related` WRITE;
ALTER TABLE `assets_related` DISABLE KEYS;
ALTER TABLE `assets_related` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `assets_risks` WRITE;
ALTER TABLE `assets_risks` DISABLE KEYS;
ALTER TABLE `assets_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `assets_security_incidents` WRITE;
ALTER TABLE `assets_security_incidents` DISABLE KEYS;
ALTER TABLE `assets_security_incidents` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `assets_third_party_risks` WRITE;
ALTER TABLE `assets_third_party_risks` DISABLE KEYS;
ALTER TABLE `assets_third_party_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `attachments` WRITE;
ALTER TABLE `attachments` DISABLE KEYS;
ALTER TABLE `attachments` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `audits` WRITE;
ALTER TABLE `audits` DISABLE KEYS;
INSERT INTO `audits` (`id`, `version`, `event`, `model`, `entity_id`, `request_id`, `json_object`, `description`, `source_id`, `restore_id`, `created`) VALUES 
	('5ce3f0aa-2990-4e1f-97db-96a700000000',1,'CREATE','Threat','3','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"3","name":"Strikes"}}',NULL,NULL,NULL,'2019-05-21 12:35:54'),
	('5ce3f0aa-5628-4506-a0ea-96a700000000',1,'CREATE','Threat','4','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"4","name":"Unintentional Loss of Equipment"}}',NULL,NULL,NULL,'2019-05-21 12:35:54'),
	('5ce3f0aa-5fb8-4418-895d-96a700000000',1,'CREATE','Threat','7','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"7","name":"Intentional Theft of Information"}}',NULL,NULL,NULL,'2019-05-21 12:35:54'),
	('5ce3f0aa-8eac-4b14-8301-96a700000000',1,'CREATE','Threat','2','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"2","name":"Pandemic Issues"}}',NULL,NULL,NULL,'2019-05-21 12:35:54'),
	('5ce3f0aa-9430-47b8-a0c7-96a700000000',1,'CREATE','Threat','5','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"5","name":"Intentional Theft of Equipment"}}',NULL,NULL,NULL,'2019-05-21 12:35:54'),
	('5ce3f0aa-a2e8-45f8-8537-96a700000000',1,'CREATE','Threat','1','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"1","name":"Intentional Complot"}}',NULL,NULL,NULL,'2019-05-21 12:35:54'),
	('5ce3f0aa-ab50-408a-9f4b-96a700000000',1,'CREATE','Threat','8','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"8","name":"Remote Exploit"}}',NULL,NULL,NULL,'2019-05-21 12:35:54'),
	('5ce3f0aa-d5b4-49a6-a14e-96a700000000',1,'CREATE','Threat','9','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"9","name":"Abuse of Service"}}',NULL,NULL,NULL,'2019-05-21 12:35:54'),
	('5ce3f0aa-e6d0-42d1-bc34-96a700000000',1,'CREATE','Threat','6','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"6","name":"Unintentional Loss of Information"}}',NULL,NULL,NULL,'2019-05-21 12:35:54'),
	('5ce3f0ab-01cc-4973-b93c-96a700000000',1,'CREATE','Vulnerability','23','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"23","name":"Weak Passwords"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-0474-4f2f-87a6-96a700000000',1,'CREATE','Vulnerability','28','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"28","name":"Seismic Areas"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-08f8-4305-a3e7-96a700000000',1,'CREATE','Threat','32','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"32","name":"Third Party Intrusion"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-0af4-44e5-95d2-96a700000000',1,'CREATE','Threat','11','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"11","name":"Network Attack"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-0c48-4ef1-a326-96a700000000',1,'CREATE','Threat','17','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"17","name":"Social Engineering"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-1050-4af5-a898-96a700000000',1,'CREATE','Vulnerability','12','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"12","name":"Lack of Movement Sensors"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-178c-4fbc-9721-96a700000000',1,'CREATE','Threat','25','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"25","name":"Tunneling"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-1b9c-43d8-bf7d-96a700000000',1,'CREATE','Vulnerability','16','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"16","name":"Lack of Encryption in Motion"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-28b4-43e2-827a-96a700000000',1,'CREATE','Threat','24','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"24","name":"Tampering"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-2944-46a7-ae2e-96a700000000',1,'CREATE','Threat','30','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"30","name":"Terrorist Attack"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-3e44-49a6-ac3e-96a700000000',1,'CREATE','Vulnerability','34','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"34","name":"Weak Software Development Procedures"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-4048-4439-a619-96a700000000',1,'CREATE','Threat','12','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"12","name":"Sniffing"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-4194-442b-b10d-96a700000000',1,'CREATE','Threat','14','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"14","name":"Malware\\/Trojan Distribution"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-4308-43d1-9625-96a700000000',1,'CREATE','Threat','10','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"10","name":"Web Application Attack"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-4618-4c6f-9c48-96a700000000',1,'CREATE','Threat','21','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"21","name":"Ilegal Infiltration"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-495c-4a5a-a436-96a700000000',1,'CREATE','Threat','26','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"26","name":"Man in the Middle"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-4aec-446a-a999-96a700000000',1,'CREATE','Threat','31','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"31","name":"Floodings"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-5414-40a4-a97a-96a700000000',1,'CREATE','Vulnerability','5','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"5","name":"Weak CheckOut Procedures"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-544c-46cd-b919-96a700000000',1,'CREATE','Vulnerability','31','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"31","name":"Other"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-5490-4b28-a7c2-96a700000000',1,'CREATE','Vulnerability','7','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"7","name":"Lack of alternative Power Sources"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-5c24-4dc0-8735-96a700000000',1,'CREATE','Vulnerability','1','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"1","name":"Lack of Information"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-5cdc-49b8-a01c-96a700000000',1,'CREATE','Vulnerability','9','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"9","name":"Lack of Patching"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-5df0-4054-83ca-96a700000000',1,'CREATE','Threat','28','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"28","name":"Other"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-6194-4efc-ab3a-96a700000000',1,'CREATE','Threat','35','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"35","name":"Spying"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-6884-41c2-a512-96a700000000',1,'CREATE','Vulnerability','8','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"8","name":"Lack of Physical Guards"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-69ac-4e87-bfa2-96a700000000',1,'CREATE','Vulnerability','32','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"32","name":"Unprotected Network"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-74f4-47f3-909f-96a700000000',1,'CREATE','Threat','15','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"15","name":"Viruses"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-7528-4c25-bbba-96a700000000',1,'CREATE','Vulnerability','3','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"3","name":"Lack of Logs"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-7788-4ada-bb41-96a700000000',1,'CREATE','Vulnerability','14','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"14","name":"Lack of Network Controls"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-7934-4326-a536-96a700000000',1,'CREATE','Vulnerability','25','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"25","name":"Missing Configuration Standards"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-846c-4aa6-b793-96a700000000',1,'CREATE','Vulnerability','18','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"18","name":"Creeping Accounts"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-8810-479d-b416-96a700000000',1,'CREATE','Vulnerability','11','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"11","name":"Lack of CCTV"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-8a7c-411a-9c5e-96a700000000',1,'CREATE','Threat','22','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"22","name":"DOS Attack"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-8c98-4386-960d-96a700000000',1,'CREATE','Vulnerability','21','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"21","name":"Lack of Fire Extinguishers"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-8e18-4cfa-8129-96a700000000',1,'CREATE','Threat','19','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"19","name":"Fire"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-8e64-4dea-a30e-96a700000000',1,'CREATE','Vulnerability','15','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"15","name":"Lack of Strong Authentication"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-9234-46c5-9af6-96a700000000',1,'CREATE','Vulnerability','13','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"13","name":"Lack of Procedures"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-9618-438a-9d5d-96a700000000',1,'CREATE','Vulnerability','19','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"19","name":"Hardware Malfunction"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-99c4-400f-b9de-96a700000000',1,'CREATE','Vulnerability','30','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"30","name":"Flood Prone Areas"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-9be0-4b68-b0dd-96a700000000',1,'CREATE','Vulnerability','33','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"33","name":"Cabling Unsecured"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-9e40-4258-a39b-96a700000000',1,'CREATE','Vulnerability','24','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"24","name":"Weak Awareness"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-a6ac-4836-8376-96a700000000',1,'CREATE','Threat','23','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"23","name":"Brute Force Attack"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-a774-473f-be86-96a700000000',1,'CREATE','Vulnerability','6','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"6","name":"Supplier Failure"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-a780-4c3c-944e-96a700000000',1,'CREATE','Vulnerability','26','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"26","name":"Open Network Ports"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-a9b8-425f-96cf-96a700000000',1,'CREATE','Threat','33','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"33","name":"Abuse of Priviledge"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-ace8-43e4-9087-96a700000000',1,'CREATE','Threat','34','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"34","name":"Unauthorised records"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-b0bc-43f8-95b4-96a700000000',1,'CREATE','Vulnerability','22','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"22","name":"Lack of alternative exit doors"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-b234-42c4-952e-96a700000000',1,'CREATE','Vulnerability','17','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"17","name":"Lack of Encryption at Rest"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-ba74-4f24-b133-96a700000000',1,'CREATE','Threat','27','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"27","name":"Fraud"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-c0a8-4df5-b635-96a700000000',1,'CREATE','Vulnerability','29','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"29","name":"Prone to Natural Disasters Area"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-c284-4140-8703-96a700000000',1,'CREATE','Vulnerability','27','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"27","name":"Reputational Issues"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-c800-4524-aa29-96a700000000',1,'CREATE','Threat','16','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"16","name":"Copyright Infrigment"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-d400-4eeb-8859-96a700000000',1,'CREATE','Threat','13','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"13","name":"Phishing"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-d6c0-480d-9f6d-96a700000000',1,'CREATE','Vulnerability','20','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"20","name":"Software Malfunction"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-ef04-4374-81d8-96a700000000',1,'CREATE','Vulnerability','10','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"10","name":"Web Application Vulnerabilities"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-f600-46e4-bd85-96a700000000',1,'CREATE','Vulnerability','2','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"2","name":"Lack of Integrity Checks"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-fb04-49b8-b74d-96a700000000',1,'CREATE','Threat','18','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"18","name":"Natural Disasters"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-fc10-4e99-88d7-96a700000000',1,'CREATE','Threat','20','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Threat":{"id":"20","name":"Flooding"}}',NULL,NULL,NULL,'2019-05-21 12:35:55'),
	('5ce3f0ab-fc20-4451-96c6-96a700000000',1,'CREATE','Vulnerability','4','5ce3f0aa-770c-445c-ad5d-96a700000000','{"Vulnerability":{"id":"4","name":"No Change Management"}}',NULL,NULL,NULL,'2019-05-21 12:35:55');
ALTER TABLE `audits` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `audit_deltas` WRITE;
ALTER TABLE `audit_deltas` DISABLE KEYS;
INSERT INTO `audit_deltas` (`id`, `audit_id`, `property_name`, `old_value`, `new_value`) VALUES 
	('5ce3f0aa-00f0-4e1a-bcd4-96a700000000','5ce3f0aa-9430-47b8-a0c7-96a700000000','name','','Intentional Theft of Equipment'),
	('5ce3f0aa-0104-47da-8c06-96a700000000','5ce3f0aa-ab50-408a-9f4b-96a700000000','name','','Remote Exploit'),
	('5ce3f0aa-0274-40fd-a39f-96a700000000','5ce3f0aa-8eac-4b14-8301-96a700000000','name','','Pandemic Issues'),
	('5ce3f0aa-02f8-449f-94f0-96a700000000','5ce3f0aa-2990-4e1f-97db-96a700000000','id','','3'),
	('5ce3f0aa-0a84-4204-a488-96a700000000','5ce3f0aa-a2e8-45f8-8537-96a700000000','id','','1'),
	('5ce3f0aa-48b4-4825-bd1b-96a700000000','5ce3f0aa-a2e8-45f8-8537-96a700000000','name','','Intentional Complot'),
	('5ce3f0aa-613c-45fb-b900-96a700000000','5ce3f0aa-e6d0-42d1-bc34-96a700000000','name','','Unintentional Loss of Information'),
	('5ce3f0aa-6d14-4d1d-b6c1-96a700000000','5ce3f0aa-5fb8-4418-895d-96a700000000','id','','7'),
	('5ce3f0aa-7e18-408e-a328-96a700000000','5ce3f0aa-2990-4e1f-97db-96a700000000','name','','Strikes'),
	('5ce3f0aa-8a30-466c-bae8-96a700000000','5ce3f0aa-5628-4506-a0ea-96a700000000','id','','4'),
	('5ce3f0aa-9c78-4f84-86b5-96a700000000','5ce3f0aa-9430-47b8-a0c7-96a700000000','id','','5'),
	('5ce3f0aa-b8ac-45e5-8bee-96a700000000','5ce3f0aa-ab50-408a-9f4b-96a700000000','id','','8'),
	('5ce3f0aa-b954-4c4e-8204-96a700000000','5ce3f0aa-5fb8-4418-895d-96a700000000','name','','Intentional Theft of Information'),
	('5ce3f0aa-c5d4-4dd8-88ed-96a700000000','5ce3f0aa-8eac-4b14-8301-96a700000000','id','','2'),
	('5ce3f0aa-ddb8-463a-af4f-96a700000000','5ce3f0aa-5628-4506-a0ea-96a700000000','name','','Unintentional Loss of Equipment'),
	('5ce3f0aa-deb0-4f21-b1c7-96a700000000','5ce3f0aa-e6d0-42d1-bc34-96a700000000','id','','6'),
	('5ce3f0ab-0030-411b-aa56-96a700000000','5ce3f0ab-99c4-400f-b9de-96a700000000','id','','30'),
	('5ce3f0ab-03ec-4a51-8192-96a700000000','5ce3f0ab-c0a8-4df5-b635-96a700000000','id','','29'),
	('5ce3f0ab-03f8-481a-8a44-96a700000000','5ce3f0ab-ba74-4f24-b133-96a700000000','id','','27'),
	('5ce3f0ab-06d8-42a3-b087-96a700000000','5ce3f0ab-a9b8-425f-96cf-96a700000000','name','','Abuse of Priviledge'),
	('5ce3f0ab-07d4-477b-a178-96a700000000','5ce3f0ab-544c-46cd-b919-96a700000000','name','','Other'),
	('5ce3f0ab-0820-4655-b627-96a700000000','5ce3f0ab-8e18-4cfa-8129-96a700000000','name','','Fire'),
	('5ce3f0ab-0850-4f67-b920-96a700000000','5ce3f0ab-9618-438a-9d5d-96a700000000','name','','Hardware Malfunction'),
	('5ce3f0ab-08e8-406c-beb1-96a700000000','5ce3f0ab-01cc-4973-b93c-96a700000000','id','','23'),
	('5ce3f0ab-0938-46fe-a483-96a700000000','5ce3f0ab-f600-46e4-bd85-96a700000000','id','','2'),
	('5ce3f0ab-0a08-45a2-88e2-96a700000000','5ce3f0ab-2944-46a7-ae2e-96a700000000','name','','Terrorist Attack'),
	('5ce3f0ab-0fb4-471a-b9d7-96a700000000','5ce3f0ab-8a7c-411a-9c5e-96a700000000','name','','DOS Attack'),
	('5ce3f0ab-100c-4649-91b4-96a700000000','5ce3f0ab-4194-442b-b10d-96a700000000','id','','14'),
	('5ce3f0ab-1050-4b82-b3b7-96a700000000','5ce3f0ab-d400-4eeb-8859-96a700000000','name','','Phishing'),
	('5ce3f0ab-1194-4ee5-a2e9-96a700000000','5ce3f0ab-8810-479d-b416-96a700000000','name','','Lack of CCTV'),
	('5ce3f0ab-1404-4f9b-bb5c-96a700000000','5ce3f0ab-0af4-44e5-95d2-96a700000000','id','','11'),
	('5ce3f0ab-14b4-43ad-a9ba-96a700000000','5ce3f0ab-5414-40a4-a97a-96a700000000','id','','5'),
	('5ce3f0ab-19b4-476f-a853-96a700000000','5ce3f0ab-9be0-4b68-b0dd-96a700000000','id','','33'),
	('5ce3f0ab-1ae8-4e1b-93dd-96a700000000','5ce3f0ab-9234-46c5-9af6-96a700000000','name','','Lack of Procedures'),
	('5ce3f0ab-1b98-4544-9bce-96a700000000','5ce3f0ab-0c48-4ef1-a326-96a700000000','id','','17'),
	('5ce3f0ab-1eb4-4756-9bc9-96a700000000','5ce3f0ab-0474-4f2f-87a6-96a700000000','id','','28'),
	('5ce3f0ab-1f0c-4918-825d-96a700000000','5ce3f0ab-178c-4fbc-9721-96a700000000','id','','25'),
	('5ce3f0ab-2284-4658-b809-96a700000000','5ce3f0ab-8e64-4dea-a30e-96a700000000','id','','15'),
	('5ce3f0ab-2324-48e5-b794-96a700000000','5ce3f0ab-1050-4af5-a898-96a700000000','id','','12'),
	('5ce3f0ab-236c-409c-8b52-96a700000000','5ce3f0ab-ace8-43e4-9087-96a700000000','name','','Unauthorised records'),
	('5ce3f0ab-263c-422f-888f-96a700000000','5ce3f0ab-1b9c-43d8-bf7d-96a700000000','id','','16'),
	('5ce3f0ab-267c-4e65-a31a-96a700000000','5ce3f0ab-5df0-4054-83ca-96a700000000','name','','Other'),
	('5ce3f0ab-2760-4406-9751-96a700000000','5ce3f0ab-d6c0-480d-9f6d-96a700000000','name','','Software Malfunction'),
	('5ce3f0ab-2c9c-40c2-bdf3-96a700000000','5ce3f0ab-4618-4c6f-9c48-96a700000000','id','','21'),
	('5ce3f0ab-333c-4be7-b405-96a700000000','5ce3f0ab-9e40-4258-a39b-96a700000000','name','','Weak Awareness'),
	('5ce3f0ab-374c-42eb-91e2-96a700000000','5ce3f0ab-8e64-4dea-a30e-96a700000000','name','','Lack of Strong Authentication'),
	('5ce3f0ab-37c0-4d0e-a4e8-96a700000000','5ce3f0ab-ef04-4374-81d8-96a700000000','id','','10'),
	('5ce3f0ab-3a84-40a4-9a61-96a700000000','5ce3f0ab-4308-43d1-9625-96a700000000','id','','10'),
	('5ce3f0ab-3ac8-4da8-987d-96a700000000','5ce3f0ab-b0bc-43f8-95b4-96a700000000','name','','Lack of alternative exit doors'),
	('5ce3f0ab-3b0c-4439-b3a3-96a700000000','5ce3f0ab-3e44-49a6-ac3e-96a700000000','name','','Weak Software Development Procedures'),
	('5ce3f0ab-3d1c-46d5-a2de-96a700000000','5ce3f0ab-fb04-49b8-b74d-96a700000000','id','','18'),
	('5ce3f0ab-41d0-4172-9f6a-96a700000000','5ce3f0aa-d5b4-49a6-a14e-96a700000000','name','','Abuse of Service'),
	('5ce3f0ab-4310-4b82-b581-96a700000000','5ce3f0ab-c800-4524-aa29-96a700000000','name','','Copyright Infrigment'),
	('5ce3f0ab-446c-4234-890e-96a700000000','5ce3f0ab-28b4-43e2-827a-96a700000000','name','','Tampering'),
	('5ce3f0ab-4730-4ca4-a28f-96a700000000','5ce3f0ab-5490-4b28-a7c2-96a700000000','id','','7'),
	('5ce3f0ab-5000-4727-a387-96a700000000','5ce3f0ab-f600-46e4-bd85-96a700000000','name','','Lack of Integrity Checks'),
	('5ce3f0ab-51b4-4bfe-90b3-96a700000000','5ce3f0ab-08f8-4305-a3e7-96a700000000','id','','32'),
	('5ce3f0ab-5234-4fbe-8fcf-96a700000000','5ce3f0ab-0af4-44e5-95d2-96a700000000','name','','Network Attack'),
	('5ce3f0ab-5284-45cf-b940-96a700000000','5ce3f0ab-b234-42c4-952e-96a700000000','name','','Lack of Encryption at Rest'),
	('5ce3f0ab-5b54-47e4-8929-96a700000000','5ce3f0ab-5c24-4dc0-8735-96a700000000','id','','1'),
	('5ce3f0ab-5bc0-4656-b0e4-96a700000000','5ce3f0ab-c0a8-4df5-b635-96a700000000','name','','Prone to Natural Disasters Area'),
	('5ce3f0ab-5bcc-4f90-a480-96a700000000','5ce3f0ab-4aec-446a-a999-96a700000000','id','','31'),
	('5ce3f0ab-6124-4d17-8fd1-96a700000000','5ce3f0ab-99c4-400f-b9de-96a700000000','name','','Flood Prone Areas'),
	('5ce3f0ab-6338-42c0-adbb-96a700000000','5ce3f0ab-495c-4a5a-a436-96a700000000','id','','26'),
	('5ce3f0ab-63c0-4a77-8af0-96a700000000','5ce3f0ab-ba74-4f24-b133-96a700000000','name','','Fraud'),
	('5ce3f0ab-6414-4faf-ab90-96a700000000','5ce3f0ab-7788-4ada-bb41-96a700000000','id','','14'),
	('5ce3f0ab-65c8-42c0-b9fb-96a700000000','5ce3f0ab-ef04-4374-81d8-96a700000000','name','','Web Application Vulnerabilities'),
	('5ce3f0ab-6df4-48a2-a9dc-96a700000000','5ce3f0ab-7934-4326-a536-96a700000000','id','','25'),
	('5ce3f0ab-7358-4399-985b-96a700000000','5ce3f0ab-fc20-4451-96c6-96a700000000','id','','4'),
	('5ce3f0ab-7450-4eec-bea7-96a700000000','5ce3f0ab-4048-4439-a619-96a700000000','id','','12'),
	('5ce3f0ab-74a4-4be6-b2bb-96a700000000','5ce3f0ab-74f4-47f3-909f-96a700000000','id','','15'),
	('5ce3f0ab-75f8-4204-a652-96a700000000','5ce3f0ab-6194-4efc-ab3a-96a700000000','id','','35'),
	('5ce3f0ab-77c8-4f5a-977f-96a700000000','5ce3f0ab-c284-4140-8703-96a700000000','name','','Reputational Issues'),
	('5ce3f0ab-77e4-44be-835c-96a700000000','5ce3f0ab-69ac-4e87-bfa2-96a700000000','name','','Unprotected Network'),
	('5ce3f0ab-7a28-4782-8d31-96a700000000','5ce3f0ab-a6ac-4836-8376-96a700000000','name','','Brute Force Attack'),
	('5ce3f0ab-7a3c-4c03-ba7b-96a700000000','5ce3f0ab-5cdc-49b8-a01c-96a700000000','id','','9'),
	('5ce3f0ab-87a8-493f-a680-96a700000000','5ce3f0ab-4194-442b-b10d-96a700000000','name','','Malware/Trojan Distribution'),
	('5ce3f0ab-8924-4e4d-860e-96a700000000','5ce3f0ab-1b9c-43d8-bf7d-96a700000000','name','','Lack of Encryption in Motion'),
	('5ce3f0ab-8a68-4d3d-a547-96a700000000','5ce3f0ab-fc10-4e99-88d7-96a700000000','name','','Flooding'),
	('5ce3f0ab-8c6c-4430-8fb1-96a700000000','5ce3f0ab-0c48-4ef1-a326-96a700000000','name','','Social Engineering'),
	('5ce3f0ab-8ea0-41a3-a8a6-96a700000000','5ce3f0ab-846c-4aa6-b793-96a700000000','name','','Creeping Accounts'),
	('5ce3f0ab-8ea4-4391-ab9e-96a700000000','5ce3f0ab-1050-4af5-a898-96a700000000','name','','Lack of Movement Sensors'),
	('5ce3f0ab-8f24-40ae-acd9-96a700000000','5ce3f0ab-0474-4f2f-87a6-96a700000000','name','','Seismic Areas'),
	('5ce3f0ab-9138-4fb2-baa3-96a700000000','5ce3f0ab-6884-41c2-a512-96a700000000','id','','8'),
	('5ce3f0ab-91a4-4e21-9951-96a700000000','5ce3f0ab-2944-46a7-ae2e-96a700000000','id','','30'),
	('5ce3f0ab-92e0-413d-b475-96a700000000','5ce3f0ab-01cc-4973-b93c-96a700000000','name','','Weak Passwords'),
	('5ce3f0ab-930c-42c2-9be9-96a700000000','5ce3f0ab-5490-4b28-a7c2-96a700000000','name','','Lack of alternative Power Sources'),
	('5ce3f0ab-99e4-4ef2-97d2-96a700000000','5ce3f0ab-8e18-4cfa-8129-96a700000000','id','','19'),
	('5ce3f0ab-9b38-449e-a404-96a700000000','5ce3f0ab-8a7c-411a-9c5e-96a700000000','id','','22'),
	('5ce3f0ab-a234-47ea-8e6c-96a700000000','5ce3f0ab-4048-4439-a619-96a700000000','name','','Sniffing'),
	('5ce3f0ab-a30c-4bef-9a16-96a700000000','5ce3f0ab-4618-4c6f-9c48-96a700000000','name','','Ilegal Infiltration'),
	('5ce3f0ab-a480-439d-bc97-96a700000000','5ce3f0ab-8c98-4386-960d-96a700000000','id','','21'),
	('5ce3f0ab-a494-44ea-b724-96a700000000','5ce3f0ab-3e44-49a6-ac3e-96a700000000','id','','34'),
	('5ce3f0ab-a5ac-47b8-ad78-96a700000000','5ce3f0ab-7528-4c25-bbba-96a700000000','id','','3'),
	('5ce3f0ab-a6cc-4ba2-9637-96a700000000','5ce3f0ab-9be0-4b68-b0dd-96a700000000','name','','Cabling Unsecured'),
	('5ce3f0ab-ae6c-4ba2-bbb5-96a700000000','5ce3f0ab-8810-479d-b416-96a700000000','id','','11'),
	('5ce3f0ab-b020-4937-9b32-96a700000000','5ce3f0ab-a774-473f-be86-96a700000000','id','','6'),
	('5ce3f0ab-b0d4-44d9-899b-96a700000000','5ce3f0ab-178c-4fbc-9721-96a700000000','name','','Tunneling'),
	('5ce3f0ab-b0d4-44e7-80a5-96a700000000','5ce3f0ab-7934-4326-a536-96a700000000','name','','Missing Configuration Standards'),
	('5ce3f0ab-b198-4d6d-a42e-96a700000000','5ce3f0ab-fb04-49b8-b74d-96a700000000','name','','Natural Disasters'),
	('5ce3f0ab-b38c-43bf-a895-96a700000000','5ce3f0ab-4308-43d1-9625-96a700000000','name','','Web Application Attack'),
	('5ce3f0ab-b44c-439a-b143-96a700000000','5ce3f0ab-5414-40a4-a97a-96a700000000','name','','Weak CheckOut Procedures'),
	('5ce3f0ab-b4f0-4c54-9ba7-96a700000000','5ce3f0ab-4aec-446a-a999-96a700000000','name','','Floodings'),
	('5ce3f0ab-b520-4842-802b-96a700000000','5ce3f0ab-a9b8-425f-96cf-96a700000000','id','','33'),
	('5ce3f0ab-b628-42a5-af11-96a700000000','5ce3f0ab-28b4-43e2-827a-96a700000000','id','','24'),
	('5ce3f0ab-b7c8-46bf-8cf5-96a700000000','5ce3f0ab-fc20-4451-96c6-96a700000000','name','','No Change Management'),
	('5ce3f0ab-b9ac-4d40-8ba5-96a700000000','5ce3f0ab-9e40-4258-a39b-96a700000000','id','','24'),
	('5ce3f0ab-ba80-41ce-a2da-96a700000000','5ce3f0ab-9618-438a-9d5d-96a700000000','id','','19'),
	('5ce3f0ab-bb40-4e45-9b52-96a700000000','5ce3f0ab-08f8-4305-a3e7-96a700000000','name','','Third Party Intrusion'),
	('5ce3f0ab-bf58-473e-b68f-96a700000000','5ce3f0ab-ace8-43e4-9087-96a700000000','id','','34'),
	('5ce3f0ab-c0fc-4627-b0c3-96a700000000','5ce3f0ab-9234-46c5-9af6-96a700000000','id','','13'),
	('5ce3f0ab-c478-444b-8b78-96a700000000','5ce3f0ab-6884-41c2-a512-96a700000000','name','','Lack of Physical Guards'),
	('5ce3f0ab-c8a8-4a25-a4a2-96a700000000','5ce3f0ab-5df0-4054-83ca-96a700000000','id','','28'),
	('5ce3f0ab-c940-4623-aca0-96a700000000','5ce3f0ab-6194-4efc-ab3a-96a700000000','name','','Spying'),
	('5ce3f0ab-c984-4c9a-bc6c-96a700000000','5ce3f0ab-a6ac-4836-8376-96a700000000','id','','23'),
	('5ce3f0ab-ce9c-4a4d-a417-96a700000000','5ce3f0ab-d400-4eeb-8859-96a700000000','id','','13'),
	('5ce3f0ab-cfe4-4086-8d65-96a700000000','5ce3f0ab-495c-4a5a-a436-96a700000000','name','','Man in the Middle'),
	('5ce3f0ab-d044-4356-bdbf-96a700000000','5ce3f0ab-c284-4140-8703-96a700000000','id','','27'),
	('5ce3f0ab-d2bc-4e64-8e6e-96a700000000','5ce3f0ab-fc10-4e99-88d7-96a700000000','id','','20'),
	('5ce3f0ab-d4a0-46bd-b4ff-96a700000000','5ce3f0ab-8c98-4386-960d-96a700000000','name','','Lack of Fire Extinguishers'),
	('5ce3f0ab-d5c8-4010-a365-96a700000000','5ce3f0ab-544c-46cd-b919-96a700000000','id','','31'),
	('5ce3f0ab-d884-463e-aab0-96a700000000','5ce3f0ab-846c-4aa6-b793-96a700000000','id','','18'),
	('5ce3f0ab-dc14-4cd3-bff9-96a700000000','5ce3f0ab-7788-4ada-bb41-96a700000000','name','','Lack of Network Controls'),
	('5ce3f0ab-ddd0-4651-b093-96a700000000','5ce3f0ab-a780-4c3c-944e-96a700000000','name','','Open Network Ports'),
	('5ce3f0ab-de20-4fd9-8130-96a700000000','5ce3f0ab-5c24-4dc0-8735-96a700000000','name','','Lack of Information'),
	('5ce3f0ab-e2a4-4abd-96a8-96a700000000','5ce3f0ab-c800-4524-aa29-96a700000000','id','','16'),
	('5ce3f0ab-e2f4-42af-861b-96a700000000','5ce3f0ab-a780-4c3c-944e-96a700000000','id','','26'),
	('5ce3f0ab-e6b8-4c91-ba3c-96a700000000','5ce3f0ab-b0bc-43f8-95b4-96a700000000','id','','22'),
	('5ce3f0ab-ef30-4be6-a92c-96a700000000','5ce3f0ab-7528-4c25-bbba-96a700000000','name','','Lack of Logs'),
	('5ce3f0ab-f0c8-4e50-b9a7-96a700000000','5ce3f0ab-b234-42c4-952e-96a700000000','id','','17'),
	('5ce3f0ab-f20c-4189-a530-96a700000000','5ce3f0aa-d5b4-49a6-a14e-96a700000000','id','','9'),
	('5ce3f0ab-f3ec-4979-b79b-96a700000000','5ce3f0ab-74f4-47f3-909f-96a700000000','name','','Viruses'),
	('5ce3f0ab-f4e8-4115-bf73-96a700000000','5ce3f0ab-d6c0-480d-9f6d-96a700000000','id','','20'),
	('5ce3f0ab-f814-4119-9059-96a700000000','5ce3f0ab-69ac-4e87-bfa2-96a700000000','id','','32'),
	('5ce3f0ab-f944-4a6b-8925-96a700000000','5ce3f0ab-5cdc-49b8-a01c-96a700000000','name','','Lack of Patching'),
	('5ce3f0ab-fb34-4f3f-bc1c-96a700000000','5ce3f0ab-a774-473f-be86-96a700000000','name','','Supplier Failure');
ALTER TABLE `audit_deltas` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `ldap_connectors` WRITE;
ALTER TABLE `ldap_connectors` DISABLE KEYS;
ALTER TABLE `ldap_connectors` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `awareness_programs` WRITE;
ALTER TABLE `awareness_programs` DISABLE KEYS;
ALTER TABLE `awareness_programs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `awareness_overtime_graphs` WRITE;
ALTER TABLE `awareness_overtime_graphs` DISABLE KEYS;
ALTER TABLE `awareness_overtime_graphs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `awareness_program_active_users` WRITE;
ALTER TABLE `awareness_program_active_users` DISABLE KEYS;
ALTER TABLE `awareness_program_active_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `awareness_program_compliant_users` WRITE;
ALTER TABLE `awareness_program_compliant_users` DISABLE KEYS;
ALTER TABLE `awareness_program_compliant_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `awareness_program_demos` WRITE;
ALTER TABLE `awareness_program_demos` DISABLE KEYS;
ALTER TABLE `awareness_program_demos` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `awareness_program_ignored_users` WRITE;
ALTER TABLE `awareness_program_ignored_users` DISABLE KEYS;
ALTER TABLE `awareness_program_ignored_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `awareness_program_ldap_groups` WRITE;
ALTER TABLE `awareness_program_ldap_groups` DISABLE KEYS;
ALTER TABLE `awareness_program_ldap_groups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `awareness_program_recurrences` WRITE;
ALTER TABLE `awareness_program_recurrences` DISABLE KEYS;
ALTER TABLE `awareness_program_recurrences` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `awareness_program_missed_recurrences` WRITE;
ALTER TABLE `awareness_program_missed_recurrences` DISABLE KEYS;
ALTER TABLE `awareness_program_missed_recurrences` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `awareness_program_not_compliant_users` WRITE;
ALTER TABLE `awareness_program_not_compliant_users` DISABLE KEYS;
ALTER TABLE `awareness_program_not_compliant_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `awareness_programs_security_policies` WRITE;
ALTER TABLE `awareness_programs_security_policies` DISABLE KEYS;
ALTER TABLE `awareness_programs_security_policies` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `awareness_reminders` WRITE;
ALTER TABLE `awareness_reminders` DISABLE KEYS;
ALTER TABLE `awareness_reminders` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `awareness_users` WRITE;
ALTER TABLE `awareness_users` DISABLE KEYS;
ALTER TABLE `awareness_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `awareness_trainings` WRITE;
ALTER TABLE `awareness_trainings` DISABLE KEYS;
ALTER TABLE `awareness_trainings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `backups` WRITE;
ALTER TABLE `backups` DISABLE KEYS;
ALTER TABLE `backups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `bulk_actions` WRITE;
ALTER TABLE `bulk_actions` DISABLE KEYS;
ALTER TABLE `bulk_actions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `bulk_action_objects` WRITE;
ALTER TABLE `bulk_action_objects` DISABLE KEYS;
ALTER TABLE `bulk_action_objects` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuities` WRITE;
ALTER TABLE `business_continuities` DISABLE KEYS;
ALTER TABLE `business_continuities` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuities_business_continuity_plans` WRITE;
ALTER TABLE `business_continuities_business_continuity_plans` DISABLE KEYS;
ALTER TABLE `business_continuities_business_continuity_plans` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuities_business_units` WRITE;
ALTER TABLE `business_continuities_business_units` DISABLE KEYS;
ALTER TABLE `business_continuities_business_units` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuities_compliance_managements` WRITE;
ALTER TABLE `business_continuities_compliance_managements` DISABLE KEYS;
ALTER TABLE `business_continuities_compliance_managements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuities_goals` WRITE;
ALTER TABLE `business_continuities_goals` DISABLE KEYS;
ALTER TABLE `business_continuities_goals` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuities_processes` WRITE;
ALTER TABLE `business_continuities_processes` DISABLE KEYS;
ALTER TABLE `business_continuities_processes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuities_projects` WRITE;
ALTER TABLE `business_continuities_projects` DISABLE KEYS;
ALTER TABLE `business_continuities_projects` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuities_risk_classifications` WRITE;
ALTER TABLE `business_continuities_risk_classifications` DISABLE KEYS;
ALTER TABLE `business_continuities_risk_classifications` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuities_risk_exceptions` WRITE;
ALTER TABLE `business_continuities_risk_exceptions` DISABLE KEYS;
ALTER TABLE `business_continuities_risk_exceptions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuities_security_services` WRITE;
ALTER TABLE `business_continuities_security_services` DISABLE KEYS;
ALTER TABLE `business_continuities_security_services` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuities_threats` WRITE;
ALTER TABLE `business_continuities_threats` DISABLE KEYS;
ALTER TABLE `business_continuities_threats` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuities_vulnerabilities` WRITE;
ALTER TABLE `business_continuities_vulnerabilities` DISABLE KEYS;
ALTER TABLE `business_continuities_vulnerabilities` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuity_plan_audit_dates` WRITE;
ALTER TABLE `business_continuity_plan_audit_dates` DISABLE KEYS;
ALTER TABLE `business_continuity_plan_audit_dates` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuity_plan_audit_improvements` WRITE;
ALTER TABLE `business_continuity_plan_audit_improvements` DISABLE KEYS;
ALTER TABLE `business_continuity_plan_audit_improvements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuity_plan_audit_improvements_projects` WRITE;
ALTER TABLE `business_continuity_plan_audit_improvements_projects` DISABLE KEYS;
ALTER TABLE `business_continuity_plan_audit_improvements_projects` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuity_plan_audit_improvements_security_incidents` WRITE;
ALTER TABLE `business_continuity_plan_audit_improvements_security_incidents` DISABLE KEYS;
ALTER TABLE `business_continuity_plan_audit_improvements_security_incidents` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuity_plans` WRITE;
ALTER TABLE `business_continuity_plans` DISABLE KEYS;
ALTER TABLE `business_continuity_plans` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuity_plan_audits` WRITE;
ALTER TABLE `business_continuity_plan_audits` DISABLE KEYS;
ALTER TABLE `business_continuity_plan_audits` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuity_tasks` WRITE;
ALTER TABLE `business_continuity_tasks` DISABLE KEYS;
ALTER TABLE `business_continuity_tasks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_continuity_task_reminders` WRITE;
ALTER TABLE `business_continuity_task_reminders` DISABLE KEYS;
ALTER TABLE `business_continuity_task_reminders` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_units` WRITE;
ALTER TABLE `business_units` DISABLE KEYS;
INSERT INTO `business_units` (`id`, `name`, `description`, `workflow_status`, `workflow_owner_id`, `_hidden`, `created`, `modified`, `edited`, `deleted`, `deleted_date`) VALUES 
	(1,'Everyone','',4,NULL,1,'2015-12-19 00:00:00','2015-12-19 00:00:00',NULL,0,NULL);
ALTER TABLE `business_units` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_units_data_assets` WRITE;
ALTER TABLE `business_units_data_assets` DISABLE KEYS;
ALTER TABLE `business_units_data_assets` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `business_units_legals` WRITE;
ALTER TABLE `business_units_legals` DISABLE KEYS;
ALTER TABLE `business_units_legals` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cake_sessions` WRITE;
ALTER TABLE `cake_sessions` DISABLE KEYS;
INSERT INTO `cake_sessions` (`id`, `data`, `expires`) VALUES 
	('g093r6gn1hac2kmcoggfurum11','Config|a:3:{s:9:"userAgent";s:0:"";s:4:"time";i:1560271638;s:9:"countdown";i:10;}Auth|a:2:{s:4:"User";a:18:{s:2:"id";s:1:"1";s:4:"name";s:5:"Admin";s:7:"surname";s:5:"Admin";s:5:"email";s:16:"admin@eramba.org";s:5:"login";s:5:"admin";s:8:"password";s:60:"$2a$10$WhVO3Jj4nFhCj6bToUOztun/oceKY6rT2db2bu430dW5/lU0w9KJ.";s:8:"language";s:3:"eng";s:6:"status";s:1:"1";s:7:"blocked";s:1:"0";s:13:"local_account";s:1:"1";s:9:"api_allow";s:1:"0";s:16:"default_password";s:1:"0";s:7:"created";s:19:"2013-10-14 16:19:04";s:8:"modified";s:19:"2015-09-11 18:19:52";s:6:"edited";N;s:9:"full_name";s:11:"Admin Admin";s:19:"full_name_with_type";s:18:"Admin Admin (User)";s:6:"Groups";a:1:{i:0;s:2:"10";}}s:23:"AuthUsersFromAllPortals";a:1:{s:4:"main";a:3:{s:2:"id";s:1:"1";s:13:"local_account";s:1:"1";s:16:"default_password";s:1:"0";}}}',1560271644),
	('t191idgfdt5jlk13m4l4otumbc','Config|a:3:{s:9:"userAgent";s:0:"";s:4:"time";i:1571421426;s:9:"countdown";i:10;}',1571421467);
ALTER TABLE `cake_sessions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `comments` WRITE;
ALTER TABLE `comments` DISABLE KEYS;
ALTER TABLE `comments` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_analysis_findings` WRITE;
ALTER TABLE `compliance_analysis_findings` DISABLE KEYS;
ALTER TABLE `compliance_analysis_findings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_analysis_findings_compliance_managements` WRITE;
ALTER TABLE `compliance_analysis_findings_compliance_managements` DISABLE KEYS;
ALTER TABLE `compliance_analysis_findings_compliance_managements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_analysis_findings_compliance_package_items` WRITE;
ALTER TABLE `compliance_analysis_findings_compliance_package_items` DISABLE KEYS;
ALTER TABLE `compliance_analysis_findings_compliance_package_items` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_analysis_findings_compliance_package_regulators` WRITE;
ALTER TABLE `compliance_analysis_findings_compliance_package_regulators` DISABLE KEYS;
ALTER TABLE `compliance_analysis_findings_compliance_package_regulators` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_audit_feedback_profiles` WRITE;
ALTER TABLE `compliance_audit_feedback_profiles` DISABLE KEYS;
ALTER TABLE `compliance_audit_feedback_profiles` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_audit_feedbacks` WRITE;
ALTER TABLE `compliance_audit_feedbacks` DISABLE KEYS;
ALTER TABLE `compliance_audit_feedbacks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_audit_auditee_feedbacks` WRITE;
ALTER TABLE `compliance_audit_auditee_feedbacks` DISABLE KEYS;
ALTER TABLE `compliance_audit_auditee_feedbacks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_audit_feedbacks_compliance_audits` WRITE;
ALTER TABLE `compliance_audit_feedbacks_compliance_audits` DISABLE KEYS;
ALTER TABLE `compliance_audit_feedbacks_compliance_audits` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_audit_overtime_graphs` WRITE;
ALTER TABLE `compliance_audit_overtime_graphs` DISABLE KEYS;
ALTER TABLE `compliance_audit_overtime_graphs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_audit_provided_feedbacks` WRITE;
ALTER TABLE `compliance_audit_provided_feedbacks` DISABLE KEYS;
ALTER TABLE `compliance_audit_provided_feedbacks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_audit_settings` WRITE;
ALTER TABLE `compliance_audit_settings` DISABLE KEYS;
ALTER TABLE `compliance_audit_settings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_audit_setting_notifications` WRITE;
ALTER TABLE `compliance_audit_setting_notifications` DISABLE KEYS;
ALTER TABLE `compliance_audit_setting_notifications` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_audit_settings_auditees` WRITE;
ALTER TABLE `compliance_audit_settings_auditees` DISABLE KEYS;
ALTER TABLE `compliance_audit_settings_auditees` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_audits` WRITE;
ALTER TABLE `compliance_audits` DISABLE KEYS;
ALTER TABLE `compliance_audits` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_exceptions` WRITE;
ALTER TABLE `compliance_exceptions` DISABLE KEYS;
ALTER TABLE `compliance_exceptions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_exceptions_compliance_findings` WRITE;
ALTER TABLE `compliance_exceptions_compliance_findings` DISABLE KEYS;
ALTER TABLE `compliance_exceptions_compliance_findings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_exceptions_compliance_managements` WRITE;
ALTER TABLE `compliance_exceptions_compliance_managements` DISABLE KEYS;
ALTER TABLE `compliance_exceptions_compliance_managements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_finding_classifications` WRITE;
ALTER TABLE `compliance_finding_classifications` DISABLE KEYS;
ALTER TABLE `compliance_finding_classifications` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_finding_statuses` WRITE;
ALTER TABLE `compliance_finding_statuses` DISABLE KEYS;
INSERT INTO `compliance_finding_statuses` (`id`, `name`) VALUES 
	(1,'Open Item'),
	(2,'Closed Item');
ALTER TABLE `compliance_finding_statuses` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_findings` WRITE;
ALTER TABLE `compliance_findings` DISABLE KEYS;
ALTER TABLE `compliance_findings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_findings_third_party_risks` WRITE;
ALTER TABLE `compliance_findings_third_party_risks` DISABLE KEYS;
ALTER TABLE `compliance_findings_third_party_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_managements` WRITE;
ALTER TABLE `compliance_managements` DISABLE KEYS;
ALTER TABLE `compliance_managements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_managements_projects` WRITE;
ALTER TABLE `compliance_managements_projects` DISABLE KEYS;
ALTER TABLE `compliance_managements_projects` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_managements_risks` WRITE;
ALTER TABLE `compliance_managements_risks` DISABLE KEYS;
ALTER TABLE `compliance_managements_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_managements_security_policies` WRITE;
ALTER TABLE `compliance_managements_security_policies` DISABLE KEYS;
ALTER TABLE `compliance_managements_security_policies` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_managements_security_services` WRITE;
ALTER TABLE `compliance_managements_security_services` DISABLE KEYS;
ALTER TABLE `compliance_managements_security_services` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_managements_third_party_risks` WRITE;
ALTER TABLE `compliance_managements_third_party_risks` DISABLE KEYS;
ALTER TABLE `compliance_managements_third_party_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_package_items` WRITE;
ALTER TABLE `compliance_package_items` DISABLE KEYS;
ALTER TABLE `compliance_package_items` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_package_regulators` WRITE;
ALTER TABLE `compliance_package_regulators` DISABLE KEYS;
ALTER TABLE `compliance_package_regulators` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_package_regulators_legals` WRITE;
ALTER TABLE `compliance_package_regulators_legals` DISABLE KEYS;
ALTER TABLE `compliance_package_regulators_legals` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_packages` WRITE;
ALTER TABLE `compliance_packages` DISABLE KEYS;
ALTER TABLE `compliance_packages` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_statuses` WRITE;
ALTER TABLE `compliance_statuses` DISABLE KEYS;
INSERT INTO `compliance_statuses` (`id`, `name`) VALUES 
	(1,'On-Going'),
	(2,'Compliant'),
	(3,'Non-Compliant'),
	(4,'Not-Applicable');
ALTER TABLE `compliance_statuses` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `compliance_treatment_strategies` WRITE;
ALTER TABLE `compliance_treatment_strategies` DISABLE KEYS;
INSERT INTO `compliance_treatment_strategies` (`id`, `name`) VALUES 
	(1,'Compliant'),
	(2,'Not Applicable'),
	(3,'Not Compliant');
ALTER TABLE `compliance_treatment_strategies` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `concurrent_edits` WRITE;
ALTER TABLE `concurrent_edits` DISABLE KEYS;
ALTER TABLE `concurrent_edits` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `countries` WRITE;
ALTER TABLE `countries` DISABLE KEYS;
ALTER TABLE `countries` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cron` WRITE;
ALTER TABLE `cron` DISABLE KEYS;
ALTER TABLE `cron` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cron_tasks` WRITE;
ALTER TABLE `cron_tasks` DISABLE KEYS;
ALTER TABLE `cron_tasks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `custom_fields` WRITE;
ALTER TABLE `custom_fields` DISABLE KEYS;
ALTER TABLE `custom_fields` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `custom_field_options` WRITE;
ALTER TABLE `custom_field_options` DISABLE KEYS;
ALTER TABLE `custom_field_options` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `custom_field_settings` WRITE;
ALTER TABLE `custom_field_settings` DISABLE KEYS;
INSERT INTO `custom_field_settings` (`id`, `model`, `status`) VALUES 
	(1,'SecurityService',0),
	(2,'SecurityServiceAudit',0),
	(3,'SecurityServiceMaintenance',0),
	(4,'BusinessUnit',0),
	(5,'Process',0),
	(6,'ThirdParty',0),
	(7,'Asset',0),
	(8,'Risk',0),
	(9,'ThirdPartyRisk',0),
	(10,'BusinessContinuity',0),
	(11,'ComplianceAnalysisFinding',0),
	(13,'RiskException',0),
	(14,'PolicyException',0),
	(15,'ComplianceException',0),
	(16,'SecurityIncident',0),
	(17,'DataAsset',0),
	(18,'ProgramIssue',0),
	(19,'Goal',0),
	(20,'TeamRole',0),
	(21,'Legal',0),
	(22,'SecurityPolicy',0),
	(23,'ComplianceManagement',0),
	(24,'Project',0),
	(25,'ServiceContract',0),
	(26,'VendorAssessmentFinding',0);
ALTER TABLE `custom_field_settings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `custom_field_values` WRITE;
ALTER TABLE `custom_field_values` DISABLE KEYS;
ALTER TABLE `custom_field_values` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `custom_forms` WRITE;
ALTER TABLE `custom_forms` DISABLE KEYS;
ALTER TABLE `custom_forms` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `custom_labels` WRITE;
ALTER TABLE `custom_labels` DISABLE KEYS;
ALTER TABLE `custom_labels` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `custom_roles_groups` WRITE;
ALTER TABLE `custom_roles_groups` DISABLE KEYS;
INSERT INTO `custom_roles_groups` (`id`, `group_id`, `created`) VALUES 
	(1,10,'2019-05-21 12:35:44'),
	(2,11,'2019-05-21 12:35:44'),
	(3,12,'2019-05-21 12:35:44'),
	(4,13,'2019-05-21 12:35:44'),
	(5,14,'2019-05-21 12:37:43'),
	(6,15,'2019-05-21 12:37:43'),
	(7,16,'2019-05-21 12:37:43'),
	(8,17,'2019-05-21 12:37:43'),
	(9,18,'2019-05-21 12:37:44'),
	(10,19,'2019-10-18 16:27:06');
ALTER TABLE `custom_roles_groups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `custom_roles_roles` WRITE;
ALTER TABLE `custom_roles_roles` DISABLE KEYS;
ALTER TABLE `custom_roles_roles` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `custom_roles_role_groups` WRITE;
ALTER TABLE `custom_roles_role_groups` DISABLE KEYS;
ALTER TABLE `custom_roles_role_groups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `custom_roles_role_users` WRITE;
ALTER TABLE `custom_roles_role_users` DISABLE KEYS;
ALTER TABLE `custom_roles_role_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `custom_roles_users` WRITE;
ALTER TABLE `custom_roles_users` DISABLE KEYS;
INSERT INTO `custom_roles_users` (`id`, `user_id`, `created`) VALUES 
	(1,1,'2019-05-21 12:35:44');
ALTER TABLE `custom_roles_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `custom_validator_fields` WRITE;
ALTER TABLE `custom_validator_fields` DISABLE KEYS;
ALTER TABLE `custom_validator_fields` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `dashboard_calendar_events` WRITE;
ALTER TABLE `dashboard_calendar_events` DISABLE KEYS;
ALTER TABLE `dashboard_calendar_events` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `dashboard_kpi_attributes` WRITE;
ALTER TABLE `dashboard_kpi_attributes` DISABLE KEYS;
ALTER TABLE `dashboard_kpi_attributes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `dashboard_kpi_logs` WRITE;
ALTER TABLE `dashboard_kpi_logs` DISABLE KEYS;
ALTER TABLE `dashboard_kpi_logs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `dashboard_kpi_thresholds` WRITE;
ALTER TABLE `dashboard_kpi_thresholds` DISABLE KEYS;
ALTER TABLE `dashboard_kpi_thresholds` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `dashboard_kpi_values` WRITE;
ALTER TABLE `dashboard_kpi_values` DISABLE KEYS;
ALTER TABLE `dashboard_kpi_values` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `dashboard_kpi_value_logs` WRITE;
ALTER TABLE `dashboard_kpi_value_logs` DISABLE KEYS;
ALTER TABLE `dashboard_kpi_value_logs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `dashboard_kpis` WRITE;
ALTER TABLE `dashboard_kpis` DISABLE KEYS;
ALTER TABLE `dashboard_kpis` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `dashboard_logs` WRITE;
ALTER TABLE `dashboard_logs` DISABLE KEYS;
ALTER TABLE `dashboard_logs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_asset_gdpr` WRITE;
ALTER TABLE `data_asset_gdpr` DISABLE KEYS;
ALTER TABLE `data_asset_gdpr` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_asset_gdpr_archiving_drivers` WRITE;
ALTER TABLE `data_asset_gdpr_archiving_drivers` DISABLE KEYS;
ALTER TABLE `data_asset_gdpr_archiving_drivers` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_asset_gdpr_collection_methods` WRITE;
ALTER TABLE `data_asset_gdpr_collection_methods` DISABLE KEYS;
ALTER TABLE `data_asset_gdpr_collection_methods` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_asset_gdpr_data_types` WRITE;
ALTER TABLE `data_asset_gdpr_data_types` DISABLE KEYS;
ALTER TABLE `data_asset_gdpr_data_types` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_asset_gdpr_lawful_bases` WRITE;
ALTER TABLE `data_asset_gdpr_lawful_bases` DISABLE KEYS;
ALTER TABLE `data_asset_gdpr_lawful_bases` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_asset_gdpr_third_party_countries` WRITE;
ALTER TABLE `data_asset_gdpr_third_party_countries` DISABLE KEYS;
ALTER TABLE `data_asset_gdpr_third_party_countries` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_asset_instances` WRITE;
ALTER TABLE `data_asset_instances` DISABLE KEYS;
ALTER TABLE `data_asset_instances` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_asset_settings` WRITE;
ALTER TABLE `data_asset_settings` DISABLE KEYS;
ALTER TABLE `data_asset_settings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_asset_settings_third_parties` WRITE;
ALTER TABLE `data_asset_settings_third_parties` DISABLE KEYS;
ALTER TABLE `data_asset_settings_third_parties` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_asset_settings_users` WRITE;
ALTER TABLE `data_asset_settings_users` DISABLE KEYS;
ALTER TABLE `data_asset_settings_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_asset_statuses` WRITE;
ALTER TABLE `data_asset_statuses` DISABLE KEYS;
INSERT INTO `data_asset_statuses` (`id`, `name`) VALUES 
	(1,'Created'),
	(2,'Modified'),
	(3,'Stored'),
	(4,'Transit'),
	(5,'Deleted'),
	(6,'Tainted / Broken'),
	(7,'Unnecessary');
ALTER TABLE `data_asset_statuses` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_assets` WRITE;
ALTER TABLE `data_assets` DISABLE KEYS;
ALTER TABLE `data_assets` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_assets_projects` WRITE;
ALTER TABLE `data_assets_projects` DISABLE KEYS;
ALTER TABLE `data_assets_projects` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_assets_risks` WRITE;
ALTER TABLE `data_assets_risks` DISABLE KEYS;
ALTER TABLE `data_assets_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_assets_security_policies` WRITE;
ALTER TABLE `data_assets_security_policies` DISABLE KEYS;
ALTER TABLE `data_assets_security_policies` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_assets_security_services` WRITE;
ALTER TABLE `data_assets_security_services` DISABLE KEYS;
ALTER TABLE `data_assets_security_services` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `data_assets_third_parties` WRITE;
ALTER TABLE `data_assets_third_parties` DISABLE KEYS;
ALTER TABLE `data_assets_third_parties` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `goal_audit_dates` WRITE;
ALTER TABLE `goal_audit_dates` DISABLE KEYS;
ALTER TABLE `goal_audit_dates` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `goal_audit_improvements` WRITE;
ALTER TABLE `goal_audit_improvements` DISABLE KEYS;
ALTER TABLE `goal_audit_improvements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `goal_audit_improvements_projects` WRITE;
ALTER TABLE `goal_audit_improvements_projects` DISABLE KEYS;
ALTER TABLE `goal_audit_improvements_projects` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `goal_audit_improvements_security_incidents` WRITE;
ALTER TABLE `goal_audit_improvements_security_incidents` DISABLE KEYS;
ALTER TABLE `goal_audit_improvements_security_incidents` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `goals` WRITE;
ALTER TABLE `goals` DISABLE KEYS;
ALTER TABLE `goals` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `goal_audits` WRITE;
ALTER TABLE `goal_audits` DISABLE KEYS;
ALTER TABLE `goal_audits` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `goals_program_issues` WRITE;
ALTER TABLE `goals_program_issues` DISABLE KEYS;
ALTER TABLE `goals_program_issues` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `goals_projects` WRITE;
ALTER TABLE `goals_projects` DISABLE KEYS;
ALTER TABLE `goals_projects` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `goals_risks` WRITE;
ALTER TABLE `goals_risks` DISABLE KEYS;
ALTER TABLE `goals_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `goals_security_policies` WRITE;
ALTER TABLE `goals_security_policies` DISABLE KEYS;
ALTER TABLE `goals_security_policies` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `goals_security_services` WRITE;
ALTER TABLE `goals_security_services` DISABLE KEYS;
ALTER TABLE `goals_security_services` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `goals_third_party_risks` WRITE;
ALTER TABLE `goals_third_party_risks` DISABLE KEYS;
ALTER TABLE `goals_third_party_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `groups` WRITE;
ALTER TABLE `groups` DISABLE KEYS;
INSERT INTO `groups` (`id`, `name`, `description`, `status`, `slug`, `created`, `modified`, `edited`) VALUES 
	(10,'Admin','This is a system message, this group might not have updated ACLs please make sure you edit and review them',1,'ADMIN','2013-10-14 16:18:08','2013-10-14 16:18:08',NULL),
	(11,'Third Party Feedback','This is a system message, this group might not have updated ACLs please make sure you edit and review them',1,'THIRD_PARTY_FEEDBACK','2016-01-07 17:07:53','2016-01-07 17:07:53',NULL),
	(12,'Notification Feedback','This is a system message, this group might not have updated ACLs please make sure you edit and review them',1,'NOTIFICATION_FEEDBACK','2016-01-07 17:08:02','2016-01-07 17:08:02',NULL),
	(13,'All but Settings','This is a system message, this group might not have updated ACLs please make sure you edit and review them',1,'ALL_BUT_SETTINGS','2016-01-07 17:08:10','2016-01-07 17:08:10',NULL),
	(14,'System Group - View Policies and Reviews','This group only allows users to see policies and their reviews under the policy management module. \n                            Disclaimer: always review the group permissions before assigning them to users, they might grant access you do not want or be outdated as releases move forward.',1,'VIEW_POLICIES_AND_REVIEWS','2019-05-21 12:37:43','2019-05-21 12:37:43',NULL),
	(15,'System Group - View Item Reports','This group allows users to visualise item reports from any section that they have access (granted by another group). Disclaimer: always review the group permissions before assigning them to users, they might grant access you do not want or be outdated as releases move forward.',1,'VIEW_ITEM_REPORTS','2019-05-21 12:37:43','2019-05-21 12:37:43',NULL),
	(16,'System Group - View Internal Controls and Audits, Maintenances and Issues','This group grants permissions to only view internal controls and their related items. Disclaimer: always review the group permissions before assigning them to users, they might grant access you do not want or be outdated as releases move forward.',1,'VIEW_INT_CTRL_AND_AMI','2019-05-21 12:37:43','2019-05-21 12:37:43',NULL),
	(17,'System Group - View All Types of Risks and their Reviews','This group grants access to view all three types of risks and their respective reviews. Disclaimer: always review the group permissions before assigning them to users, they might grant access you do not want or be outdated as releases move forward.',1,'VIEW_RISKS_AND_REVIEWS','2019-05-21 12:37:43','2019-05-21 12:37:43',NULL),
	(18,'System Group - Projects and Tasks','This group grants access to view projects and tasks. Disclaimer: always review the group permissions before assigning them to users, they might grant access you do not want or be outdated as releases move forward.',1,'PROJECTS_AND_TASKS','2019-05-21 12:37:44','2019-05-21 12:37:44',NULL),
	(19,'User Management','This group allows members to add, edit, import and delete user accounts. Add this group to System / Settings / User Management if you want them to be able to edit and delete accounts other than theirs.',1,'USER_MANAGEMENT','2019-10-18 16:27:06','2019-10-18 16:27:06',NULL);
ALTER TABLE `groups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `issues` WRITE;
ALTER TABLE `issues` DISABLE KEYS;
ALTER TABLE `issues` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `ldap_connector_authentication` WRITE;
ALTER TABLE `ldap_connector_authentication` DISABLE KEYS;
INSERT INTO `ldap_connector_authentication` (`id`, `auth_users`, `auth_users_id`, `oauth_google`, `oauth_google_id`, `auth_saml`, `saml_connector_id`, `auth_awareness`, `auth_awareness_id`, `auth_policies`, `auth_policies_id`, `auth_compliance_audit`, `auth_vendor_assessment`, `auth_account_review`, `modified`) VALUES 
	(1,0,NULL,0,0,0,NULL,0,NULL,0,NULL,0,0,0,'2015-08-16 11:20:01');
ALTER TABLE `ldap_connector_authentication` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `ldap_synchronizations` WRITE;
ALTER TABLE `ldap_synchronizations` DISABLE KEYS;
ALTER TABLE `ldap_synchronizations` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `ldap_synchronizations_groups` WRITE;
ALTER TABLE `ldap_synchronizations_groups` DISABLE KEYS;
ALTER TABLE `ldap_synchronizations_groups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `ldap_synchronizations_portals` WRITE;
ALTER TABLE `ldap_synchronizations_portals` DISABLE KEYS;
ALTER TABLE `ldap_synchronizations_portals` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `legals` WRITE;
ALTER TABLE `legals` DISABLE KEYS;
ALTER TABLE `legals` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `legals_third_parties` WRITE;
ALTER TABLE `legals_third_parties` DISABLE KEYS;
ALTER TABLE `legals_third_parties` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `log_security_policies` WRITE;
ALTER TABLE `log_security_policies` DISABLE KEYS;
ALTER TABLE `log_security_policies` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `mapping_relations` WRITE;
ALTER TABLE `mapping_relations` DISABLE KEYS;
ALTER TABLE `mapping_relations` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `news` WRITE;
ALTER TABLE `news` DISABLE KEYS;
ALTER TABLE `news` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `notification_system_item_custom_roles` WRITE;
ALTER TABLE `notification_system_item_custom_roles` DISABLE KEYS;
ALTER TABLE `notification_system_item_custom_roles` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `notification_system_items_objects` WRITE;
ALTER TABLE `notification_system_items_objects` DISABLE KEYS;
ALTER TABLE `notification_system_items_objects` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `notification_system_item_custom_users` WRITE;
ALTER TABLE `notification_system_item_custom_users` DISABLE KEYS;
ALTER TABLE `notification_system_item_custom_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `notification_system_item_emails` WRITE;
ALTER TABLE `notification_system_item_emails` DISABLE KEYS;
ALTER TABLE `notification_system_item_emails` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `notification_system_item_logs` WRITE;
ALTER TABLE `notification_system_item_logs` DISABLE KEYS;
ALTER TABLE `notification_system_item_logs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `notification_system_item_feedbacks` WRITE;
ALTER TABLE `notification_system_item_feedbacks` DISABLE KEYS;
ALTER TABLE `notification_system_item_feedbacks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `notification_system_items` WRITE;
ALTER TABLE `notification_system_items` DISABLE KEYS;
ALTER TABLE `notification_system_items` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `notification_system_items_users` WRITE;
ALTER TABLE `notification_system_items_users` DISABLE KEYS;
ALTER TABLE `notification_system_items_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `notifications` WRITE;
ALTER TABLE `notifications` DISABLE KEYS;
ALTER TABLE `notifications` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `oauth_connectors` WRITE;
ALTER TABLE `oauth_connectors` DISABLE KEYS;
ALTER TABLE `oauth_connectors` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `object_status_statuses` WRITE;
ALTER TABLE `object_status_statuses` DISABLE KEYS;
ALTER TABLE `object_status_statuses` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `object_status_object_statuses` WRITE;
ALTER TABLE `object_status_object_statuses` DISABLE KEYS;
ALTER TABLE `object_status_object_statuses` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `phinxlog` WRITE;
ALTER TABLE `phinxlog` DISABLE KEYS;
INSERT INTO `phinxlog` (`version`, `migration_name`, `start_time`, `end_time`, `breakpoint`) VALUES 
	(20170222204044,'Initial','2019-05-21 12:34:32','2019-05-21 12:34:42',0),
	(20170224222143,'LdapConnectorFieldLength','2019-05-21 12:34:42','2019-05-21 12:34:42',0),
	(20170227174535,'SecurityIncidentAutoClose','2019-05-21 12:34:42','2019-05-21 12:34:42',0),
	(20170304180120,'ComplianceAnalysisFindings','2019-05-21 12:34:42','2019-05-21 12:34:43',0),
	(20170306150509,'ExceptionCustomFields','2019-05-21 12:34:43','2019-05-21 12:34:43',0),
	(20170419103452,'Release34','2019-05-21 12:34:43','2019-05-21 12:34:43',0),
	(20170419103453,'BulkActionMigration','2019-05-21 12:34:43','2019-05-21 12:34:43',0),
	(20170427111638,'Workflows','2019-05-21 12:34:43','2019-05-21 12:34:45',0),
	(20170501232248,'HideDashboardSetting','2019-05-21 12:34:45','2019-05-21 12:34:45',0),
	(20170505114957,'RiskDescriptionField','2019-05-21 12:34:45','2019-05-21 12:34:45',0),
	(20170505115348,'SecurityIncidentsCustomFields','2019-05-21 12:34:45','2019-05-21 12:34:45',0),
	(20170505133034,'RiskGranularitySetting','2019-05-21 12:34:45','2019-05-21 12:34:45',0),
	(20170512081755,'ComplianceFindingsRequirements','2019-05-21 12:34:45','2019-05-21 12:34:45',0),
	(20170514184834,'Release35','2019-05-21 12:34:45','2019-05-21 12:34:45',0),
	(20170530050821,'VisualisationMigration','2019-05-21 12:34:45','2019-05-21 12:34:46',0),
	(20170530162223,'ComplianceSectionMigration','2019-05-21 12:34:46','2019-05-21 12:34:46',0),
	(20170531083319,'VisualisationUpdate','2019-05-21 12:34:46','2019-05-21 12:34:46',0),
	(20170531141458,'CompliancePackageSoftDelete','2019-05-21 12:34:46','2019-05-21 12:34:46',0),
	(20170601152538,'ComplianceManagementSoftDelete','2019-05-21 12:34:46','2019-05-21 12:34:46',0),
	(20170606000803,'VisualisationOrder','2019-05-21 12:34:46','2019-05-21 12:34:46',0),
	(20170616135005,'BusinessUnitSoftDelete','2019-05-21 12:34:46','2019-05-21 12:34:46',0),
	(20170619150358,'ProcessSoftDelete','2019-05-21 12:34:46','2019-05-21 12:34:46',0),
	(20170619161129,'LegalSoftDelete','2019-05-21 12:34:46','2019-05-21 12:34:46',0),
	(20170619165455,'ThirdPartySoftDelete','2019-05-21 12:34:46','2019-05-21 12:34:46',0),
	(20170620132546,'NotificationsUpdate','2019-05-21 12:34:46','2019-05-21 12:34:46',0),
	(20170620191731,'VisualisationConstraints','2019-05-21 12:34:46','2019-05-21 12:34:47',0),
	(20170625133642,'Release36','2019-05-21 12:34:47','2019-05-21 12:34:47',0),
	(20170627130016,'RiskExceptionPolicyExceptionSoftDelete','2019-05-21 12:34:47','2019-05-21 12:34:47',0),
	(20170628084922,'ProjectSoftDelete','2019-05-21 12:34:47','2019-05-21 12:34:47',0),
	(20170628121821,'ProjectAchievementSoftDelete','2019-05-21 12:34:47','2019-05-21 12:34:47',0),
	(20170628124938,'ProjectExpenseSoftDelete','2019-05-21 12:34:47','2019-05-21 12:34:47',0),
	(20170629075407,'SecurityIncidentSoftDelete','2019-05-21 12:34:47','2019-05-21 12:34:47',0),
	(20170629110422,'AwarenessProgramSoftDelete','2019-05-21 12:34:47','2019-05-21 12:34:47',0),
	(20170714125121,'SecurityServiceUrlText','2019-05-21 12:34:47','2019-05-21 12:34:47',0),
	(20170718154512,'CustomRolesUpdates','2019-05-21 12:34:47','2019-05-21 12:34:47',0),
	(20170720180052,'ThirdPartyAuditsPortal','2019-05-21 12:34:47','2019-05-21 12:34:47',0),
	(20170726164030,'Release37','2019-05-21 12:34:47','2019-05-21 12:34:47',0),
	(20170727102926,'DataAssets','2019-05-21 12:34:47','2019-05-21 12:34:49',0),
	(20170728173003,'ObjectStatusMigration','2019-05-21 12:34:49','2019-05-21 12:34:49',0),
	(20170728173555,'DataAssetObjectStatus','2019-05-21 12:34:49','2019-05-21 12:34:49',0),
	(20170804080341,'DataAssetSoftDelete','2019-05-21 12:34:49','2019-05-21 12:34:50',0),
	(20170808090720,'DataAssetCustomFields','2019-05-21 12:34:50','2019-05-21 12:34:50',0),
	(20170810141903,'DataAssetInstancesObjectStatus','2019-05-21 12:34:50','2019-05-21 12:34:50',0),
	(20170811112035,'DataAssetSettingAllCountries','2019-05-21 12:34:50','2019-05-21 12:34:50',0),
	(20170814130739,'DataAssetInstanceNewObjecStatus','2019-05-21 12:34:50','2019-05-21 12:34:50',0),
	(20170815121843,'DataAssetSettingsThirdPartyMigration','2019-05-21 12:34:50','2019-05-21 12:34:50',0),
	(20170817080806,'DataAssetStagesRemoval','2019-05-21 12:34:50','2019-05-21 12:34:50',0),
	(20170825112416,'SecurityServiceObjectStatusFields','2019-05-21 12:34:50','2019-05-21 12:34:50',0),
	(20170831130151,'DataAssetGdprUpdate','2019-05-21 12:34:50','2019-05-21 12:34:50',0),
	(20170906202831,'DataAssetThirdPartyInvolvedRebase','2019-05-21 12:34:50','2019-05-21 12:34:51',0),
	(20170907102831,'ObjectStatusStatusGroup','2019-05-21 12:34:51','2019-05-21 12:34:51',0),
	(20170911142950,'ComplianceManagementComplianceExceptionsHABTM','2019-05-21 12:34:51','2019-05-21 12:34:51',0),
	(20170919113030,'Release39','2019-05-21 12:34:51','2019-05-21 12:34:51',0),
	(20170926145600,'CustomFieldsMigration','2019-05-21 12:34:51','2019-05-21 12:34:51',0),
	(20170929172112,'DataAssetEmptyFields','2019-05-21 12:34:51','2019-05-21 12:34:51',0),
	(20170930183852,'DashboardsMigration','2019-05-21 12:34:51','2019-05-21 12:34:52',0),
	(20171008095457,'DashboardsUpdate1','2019-05-21 12:34:52','2019-05-21 12:34:52',0),
	(20171012203713,'DashboardsUpdate2','2019-05-21 12:34:52','2019-05-21 12:34:52',0),
	(20171030114955,'DashboardsUpdate3','2019-05-21 12:34:52','2019-05-21 12:34:52',0),
	(20171030114956,'Release41','2019-05-21 12:34:52','2019-05-21 12:34:52',0),
	(20171103155724,'Release43','2019-05-21 12:34:52','2019-05-21 12:34:52',0),
	(20171108163033,'Release44','2019-05-21 12:34:52','2019-05-21 12:34:52',0),
	(20171115130844,'AddUrlToCron','2019-05-21 12:34:52','2019-05-21 12:34:52',0),
	(20171116160123,'VisualisationMigrationRls45','2019-05-21 12:34:52','2019-05-21 12:34:52',0),
	(20171125171527,'Release45','2019-05-21 12:34:52','2019-05-21 12:34:52',0),
	(20171125171528,'Release46','2019-05-21 12:34:52','2019-05-21 12:34:52',0),
	(20171201145757,'SecurityPolicyDocumentTypeMigration','2019-05-21 12:34:52','2019-05-21 12:34:52',0),
	(20171201161058,'CreateOauthConnectors','2019-05-21 12:34:52','2019-05-21 12:34:52',0),
	(20171204034932,'AddColumnsToLdapConnectorAuthentication','2019-05-21 12:34:52','2019-05-21 12:34:52',0),
	(20171204035405,'InsertRecordsToSettingGroups','2019-05-21 12:34:52','2019-05-21 12:34:52',0),
	(20171206194944,'CustomValidator','2019-05-21 12:34:52','2019-05-21 12:34:53',0),
	(20171207151610,'RiskAppetitesMigration','2019-05-21 12:34:53','2019-05-21 12:34:53',0),
	(20171208100925,'RiskAppetitesMigration2','2019-05-21 12:34:53','2019-05-21 12:34:53',0),
	(20171208120946,'RiskAppetitesMigration3','2019-05-21 12:34:53','2019-05-21 12:34:53',0),
	(20171208125049,'RiskAppetitesMigration4','2019-05-21 12:34:53','2019-05-21 12:34:53',0),
	(20171208130627,'RiskAppetitesMigration5','2019-05-21 12:34:53','2019-05-21 12:34:54',0),
	(20171208132710,'AssetsComplianceManagement','2019-05-21 12:34:54','2019-05-21 12:34:54',0),
	(20171208133329,'RiskAppetitesMigration6','2019-05-21 12:34:54','2019-05-21 12:34:54',0),
	(20171208143754,'AssetsPolicyException','2019-05-21 12:34:54','2019-05-21 12:34:54',0),
	(20171212094447,'CreateServiceContractsOwners','2019-05-21 12:34:54','2019-05-21 12:34:54',0),
	(20171212133530,'AwarenessProgramTextFrameSize','2019-05-21 12:34:54','2019-05-21 12:34:54',0),
	(20171213145227,'RiskAppetitesMigration7','2019-05-21 12:34:54','2019-05-21 12:34:54',0),
	(20171214125455,'QueueTransportLimit','2019-05-21 12:34:54','2019-05-21 12:34:54',0),
	(20171219163259,'RiskAppetitesMigration8','2019-05-21 12:34:54','2019-05-21 12:34:54',0),
	(20171220095239,'RiskAppetitesMigration9','2019-05-21 12:34:54','2019-05-21 12:34:54',0),
	(20171222142512,'AddColumnsToSecurityServices','2019-05-21 12:34:54','2019-05-21 12:34:55',0),
	(20171222184923,'AddAuditEvidenceOwnerIdToSecurityServiceAudits','2019-05-21 12:34:55','2019-05-21 12:34:55',0),
	(20180103153429,'RiskAppetitesMigration10','2019-05-21 12:34:55','2019-05-21 12:34:55',0),
	(20180108115941,'ChangeForeignKeyInSecurityServiceAudits','2019-05-21 12:34:55','2019-05-21 12:34:55',0),
	(20180108120257,'ChangeForeignKeyInSecurityServiceMaintenances','2019-05-21 12:34:55','2019-05-21 12:34:55',0),
	(20180110104002,'RiskAppetitesMigration11','2019-05-21 12:34:55','2019-05-21 12:34:55',0),
	(20180110104003,'Release47','2019-05-21 12:34:55','2019-05-21 12:34:55',0),
	(20180131115100,'Release48','2019-05-21 12:34:55','2019-05-21 12:34:55',0),
	(20180201110009,'BCPTrash','2019-05-21 12:34:55','2019-05-21 12:34:55',0),
	(20180201120000,'CreateUsersGroups','2019-05-21 12:34:55','2019-05-21 12:34:55',0),
	(20180201120001,'RemoveGroupIdFromUsers','2019-05-21 12:34:55','2019-05-21 12:34:55',0),
	(20180201120002,'MultipleGroupsForUser','2019-05-21 12:34:56','2019-05-21 12:34:56',0),
	(20180201120003,'MultipleGroupsCustomRoles','2019-05-21 12:34:56','2019-05-21 12:34:56',0),
	(20180201120004,'RemoveLegalUsersTable','2019-05-21 12:34:56','2019-05-21 12:34:59',0),
	(20180201120005,'RemoveBusinessUnitUsersTable','2019-05-21 12:34:59','2019-05-21 12:35:00',0),
	(20180201120006,'RemoveFieldsFromBusinessContinuitiesTable','2019-05-21 12:35:00','2019-05-21 12:35:02',0),
	(20180201120007,'RemoveFieldsFromRisksTable','2019-05-21 12:35:02','2019-05-21 12:35:03',0),
	(20180201120008,'RemoveFieldsFromThirdPartyRisksTable','2019-05-21 12:35:03','2019-05-21 12:35:05',0),
	(20180201120009,'RemoveFieldsFromBusinessContinuityPlansTable','2019-05-21 12:35:05','2019-05-21 12:35:06',0),
	(20180201120010,'RemoveFieldsFromBusinessContinuityTasksTable','2019-05-21 12:35:06','2019-05-21 12:35:06',0),
	(20180201120011,'RemoveComplianceAnalysisFindingsTables','2019-05-21 12:35:06','2019-05-21 12:35:08',0),
	(20180201120012,'RemoveComplianceExceptionsUsersTable','2019-05-21 12:35:08','2019-05-21 12:35:09',0),
	(20180201120013,'RemoveThirdPartiesUsersTable','2019-05-21 12:35:09','2019-05-21 12:35:10',0),
	(20180201120014,'RemovePolicyExceptionsUsersTable','2019-05-21 12:35:10','2019-05-21 12:35:12',0),
	(20180201120015,'RemoveUserIdFromProjectsTable','2019-05-21 12:35:12','2019-05-21 12:35:13',0),
	(20180201120016,'RemoveUserIdFromProjectAchievementsTable','2019-05-21 12:35:13','2019-05-21 12:35:15',0),
	(20180201120017,'RemoveAuthorIdFromRiskExceptionsTable','2019-05-21 12:35:15','2019-05-21 12:35:16',0),
	(20180201120018,'RemoveUserIdFromSecurityIncidentsTable','2019-05-21 12:35:16','2019-05-21 12:35:17',0),
	(20180201120019,'RemoveAuthorAndCollaboratosFromSecurityPolicies','2019-05-21 12:35:17','2019-05-21 12:35:19',0),
	(20180201120020,'RemoveServiceContractsOwnersTable','2019-05-21 12:35:19','2019-05-21 12:35:20',0),
	(20180201120021,'RemoveFieldsFromSecurityServicesTable','2019-05-21 12:35:20','2019-05-21 12:35:21',0),
	(20180201120022,'RemoveSecurityServicesUsersTable','2019-05-21 12:35:21','2019-05-21 12:35:23',0),
	(20180201120023,'RemoveFieldsFromSecurityServiceAuditsTable','2019-05-21 12:35:23','2019-05-21 12:35:24',0),
	(20180201120024,'RemoveFieldsFromSecurityServiceMaintenancesTable','2019-05-21 12:35:24','2019-05-21 12:35:26',0),
	(20180201120025,'VisualisationUserFieldsMigration','2019-05-21 12:35:26','2019-05-21 12:35:27',0),
	(20180203152011,'MigrationSystemLogs','2019-05-21 12:35:27','2019-05-21 12:35:27',0),
	(20180203161141,'MigrationVendorAssessments','2019-05-21 12:35:27','2019-05-21 12:35:28',0),
	(20180209085053,'VendorAssessmentParentMigration','2019-05-21 12:35:28','2019-05-21 12:35:28',0),
	(20180209140231,'RiskAppetiteColorPicker','2019-05-21 12:35:28','2019-05-21 12:35:28',0),
	(20180212144357,'VendorAssessmentFeedbackCompletedMigration','2019-05-21 12:35:28','2019-05-21 12:35:28',0),
	(20180214132429,'AddColumnsToRiskExceptionsTable','2019-05-21 12:35:28','2019-05-21 12:35:28',0),
	(20180214144524,'ComplianceAnalysisFindingExpiredStatus','2019-05-21 12:35:28','2019-05-21 12:35:28',0),
	(20180214162750,'RiskAppetiteColorPicker2','2019-05-21 12:35:28','2019-05-21 12:35:28',0),
	(20180215031921,'AddColumnsToComplianceExceptionsTable','2019-05-21 12:35:28','2019-05-21 12:35:29',0),
	(20180215033742,'AddColumnsToPolicyExceptionsTable','2019-05-21 12:35:29','2019-05-21 12:35:29',0),
	(20180215141504,'VendorAssessmentFindingsMigration','2019-05-21 12:35:29','2019-05-21 12:35:29',0),
	(20180216111645,'VendorAssessmentFindingsQuestionsMigration','2019-05-21 12:35:29','2019-05-21 12:35:29',0),
	(20180219143852,'VendorAssessmentQuestionWidgetMigration','2019-05-21 12:35:29','2019-05-21 12:35:29',0),
	(20180221151936,'VendorAssessmentFeedbackBlockMigration','2019-05-21 12:35:29','2019-05-21 12:35:29',0),
	(20180223163448,'VendorAssessmentVisualisationMigration','2019-05-21 12:35:29','2019-05-21 12:35:29',0),
	(20180226180509,'ReorganizeSettingGroups','2019-05-21 12:35:29','2019-05-21 12:35:29',0),
	(20180227100404,'CronErrorMessage','2019-05-21 12:35:29','2019-05-21 12:35:29',0),
	(20180228000000,'Release49','2019-05-21 12:35:29','2019-05-21 12:35:29',0),
	(20180228000001,'Release50','2019-05-21 12:35:29','2019-05-21 12:35:29',0),
	(20180301000000,'RemoveGroupIdFromUsers2','2019-05-21 12:35:29','2019-05-21 12:35:29',0),
	(20180301000001,'Release51','2019-05-21 12:35:29','2019-05-21 12:35:29',0),
	(20180305183613,'VendorAssessmentFindingCloseDate','2019-05-21 12:35:29','2019-05-21 12:35:29',0),
	(20180309000001,'Release52','2019-05-21 12:35:29','2019-05-21 12:35:29',0),
	(20180328000000,'Release53','2019-05-21 12:35:29','2019-05-21 12:35:29',0),
	(20180404105653,'AccountReviewsMigration','2019-05-21 12:35:30','2019-05-21 12:35:31',0),
	(20180405123806,'CustomFieldsMandatoryMigration','2019-05-21 12:35:31','2019-05-21 12:35:31',0),
	(20180419110700,'Release54','2019-05-21 12:35:31','2019-05-21 12:35:31',0),
	(20180419135100,'Release55','2019-05-21 12:35:31','2019-05-21 12:35:31',0),
	(20180422210000,'Release56','2019-05-21 12:35:31','2019-05-21 12:35:31',0),
	(20180424180000,'WorkflowOwnerForeignKeyRemoval','2019-05-21 12:35:31','2019-05-21 12:35:32',0),
	(20180424181500,'Release57','2019-05-21 12:35:32','2019-05-21 12:35:32',0),
	(20180426214614,'SystemLogsSubSubjectMigration','2019-05-21 12:35:32','2019-05-21 12:35:32',0),
	(20180506201149,'SecurityIncidentClosureDateMigration','2019-05-21 12:35:32','2019-05-21 12:35:32',0),
	(20180506233258,'VendorAssessmentQuestionnaireSoftDeleteMigration','2019-05-21 12:35:32','2019-05-21 12:35:32',0),
	(20180511092237,'AccountReviewFindingsMigration','2019-05-21 12:35:32','2019-05-21 12:35:32',0),
	(20180511140420,'AdvancedFiltersDescription','2019-05-21 12:35:32','2019-05-21 12:35:33',0),
	(20180514110453,'VendorAssessmentFeedbackSoftDeleteMigration','2019-05-21 12:35:33','2019-05-21 12:35:33',0),
	(20180514133802,'AuthenticationByPortalMigration','2019-05-21 12:35:33','2019-05-21 12:35:33',0),
	(20180515162400,'Release58','2019-05-21 12:35:33','2019-05-21 12:35:33',0),
	(20180517135346,'NotificationSystemUpgrade1','2019-05-21 12:35:33','2019-05-21 12:35:33',0),
	(20180518201500,'Release59','2019-05-21 12:35:33','2019-05-21 12:35:33',0),
	(20180519121931,'NotificationSystemUpgrade2','2019-05-21 12:35:33','2019-05-21 12:35:33',0),
	(20180519122256,'NotificationSystemUpgrade3','2019-05-21 12:35:33','2019-05-21 12:35:33',0),
	(20180520165152,'ConcurrentEditTable','2019-05-21 12:35:33','2019-05-21 12:35:33',0),
	(20180522135946,'NotificationSystemUpgrade4','2019-05-21 12:35:33','2019-05-21 12:35:33',0),
	(20180524094055,'NotificationSystemUpgrade5','2019-05-21 12:35:33','2019-05-21 12:35:33',0),
	(20180525082930,'NotificationSystemUpgrade6','2019-05-21 12:35:33','2019-05-21 12:35:33',0),
	(20180529164200,'Release60','2019-05-21 12:35:33','2019-05-21 12:35:33',0),
	(20180607203544,'DashboardThresholds','2019-05-21 12:35:33','2019-05-21 12:35:34',0),
	(20180607210719,'DashboardLogs','2019-05-21 12:35:34','2019-05-21 12:35:34',0),
	(20180608103716,'ServiceContractCustomFieldsMigration','2019-05-21 12:35:34','2019-05-21 12:35:34',0),
	(20180608124400,'Release61','2019-05-21 12:35:34','2019-05-21 12:35:34',0),
	(20180629095320,'BaseGroupsDescriptionMigration','2019-05-21 12:35:34','2019-05-21 12:35:34',0),
	(20180629111947,'DataAssetSettingsProcessorEmptyMigration','2019-05-21 12:35:34','2019-05-21 12:35:34',0),
	(20180702094900,'ComplianceManagementVisualisationMigration','2019-05-21 12:35:34','2019-05-21 12:35:34',0),
	(20180710163200,'Release62','2019-05-21 12:35:34','2019-05-21 12:35:34',0),
	(20180716154005,'AddGeneralGroupToSettings','2019-05-21 12:35:34','2019-05-21 12:35:34',0),
	(20180716154114,'AddPDFConfigToSettings','2019-05-21 12:35:34','2019-05-21 12:35:34',0),
	(20180717105100,'Release63','2019-05-21 12:35:34','2019-05-21 12:35:34',0),
	(20180722113400,'ServiceContractVisualisationMigration','2019-05-21 12:35:34','2019-05-21 12:35:34',0),
	(20180729182200,'OtherNewTemplateVisualisationMigration','2019-05-21 12:35:34','2019-05-21 12:35:34',0),
	(20180730074516,'ProgramSectionObjectVersion','2019-05-21 12:35:34','2019-05-21 12:35:34',0),
	(20180730122009,'TmpAttachmentsMigration','2019-05-21 12:35:34','2019-05-21 12:35:34',0),
	(20180801152846,'ReportsMigration','2019-05-21 12:35:34','2019-05-21 12:35:35',0),
	(20180806140300,'Release64','2019-05-21 12:35:35','2019-05-21 12:35:35',0),
	(20180815084812,'AdvancedFilterSystemFilter','2019-05-21 12:35:35','2019-05-21 12:35:36',0),
	(20180816093300,'Release65','2019-05-21 12:35:36','2019-05-21 12:35:36',0),
	(20180817082932,'NewTemplateSettings','2019-05-21 12:35:36','2019-05-21 12:35:36',0),
	(20180824101151,'ServiceContractTrash','2019-05-21 12:35:36','2019-05-21 12:35:36',0),
	(20180828135100,'Release66','2019-05-21 12:35:36','2019-05-21 12:35:36',0),
	(20180902095944,'UserFieldsObjectsMigration','2019-05-21 12:35:36','2019-05-21 12:35:36',0),
	(20180904134600,'QueueSettingFilterUpdate','2019-05-21 12:35:36','2019-05-21 12:35:36',0),
	(20180907144800,'AllButSettingsAclConfig','2019-05-21 12:35:36','2019-05-21 12:35:37',0),
	(20180922215900,'Release67','2019-05-21 12:35:37','2019-05-21 12:35:37',0),
	(20180927160307,'QueueRelations','2019-05-21 12:35:37','2019-05-21 12:35:37',0),
	(20180928145308,'NotificationSystemReportRelation','2019-05-21 12:35:37','2019-05-21 12:35:37',0),
	(20181014132731,'GoalAuditsSoftDeleteMigrations','2019-05-21 12:35:37','2019-05-21 12:35:37',0),
	(20181014222139,'CronTasks','2019-05-21 12:35:37','2019-05-21 12:35:37',0),
	(20181015081236,'BusinessContinuityPlanAuditSoftDeleteMigration','2019-05-21 12:35:37','2019-05-21 12:35:37',0),
	(20181015084357,'CronTasks2','2019-05-21 12:35:37','2019-05-21 12:35:37',0),
	(20181015093337,'BusinessContinuityTaskSoftDeleteMigration','2019-05-21 12:35:37','2019-05-21 12:35:37',0),
	(20181015103508,'CronTasks3','2019-05-21 12:35:37','2019-05-21 12:35:37',0),
	(20181015104030,'CronTasks4','2019-05-21 12:35:37','2019-05-21 12:35:37',0),
	(20181019092018,'CronTasks5','2019-05-21 12:35:37','2019-05-21 12:35:37',0),
	(20181024160500,'Release68','2019-05-21 12:35:37','2019-05-21 12:35:38',0),
	(20181024160501,'Release69','2019-05-21 12:35:38','2019-05-21 12:35:38',0),
	(20181024160502,'Release70','2019-05-21 12:35:38','2019-05-21 12:35:38',0),
	(20181025130700,'CompliancePackageItemVisualisationMigration','2019-05-21 12:35:38','2019-05-21 12:35:38',0),
	(20181026182944,'NotificationsFeedbackReport','2019-05-21 12:35:38','2019-05-21 12:35:38',0),
	(20181112134222,'PolicyReviewsFields','2019-05-21 12:35:38','2019-05-21 12:35:38',0),
	(20181120223330,'ChangeAuthenticationUrlInSettings','2019-05-21 12:35:38','2019-05-21 12:35:38',0),
	(20181123092504,'NotificationSystemUpgrade7','2019-05-21 12:35:38','2019-05-21 12:35:38',0),
	(20181127193239,'AddTooltipLogsTable','2019-05-21 12:35:38','2019-05-21 12:35:38',0),
	(20181128100000,'CompliancePackageItemSoftDeleteMigration','2019-05-21 12:35:38','2019-05-21 12:35:38',0),
	(20181129100000,'ReleaseNewTemplate','2019-05-21 12:35:38','2019-05-21 12:35:38',0),
	(20181129100001,'ReleaseNewTemplate2','2019-05-21 12:35:38','2019-05-21 12:36:49',0),
	(20181218144949,'MigrateUserFieldsToAssets','2019-05-21 12:36:49','2019-05-21 12:36:49',0),
	(20190103133547,'TransferMissingUserFieldsAfterYearlyCron','2019-05-21 12:36:49','2019-05-21 12:36:49',0),
	(20190117105300,'ComplianceManagementFiltesFix','2019-05-21 12:36:49','2019-05-21 12:36:49',0),
	(20190117134138,'AddDefaultPasswordFieldToUsersTable','2019-05-21 12:36:49','2019-05-21 12:36:49',0),
	(20190117185600,'Release203','2019-05-21 12:36:49','2019-05-21 12:36:50',0),
	(20190120140726,'VendorAssessmentFeedbackVisualisationMigration','2019-05-21 12:36:50','2019-05-21 12:36:50',0),
	(20190121123000,'Release204','2019-05-21 12:36:50','2019-05-21 12:36:50',0),
	(20190122111300,'Release205','2019-05-21 12:36:50','2019-05-21 12:36:50',0),
	(20190122145000,'NotificationsReportCustomRoleMigration','2019-05-21 12:36:50','2019-05-21 12:36:50',0),
	(20190123140919,'WidgetViewsMigration','2019-05-21 12:36:50','2019-05-21 12:36:50',0),
	(20190125163800,'Release206','2019-05-21 12:36:50','2019-05-21 12:36:50',0),
	(20190130150400,'ReviewWarningNotificationMigration','2019-05-21 12:36:50','2019-05-21 12:36:50',0),
	(20190130181200,'Release207','2019-05-21 12:36:50','2019-05-21 12:36:50',0),
	(20190205113333,'AddSSLOffloadToSettings','2019-05-21 12:36:50','2019-05-21 12:36:50',0),
	(20190206123645,'AttachmentFilenameMigration','2019-05-21 12:36:50','2019-05-21 12:36:50',0),
	(20190207132600,'Release208','2019-05-21 12:36:50','2019-05-21 12:36:50',0),
	(20190212131700,'Release209','2019-05-21 12:36:50','2019-05-21 12:36:50',0),
	(20190212151302,'MigrateCustomFieldDropdownOptions','2019-05-21 12:36:50','2019-05-21 12:36:50',0),
	(20190212161300,'ReviewsSystemFilterCompletedParam','2019-05-21 12:36:50','2019-05-21 12:36:50',0),
	(20190213145416,'UserSystemLogsAclMigration','2019-05-21 12:36:50','2019-05-21 12:37:16',0),
	(20190214170400,'Release2010','2019-05-21 12:37:16','2019-05-21 12:37:16',0),
	(20190218105025,'AddClientKeyToSettings','2019-05-21 12:37:16','2019-05-21 12:37:16',0),
	(20190218123700,'AddSecuritySaltSettings','2019-05-21 12:37:16','2019-05-21 12:37:16',0),
	(20190219121300,'AddCsvDelimiterSetting','2019-05-21 12:37:16','2019-05-21 12:37:16',0),
	(20190221140922,'AddNewSystemGroups','2019-05-21 12:37:16','2019-05-21 12:37:44',0),
	(20190304093520,'AppNotificationMigration','2019-05-21 12:37:44','2019-05-21 12:37:44',0),
	(20190304114446,'DashboardCalendarEventMigration','2019-05-21 12:37:44','2019-05-21 12:37:44',0),
	(20190305093500,'Release2011','2019-05-21 12:37:44','2019-05-21 12:37:44',0),
	(20190313142929,'BusinessContinuityPlanAuditVisualisationFix','2019-05-21 12:37:44','2019-05-21 12:37:44',0),
	(20190314122551,'SyncCustomFieldsSettings','2019-05-21 12:37:44','2019-05-21 12:37:46',0),
	(20190315100417,'ProgramIssueTypesMigration','2019-05-21 12:37:46','2019-05-21 12:37:46',0),
	(20190315152700,'Release2012','2019-05-21 12:37:46','2019-05-21 12:37:46',0),
	(20190321132347,'Release2013','2019-05-21 12:37:46','2019-05-21 12:37:46',0),
	(20190328085703,'AdvancedFiltersUserLimit','2019-05-21 12:37:46','2019-05-21 12:37:46',0),
	(20190329125900,'Release2014','2019-05-21 12:37:46','2019-05-21 12:37:46',0),
	(20190405132300,'Release2015','2019-05-21 12:37:46','2019-05-21 12:37:46',0),
	(20190409084345,'EditedColumn','2019-05-21 12:37:46','2019-05-21 12:37:47',0),
	(20190417134533,'AdvancedFilterUserParams','2019-05-21 12:37:47','2019-05-21 12:37:47',0),
	(20190425095300,'Release2016','2019-05-21 12:37:47','2019-05-21 12:37:48',0),
	(20190425210200,'ComplianceDefaultFilterSorting','2019-05-21 12:37:48','2019-05-21 12:37:48',0),
	(20190426140027,'AdvancedFilterUserParams2','2019-05-21 12:37:48','2019-05-21 12:37:48',0),
	(20190428182614,'ThirdPartyMigration','2019-05-21 12:37:48','2019-05-21 12:37:50',0),
	(20190429091102,'DueDateSystemFiltersFixMigration','2019-05-21 12:37:50','2019-05-21 12:37:50',0),
	(20190502150640,'ImportToolSectionFulltextIndexes','2019-05-21 12:37:50','2019-05-21 12:37:51',0),
	(20190510150621,'MigrateUserFieldsToComplianceManagements','2019-05-21 12:37:51','2019-05-21 12:37:51',0),
	(20190513154200,'Release2017','2019-05-21 12:37:51','2019-05-21 12:37:51',0),
	(20190516074334,'CreateLdapSynchronizationsTable','2019-06-11 15:17:22','2019-06-11 15:17:23',0),
	(20190516114600,'Release2018','2019-05-21 12:37:51','2019-05-21 12:37:51',0),
	(20190516153400,'Release210','2019-05-21 12:37:51','2019-05-21 12:37:51',0),
	(20190521103300,'AddCronTypeSetting','2019-06-11 15:17:23','2019-06-11 15:17:23',0),
	(20190524114500,'Release211','2019-06-11 15:17:23','2019-06-11 15:17:23',0),
	(20190527143700,'AddCronUrlSetting','2019-06-11 15:17:23','2019-06-11 15:17:23',0),
	(20190528113100,'Release212','2019-06-11 15:17:23','2019-06-11 15:17:23',0),
	(20190528130310,'AddLdapSynchronizationIdToUsersTable','2019-06-11 15:17:23','2019-06-11 15:17:23',0),
	(20190528170800,'Release220','2019-06-11 15:17:23','2019-06-11 15:17:23',0),
	(20190603112400,'RecreatedUserFieldTriggersMigration','2019-06-11 15:17:23','2019-06-11 15:17:24',0),
	(20190603130900,'Release221','2019-06-11 15:17:24','2019-06-11 15:17:24',0),
	(20190607110957,'VendorAssessmentAutoCloseMigration','2019-07-01 14:52:39','2019-07-01 14:52:39',0),
	(20190620083851,'ComplianceManagementMaintenanceFailedStatusMigration','2019-07-01 14:52:39','2019-07-01 14:52:50',0),
	(20190621150700,'Release230','2019-07-01 14:54:07','2019-07-01 14:54:11',0),
	(20190626075846,'ImportToolSectionFulltextIndexes2','2019-07-11 08:59:59','2019-07-11 09:00:01',0),
	(20190627090639,'RemoveAndMigrateUserIdInReviews','2019-07-11 09:00:01','2019-07-11 09:00:11',0),
	(20190704081541,'AccountReadyMigration','2019-07-11 09:00:11','2019-07-11 09:00:12',0),
	(20190708131405,'TranslationsMigration','2019-07-11 09:00:12','2019-07-11 09:00:12',0),
	(20190709082506,'AddRecurrenceFieldsToSecurityServicesTable','2019-07-11 09:00:12','2019-07-11 09:00:14',0),
	(20190709215800,'Release240','2019-07-11 09:00:14','2019-07-11 09:00:16',0),
	(20190715150300,'Release241','2019-08-26 05:51:56','2019-08-26 05:51:56',0),
	(20190718141256,'CustomLabelsMigration','2019-08-26 05:51:56','2019-08-26 05:51:56',0),
	(20190723092400,'Release250','2019-08-26 05:51:56','2019-08-26 05:51:56',0),
	(20190725082633,'RestoreMissingUserFieldsFromHistory','2019-08-26 05:51:56','2019-08-26 05:52:03',0),
	(20190725125853,'Release242','2019-08-26 05:52:03','2019-08-26 05:52:03',0),
	(20190729120848,'ChangeValueOfCalendarTypesBasedOnOldDates','2019-08-26 05:52:03','2019-08-26 05:52:06',0),
	(20190729123656,'Release243','2019-08-26 05:52:06','2019-08-26 05:52:06',0),
	(20190801121505,'CustomLabelsDescriptionMigration','2019-10-18 18:27:04','2019-10-18 18:27:04',0),
	(20190805120334,'AddSamlConnectorsTable','2019-10-18 18:27:04','2019-10-18 18:27:04',0),
	(20190805120739,'AddSamlConnectorIdColumn','2019-10-18 18:27:04','2019-10-18 18:27:04',0),
	(20190805161600,'Release251','2019-08-26 05:52:06','2019-08-26 05:52:06',0),
	(20190807163200,'Release252','2019-08-26 05:52:06','2019-08-26 05:52:06',0),
	(20190812123409,'VendorAssessmentsAccountReviewsUserFieldsMigration','2019-10-18 18:27:04','2019-10-18 18:27:04',0),
	(20190813124700,'Release253','2019-08-26 05:52:06','2019-08-26 05:52:06',0),
	(20190813231054,'AddUsersLdapSynchronizationsTable','2019-08-26 05:52:06','2019-08-26 05:52:06',0),
	(20190814082352,'AddLdapSyncColumnToUsersTable','2019-08-26 05:52:06','2019-08-26 05:52:07',0),
	(20190814085036,'FailedAuditsChartUpdateMigration','2019-10-18 18:27:04','2019-10-18 18:27:04',0),
	(20190814094439,'RemoveForeignKeyLdapSyncIdFromUsersTable','2019-08-26 05:52:07','2019-08-26 05:52:07',0),
	(20190815162500,'Release254','2019-08-26 05:52:07','2019-08-26 05:52:07',0),
	(20190820075126,'CreateModuleFiltersMigration','2019-10-18 18:27:04','2019-10-18 18:27:04',0),
	(20190823153300,'Release255','2019-08-26 05:52:47','2019-08-26 05:52:47',0),
	(20190826085511,'SettingDefaultCronUrlMigration','2019-10-18 18:27:04','2019-10-18 18:27:04',0),
	(20190827162400,'Release260','2019-10-18 18:27:04','2019-10-18 18:27:04',0),
	(20190906122400,'Release261','2019-10-18 18:27:04','2019-10-18 18:27:04',0),
	(20190909111500,'Release262','2019-10-18 18:27:04','2019-10-18 18:27:04',0),
	(20190911075605,'UserManagementGroupMigration','2019-10-18 18:27:04','2019-10-18 18:27:21',0),
	(20190921183800,'Release263','2019-10-18 18:27:21','2019-10-18 18:27:21',0),
	(20190921183900,'Release270','2019-10-18 18:27:21','2019-10-18 18:27:21',0),
	(20190924133549,'MappingRelationsMigration','2019-10-18 18:27:21','2019-10-18 18:27:21',0),
	(20190925155833,'MappingRelationsMigration2','2019-10-18 18:27:21','2019-10-18 18:27:21',0),
	(20191001151700,'Release264','2019-10-18 18:27:21','2019-10-18 18:27:21',0),
	(20191001153600,'Release271','2019-10-18 18:27:21','2019-10-18 18:27:21',0),
	(20191004102000,'Release272','2019-10-18 18:27:21','2019-10-18 18:27:21',0),
	(20191007142801,'WidgetStoryMigration','2019-10-18 18:27:21','2019-10-18 18:27:32',0),
	(20191008141354,'ProjectStatusCompletedMigration','2019-10-18 18:27:32','2019-10-18 18:27:32',0),
	(20191008221312,'ChangeAdvancedFilterUserParamsColumns','2019-10-18 18:27:32','2019-10-18 18:27:32',0),
	(20191015094000,'Release202','2019-05-21 12:37:51','2019-05-21 12:37:51',0),
	(20191015094001,'Release202Fix','2019-05-21 12:37:51','2019-05-21 12:37:52',0),
	(20191016114609,'MigrateAuditsAndMaintenancesForNextYear','2019-10-18 18:27:32','2019-10-18 18:27:32',0),
	(20191017120532,'NewsMigration','2019-10-18 18:27:32','2019-10-18 18:27:32',0),
	(20191017173400,'Release280','2019-10-18 18:27:32','2019-10-18 18:27:32',0),
	(20191021112700,'Release281','2019-10-21 13:30:51','2019-10-21 13:30:51',0);
ALTER TABLE `phinxlog` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `policy_exceptions` WRITE;
ALTER TABLE `policy_exceptions` DISABLE KEYS;
ALTER TABLE `policy_exceptions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `policy_exception_classifications` WRITE;
ALTER TABLE `policy_exception_classifications` DISABLE KEYS;
ALTER TABLE `policy_exception_classifications` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `policy_exceptions_security_policies` WRITE;
ALTER TABLE `policy_exceptions_security_policies` DISABLE KEYS;
ALTER TABLE `policy_exceptions_security_policies` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `policy_exceptions_third_parties` WRITE;
ALTER TABLE `policy_exceptions_third_parties` DISABLE KEYS;
ALTER TABLE `policy_exceptions_third_parties` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `policy_users` WRITE;
ALTER TABLE `policy_users` DISABLE KEYS;
ALTER TABLE `policy_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `portals` WRITE;
ALTER TABLE `portals` DISABLE KEYS;
INSERT INTO `portals` (`id`, `name`, `controller`, `created`, `modified`) VALUES 
	(1,'main','users','0000-00-00 00:00:00','0000-00-00 00:00:00'),
	(2,'vendor_assessments','vendorAssessmentFeedbacks','0000-00-00 00:00:00','0000-00-00 00:00:00'),
	(3,'account_reviews','accountReviewPortal','0000-00-00 00:00:00','0000-00-00 00:00:00');
ALTER TABLE `portals` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `processes` WRITE;
ALTER TABLE `processes` DISABLE KEYS;
ALTER TABLE `processes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `program_issues` WRITE;
ALTER TABLE `program_issues` DISABLE KEYS;
ALTER TABLE `program_issues` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `program_issue_types` WRITE;
ALTER TABLE `program_issue_types` DISABLE KEYS;
ALTER TABLE `program_issue_types` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `program_scopes` WRITE;
ALTER TABLE `program_scopes` DISABLE KEYS;
ALTER TABLE `program_scopes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `project_achievements` WRITE;
ALTER TABLE `project_achievements` DISABLE KEYS;
ALTER TABLE `project_achievements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `project_expenses` WRITE;
ALTER TABLE `project_expenses` DISABLE KEYS;
ALTER TABLE `project_expenses` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `project_overtime_graphs` WRITE;
ALTER TABLE `project_overtime_graphs` DISABLE KEYS;
ALTER TABLE `project_overtime_graphs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `project_statuses` WRITE;
ALTER TABLE `project_statuses` DISABLE KEYS;
INSERT INTO `project_statuses` (`id`, `name`) VALUES 
	(1,'Planned'),
	(2,'Ongoing'),
	(3,'Completed');
ALTER TABLE `project_statuses` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `projects` WRITE;
ALTER TABLE `projects` DISABLE KEYS;
ALTER TABLE `projects` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `projects_risks` WRITE;
ALTER TABLE `projects_risks` DISABLE KEYS;
ALTER TABLE `projects_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `projects_security_policies` WRITE;
ALTER TABLE `projects_security_policies` DISABLE KEYS;
ALTER TABLE `projects_security_policies` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `projects_security_service_audit_improvements` WRITE;
ALTER TABLE `projects_security_service_audit_improvements` DISABLE KEYS;
ALTER TABLE `projects_security_service_audit_improvements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `projects_security_services` WRITE;
ALTER TABLE `projects_security_services` DISABLE KEYS;
ALTER TABLE `projects_security_services` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `projects_third_party_risks` WRITE;
ALTER TABLE `projects_third_party_risks` DISABLE KEYS;
ALTER TABLE `projects_third_party_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `queue` WRITE;
ALTER TABLE `queue` DISABLE KEYS;
ALTER TABLE `queue` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `report_block_chart_settings` WRITE;
ALTER TABLE `report_block_chart_settings` DISABLE KEYS;
INSERT INTO `report_block_chart_settings` (`id`, `report_id`, `report_block_id`, `chart_id`, `model`, `content`, `created`, `modified`) VALUES 
	(1,1,3,1,'Asset','<h2><b>Asset and related Objects</b></h2><p>This tree shows the asset and its associated risks, compliance packages, incidents and account reviews.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(2,2,7,2,'AwarenessProgram','<h2><b>Compliance Over Time</b></h2><p>This chart shows the number of participants and compliant users for this awareness program.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(3,3,10,17,'BusinessContinuity','<h2><b>Risk Matrix (Thresholds)</b></h2><p>This chart shows risks based on their classification, the matrix includes the description and colour of thresholds.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(4,4,12,12,'BusinessContinuity','<h2><b>Risks by Tags</b></h2><p>This chart shows risks based on their assigned tags.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(5,4,13,11,'BusinessContinuity','<h2><b>Risks by Treatment Option</b></h2><p>This chart shows the amount of risks by treatment option.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(6,4,14,16,'BusinessContinuity','<h2><b>Risk Matrix (Thresholds)</b></h2><p>This chart shows risks based on their classification, the matrix includes the description and colour of thresholds.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(7,4,15,13,'BusinessContinuity','<h2><b>Risk Score and Residual over time</b></h2><p>This chart shows the amount of risk and residual over time.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(8,4,16,18,'BusinessContinuity','<h2><b>Top 20 Risk Owner</b></h2><p>The chart shows the top 20 risk owners.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(9,4,17,19,'BusinessContinuity','<h2><b>Top 20 Risk Stakeholders</b></h2><p>The chart shows the top 20 risk stakeholders.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(10,4,18,20,'BusinessContinuity','<h2><b>Accumulated Risk by Owner</b></h2><p>This chart shows risk score grouped by Risk Owner.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(11,4,19,21,'BusinessContinuity','<h2><b>Accumulated Risk by Stakeholder</b></h2><p>This chart shows risk score grouped by Risk Stakeholder.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(12,4,20,26,'Risk','<h2><b>Risks by Status</b></h2><p>This chart shows risks by their associated treatment options status, no that risks can have more than one status and therefore you might have more items in the pie than actual number of risks.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(13,4,21,27,'Risk','<h2><b>Top 10 Threats</b></h2><p>The chart shows the top 10 used threats.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(14,4,22,28,'Risk','<h2><b>Top 10 Vulnerabilities</b></h2><p>The chart shows the top 10 used vulnerabilities.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(15,4,23,29,'Risk','<h2><b>Top 10 Tags</b></h2><p>The chart shows the top 10 used tags.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(16,7,31,1,'ComplianceException','<h2><b>Top Ten Exceptions by Compliance Package</b></h2><p>This pie charts shows the top 10 compliance packages by their number of asociated exceptions.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(17,7,32,2,'ComplianceException','<h2><b>Exceptions by Duration</b></h2><p>This chart shows exceptions distributed by their duration from start to close date.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(18,8,34,3,'CompliancePackageInstance','<h2><b>Compliance by Status</b></h2><p>This chart shows for each chapter what is the intended compliance treatment.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(19,8,35,1,'CompliancePackageInstance','<h2><b>Compliance Strategy</b></h2><p>This chart shows the treatment status for each chapter on the compliance package.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(20,8,36,5,'CompliancePackageInstance','<h2><b>Top 10 Controls that failed the most Audits (by proportion)</b></h2><p>This charts looks at all controls used in a given compliance analysis package and sorts them by those that proportionally failed the most audits.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(21,8,37,6,'CompliancePackageInstance','<h2><b>Top 10 Controls that failed the most Audits (by number)</b></h2><p>This charts looks at all controls used in a given compliance analysis package and sorts them by those that failed the most audits.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(22,9,40,4,'CompliancePackageInstance','<h2><b>Compliance by Status</b></h2><p>This chart shows for each compliance package what is the intended compliance treatment</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(23,9,41,2,'CompliancePackageInstance','<h2><b>Compliance Strategy</b></h2><p>This chart shows the treatment status for each compliance package.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(24,10,44,1,'DataAssetInstance','<h2><b>Data Flow Tree</b></h2><p>This tree chart shows for a given asset all its stages, flows and mitigation controls, policies, risks and projects.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(25,12,50,1,'PolicyException','<h2><b>Top 10 Exceptions by Policy</b></h2><p>This pie charts shows the top 10 policies by their number of asociated exceptions.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(26,12,51,2,'PolicyException','<h2><b>Exceptions by Duration</b></h2><p>This chart shows exceptions distributed by their duration from start to close date.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(27,13,54,1,'Project','<h2><b>Project Relationships</b></h2><p>This chart shows what GRC elements are associated with this project.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(28,15,62,1,'RiskException','<h2><b>Top 10 Exceptions by Risk</b></h2><p>This pie charts shows the top 10 risks by their number of asociated exceptions.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(29,15,63,2,'RiskException','<h2><b>Exceptions by Duration</b></h2><p>This chart shows exceptions distributed by their duration from start to close date.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(30,16,67,2,'Risk','<h2><b>Risks and related Objects</b></h2><p>This tree shows the risks and its associated assets, third parties, vulnerabilities, threats, controls, policies and exceptions.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(31,16,69,17,'Risk','<h2><b>Risk Matrix (Thresholds)</b></h2><p>This chart shows risks based on their classification, the matrix includes the description and colour of thresholds.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(32,17,71,16,'Risk','<h2><b>Risk Matrix</b></h2><p>This chart shows risks based on their classification, the matrix includes the description and colour of thresholds.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(33,17,72,13,'Risk','<h2><b>Risk Score and Residual over time</b></h2><p>This chart shows the amount of risk and residual over time.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(34,17,73,11,'Risk','<h2><b>Risks by Treatment Option</b></h2><p>This chart shows the amount of risks by treatment option.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(35,17,74,12,'Risk','<h2><b>Risks by Tags</b></h2><p>This chart shows risks based on their assigned tags.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(36,17,75,18,'Risk','<h2><b>Top 20 Risk Owner</b></h2><p>The chart shows the top 20 risk owners.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(37,17,76,19,'Risk','<h2><b>Top 20 Risk Stakeholders</b></h2><p>The chart shows the top 20 risk stakeholders.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(38,17,77,20,'Risk','<h2><b>Accumulated Risk by Owner</b></h2><p>This chart shows risk score grouped by Risk Owner.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(39,17,78,21,'Risk','<h2><b>Accumulated Risk by Stakeholder</b></h2><p>This chart shows risk score grouped by Risk Stakeholder.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(40,17,79,26,'Risk','<h2><b>Risks by Status</b></h2><p>This chart shows risks by their associated treatment options status, no that risks can have more than one status and therefore you might have more items in the pie than actual number of risks.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(41,17,80,27,'Risk','<h2><b>Top 10 Threats</b></h2><p>The chart shows the top 10 used threats.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(42,17,81,28,'Risk','<h2><b>Top 10 Vulnerabilities</b></h2><p>The chart shows the top 10 used vulnerabilities.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(43,17,82,29,'Risk','<h2><b>Top 10 Tags</b></h2><p>The chart shows the top 10 used tags.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(44,18,85,1,'SecurityIncident','<h2><b>Incident Relationships</b></h2><p>This chart shows what GRC elements are associated with this incident.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(45,19,89,6,'SecurityPolicy','<h2><b>Related Risk Items</b></h2><p>This tree chart shows all related risk items linked.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(46,19,90,5,'SecurityPolicy','<h2><b>Related Compliance Items</b></h2><p>This tree chart shows all related compliance requirements linked to this item.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(47,19,91,1,'SecurityPolicy','<h2><b>Policies by Mitigation</b></h2><p>This ven diagram shows the proportion on how policies are used against Internal Controls, Asset Risks, Third Party Risks, Business Risks, Compliance and Data Flow Analysis.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(48,19,93,3,'SecurityPolicy','<h2><b>Policy Reviews Over Time</b></h2><p>This chart shows all policy review records over time: completed, missing and pending. It also shows the quantity based on the size of the circle.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(49,20,95,2,'SecurityPolicy','<h2><b>Policies by Mitigation</b></h2><p>This ven diagram shows the proportion on how policies are used against Internal Controls, Asset Risks, Third Party Risks, Business Risks, Compliance and Data Flow Analysis.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(50,20,96,4,'SecurityPolicy','<h2><b>Policy Reviews Over Time</b></h2><p>This chart shows all policy review records over time: completed, missing and pending. It also shows the quantity based on the size of the circle.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(51,22,101,9,'SecurityService','<h2><b>Related Policy Items</b></h2><p>This tree chart shows all related policies linked to this item.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(52,22,102,8,'SecurityService','<h2><b>Related Risk Items</b></h2><p>This tree chart shows all related risk items linked.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(53,22,103,7,'SecurityService','<h2><b>Related Compliance Items</b></h2><p>This tree chart shows all related compliance requirements linked to this item.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(54,22,104,3,'SecurityService','<h2><b>Controls by Mitigation</b></h2><p>This ven diagram shows the proportion on how controls are used against Asset Risks, Third Party Risks, Business Risks, Compliance and Data Flow Analysis.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(55,22,106,12,'SecurityService','<h2><b>Audits by Result (current calendar year)</b></h2><p>This chart shows the proportion of pass, failed and missing audits for this current year.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(56,22,107,14,'SecurityService','<h2><b>Audits by Result (past calendar year)</b></h2><p>This chart shows the proportion of pass, failed and missing audits for past year.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(57,22,108,5,'SecurityService','<h2><b>Audits Results Over Time</b></h2><p>This chart shows all audit records over time which ones failed, pass, are missing or are scheduled in the future. It also shows the quantity based on the size of the circle.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(58,23,111,4,'SecurityService','<h2><b>Controls by Mitigation</b></h2><p>This ven diagram shows the proportion on how controls are used against Asset Risks, Third Party Risks, Business Risks, Compliance and Data Flow Analysis.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(59,23,112,2,'SecurityService','<h2><b>Controls by Audit Results</b></h2><p>This pie chart shows the proportion on how controls against their testing results.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(60,23,113,13,'SecurityService','<h2><b>Audits by Result (current calendar year)</b></h2><p>This chart shows the proportion of pass, failed and missing audits for this current year.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(61,23,114,15,'SecurityService','<h2><b>Audits by Result (past calendar year)</b></h2><p>This chart shows the proportion of pass, failed and missing audits for past year.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(62,23,115,6,'SecurityService','<h2><b>Audits Results Over Time</b></h2><p>This chart shows all audit records over time which ones failed, pass, are missing or are scheduled in the future. It also shows the quantity based on the size of the circle.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(63,23,116,10,'SecurityService','<h2><b>Top 10 Fail Controls by Testing (by proportion)</b></h2><p>This chart shows the top ten controls for the last calendar year that failed the largest proportion of audits.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(64,23,117,11,'SecurityService','<h2><b>Top 10 Fail Controls by Testing (by counter)</b></h2><p>This chart shows the top ten controls for the last calendar year that failed the largest proportion of audits.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(65,24,120,3,'ThirdPartyRisk','<h2><b>Risks and related Objects</b></h2><p>This tree shows the risks and its associated assets, third parties, vulnerabilities, threats, controls, policies and exceptions.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(66,24,122,17,'ThirdPartyRisk','<h2><b>Risk Matrix (Thresholds)</b></h2><p>This chart shows risks based on their classification, the matrix includes the description and colour of thresholds.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(67,25,124,11,'ThirdPartyRisk','<h2><b>Risks by Treatment Option</b></h2><p>This chart shows the amount of risks by treatment option.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(68,25,125,12,'ThirdPartyRisk','<h2><b>Risks by Tags</b></h2></p>This chart shows risks based on their assigned tags.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(69,25,126,16,'ThirdPartyRisk','<h2><b>Risk Matrix</b></h2><p>This chart shows risks based on their classification, the matrix includes the description and colour of thresholds.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(70,25,127,13,'ThirdPartyRisk','<h2><b>Risk Score and Residual over time</b></h2><p>This chart shows the amount of risk and residual over time.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(71,25,128,18,'ThirdPartyRisk','<h2><b>Top 20 Risk Owner</b></h2><p>The chart shows the top 20 risk owners.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(72,25,129,19,'ThirdPartyRisk','<h2><b>Top 20 Risk Stakeholders</b></h2><p>The chart shows the top 20 risk stakeholders.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(73,25,130,20,'ThirdPartyRisk','<h2><b>Accumulated Risk by Owner</b></h2><p>This chart shows risk score grouped by Risk Owner.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(74,25,131,21,'ThirdPartyRisk','<h2><b>Accumulated Risk by Stakeholder</b></h2><p>This chart shows risk score grouped by Risk Stakeholder.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(75,25,132,26,'Risk','<h2><b>Risks by Status</b></h2><p>This chart shows risks by their associated treatment options status, no that risks can have more than one status and therefore you might have more items in the pie than actual number of risks.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(76,25,133,27,'Risk','<h2><b>Top 10 Threats</b></h2><p>The chart shows the top 10 used threats.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(77,25,134,28,'Risk','<h2><b>Top 10 Vulnerabilities</b></h2><p>The chart shows the top 10 used vulnerabilities.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(78,25,135,29,'Risk','<h2><b>Top 10 Tags</b></h2><p>The chart shows the top 10 used tags.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(79,26,138,1,'VendorAssessments.VendorAssessment','<h2><b>Completed Answers by Chapter</b></h2><p>Bars in the chart indicate the percentage of completed answers by chapter.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(80,26,139,3,'VendorAssessments.VendorAssessment','<h2><b>Score by Chapter (Item)</b></h2><p>This chart shows the score obtained for each chapter.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54');
ALTER TABLE `report_block_chart_settings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `report_block_filter_settings` WRITE;
ALTER TABLE `report_block_filter_settings` DISABLE KEYS;
ALTER TABLE `report_block_filter_settings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `report_block_table_settings` WRITE;
ALTER TABLE `report_block_table_settings` DISABLE KEYS;
INSERT INTO `report_block_table_settings` (`id`, `report_id`, `report_block_id`, `model`, `content`, `created`, `modified`) VALUES 
	(1,1,2,'Asset','<h2><b>Basic Attributes</b></h2><p>The table below shows general settings for this asset.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(2,1,4,'Review','<h2><b>Asset Reviews</b></h2><p>The table below shows a full list of reviews for this asset.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(3,2,6,'AwarenessProgram','<h2><b>Awareness Program Attributes</b></h2><p>The table below shows general settings for this Awareness Training.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(4,3,9,'BusinessContinuity','<h2><b>Basic Attributes</b></h2><p>The table below shows general settings for this Risk.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(5,5,25,'ComplianceAnalysisFinding','<h2><b>Basic Attributes</b></h2><p>The table below shows general settings for this Finding.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(6,5,26,'ComplianceManagement','<h2><b>Compliance Analysis Item</b></h2><p>The table below shows the items affected by this Audit finding.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(7,6,28,'ComplianceException','<h2><b>Basic Attributes</b></h2><p>The table below shows general settings for this exception.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(8,6,29,'ComplianceManagement','<h2><b>Associated Compliance Items</b></h2><p>The table below shows all compliance items related to this exception.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(9,8,38,'CompliancePackage.CompliancePackageItem.ComplianceManagement','<h2><b>Compliance Package Items</b></h2><p>The table below lists all compliance package items and their treatment settings.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(10,10,43,'DataAsset','<h2><b>Basic Attributes</b></h2><p>The table below displays basic attributes for each data flow.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(11,10,45,'DataAssetSetting','<h2><b>General GDPR Attributes</b></h2><p>The table below describes basic GDPR settings for this asset.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(12,11,47,'PolicyException','<h2><b>Basic Attributes</b></h2><p>The table below shows general settings for this policy Exception.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(13,11,48,'SecurityPolicy','<h2><b>Associated Policies with this Exception</b></h2><p>The table below shows all policies asociated with this exception.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(14,13,53,'Project','<h2><b>Basic Project Attributes</b></h2><p>The table below shows general settings for this Project.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(15,13,55,'ProjectAchievement','<h2><b>Project Task</b></h2><p>The table below shows the tasks for this project.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(16,14,57,'RiskException','<h2><b>Basic Attributes</b></h2><p>The table below shows general settings for this exception.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(17,14,58,'Risk','<h2><b>Associated Asset Risks</b></h2><p>The table below shows all associated Asset Risks for this Exception.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(18,14,59,'ThirdPartyRisk','<h2><b>Associated Third Party Risks</b></h2><p>The table below shows all associated Third Party risk for this exception.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(19,14,60,'BusinessContinuity','<h2><b>Associated Business Risks</b></h2><p>The table below shows all associated Business Risks for this exception.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(20,16,65,'Risk','<h2><b>Basic Attributes</b></h2><p>The table below shows general settings for this Risk.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(21,16,66,'Review','<h2><b>Review</b></h2><p>The table below shows all reviews for this Risk.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(22,16,68,'Risk','<h2><b>Risk Treatment</b></h2><p>The table below shows the risk treatment strategy for this risk.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(23,18,84,'SecurityIncident','<h2><b>Basic Attributes</b></h2><p>The table below shows general settings for this Incident.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(24,18,86,'SecurityIncidentStagesSecurityIncident','<h2><b>Stage Attributes</b></h2><p>The table below shows stages and status for this incident.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(25,19,88,'SecurityPolicy','<h2><b>Basic Attributes</b></h2><p>The table below shows general settings for this policy.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(26,19,92,'SecurityPolicyReview','<h2><b>Document Reviews</b></h2><p>The table below shows a list of all reviews for this document.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(27,21,98,'SecurityServiceAudit',' ','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(28,22,100,'SecurityService','<h2><b>Basic Attributes</b></h2><p>The table below shows general settings for this control.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(29,22,105,'SecurityService','<h2><b>Audit Attributes</b></h2><p>The table below shows the audit methodology and stakeholders involved in submitting evidence and analysing it.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(30,22,109,'SecurityServiceAudit','<h2><b>Audits for this Control</b></h2><p>The table below shows a list of all audit records for this control.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(31,24,119,'ThirdPartyRisk','<h2><b>Basic Attributes</b></h2><p>The table below shows general settings for this Third Party Risk.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(32,24,121,'ThirdPartyRisk','<h2><b>Risk Treatment</b></h2><p>The table below shows the treatment strategy for this risk.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(33,26,137,'VendorAssessment','<h2><b>Online Assessment Configuration</b></h2><p>This table provides an overview on the basic configurations for this assessment.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(34,26,140,'VendorAssessmentFeedback','<h2><b>Questionnaire</b></h2><p>This is a list of all questions and their feedback.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54');
ALTER TABLE `report_block_table_settings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `report_block_table_fields` WRITE;
ALTER TABLE `report_block_table_fields` DISABLE KEYS;
INSERT INTO `report_block_table_fields` (`id`, `report_block_table_setting_id`, `field`, `order`, `created`) VALUES 
	(1,1,'description',0,'2019-05-21 12:35:53'),
	(2,1,'BusinessUnit',1,'2019-05-21 12:35:53'),
	(3,1,'Legal',2,'2019-05-21 12:35:53'),
	(4,1,'asset_media_type_id',3,'2019-05-21 12:35:53'),
	(5,2,'planned_date',0,'2019-05-21 12:35:53'),
	(6,2,'actual_date',1,'2019-05-21 12:35:53'),
	(7,2,'description',2,'2019-05-21 12:35:53'),
	(8,2,'completed',3,'2019-05-21 12:35:53'),
	(9,3,'description',0,'2019-05-21 12:35:53'),
	(10,3,'recurrence',1,'2019-05-21 12:35:53'),
	(11,3,'video',2,'2019-05-21 12:35:53'),
	(12,3,'questionnaire',3,'2019-05-21 12:35:53'),
	(13,3,'status',4,'2019-05-21 12:35:53'),
	(14,3,'active_users',5,'2019-05-21 12:35:53'),
	(15,4,'description',0,'2019-05-21 12:35:53'),
	(16,4,'BusinessUnit',1,'2019-05-21 12:35:53'),
	(17,4,'Process',2,'2019-05-21 12:35:53'),
	(18,4,'Owner',3,'2019-05-21 12:35:53'),
	(19,4,'Stakeholder',4,'2019-05-21 12:35:53'),
	(20,4,'risk_score',5,'2019-05-21 12:35:53'),
	(21,4,'residual_score',6,'2019-05-21 12:35:53'),
	(22,5,'description',0,'2019-05-21 12:35:53'),
	(23,5,'due_date',1,'2019-05-21 12:35:53'),
	(24,5,'Owner',2,'2019-05-21 12:35:53'),
	(25,5,'Collaborator',3,'2019-05-21 12:35:53'),
	(26,5,'status',4,'2019-05-21 12:35:53'),
	(27,6,'package_id',0,'2019-05-21 12:35:53'),
	(28,6,'package_name',1,'2019-05-21 12:35:53'),
	(29,6,'item_id',2,'2019-05-21 12:35:53'),
	(30,6,'item_name',3,'2019-05-21 12:35:53'),
	(31,6,'item_description',4,'2019-05-21 12:35:53'),
	(32,7,'description',0,'2019-05-21 12:35:53'),
	(33,7,'expiration',1,'2019-05-21 12:35:53'),
	(34,7,'closure_date',2,'2019-05-21 12:35:53'),
	(35,7,'Requestor',3,'2019-05-21 12:35:53'),
	(36,7,'status',4,'2019-05-21 12:35:53'),
	(37,8,'item_id',0,'2019-05-21 12:35:53'),
	(38,8,'item_name',1,'2019-05-21 12:35:53'),
	(39,8,'item_description',2,'2019-05-21 12:35:53'),
	(40,9,'item_id',0,'2019-05-21 12:35:53'),
	(41,9,'item_name',1,'2019-05-21 12:35:53'),
	(42,9,'owner_id',2,'2019-05-21 12:35:53'),
	(43,9,'SecurityService',3,'2019-05-21 12:35:53'),
	(44,9,'SecurityPolicy',4,'2019-05-21 12:35:53'),
	(45,9,'Project',5,'2019-05-21 12:35:53'),
	(46,10,'data_asset_status_id',0,'2019-05-21 12:35:53'),
	(47,10,'title',1,'2019-05-21 12:35:53'),
	(48,10,'BusinessUnit',2,'2019-05-21 12:35:53'),
	(49,10,'ThirdParty',3,'2019-05-21 12:35:53'),
	(50,10,'SecurityService',4,'2019-05-21 12:35:53'),
	(51,10,'SecurityPolicy',5,'2019-05-21 12:35:53'),
	(52,10,'Project',6,'2019-05-21 12:35:53'),
	(53,11,'gdpr_enabled',0,'2019-05-21 12:35:53'),
	(54,11,'driver_for_compliance',1,'2019-05-21 12:35:53'),
	(55,11,'DataOwner',2,'2019-05-21 12:35:53'),
	(56,11,'Dpo',3,'2019-05-21 12:35:53'),
	(57,11,'Processor',4,'2019-05-21 12:35:53'),
	(58,11,'Controller',5,'2019-05-21 12:35:53'),
	(59,11,'ControllerRepresentative',6,'2019-05-21 12:35:53'),
	(60,11,'SupervisoryAuthority',7,'2019-05-21 12:35:53'),
	(61,12,'description',0,'2019-05-21 12:35:53'),
	(62,12,'expiration',1,'2019-05-21 12:35:53'),
	(63,12,'closure_date',2,'2019-05-21 12:35:53'),
	(64,12,'Requestor',3,'2019-05-21 12:35:53'),
	(65,12,'status',4,'2019-05-21 12:35:53'),
	(66,13,'index',0,'2019-05-21 12:35:53'),
	(67,13,'version',1,'2019-05-21 12:35:53'),
	(68,13,'published_date',2,'2019-05-21 12:35:53'),
	(69,13,'Owner',3,'2019-05-21 12:35:53'),
	(70,14,'goal',0,'2019-05-21 12:35:53'),
	(71,14,'start',1,'2019-05-21 12:35:53'),
	(72,14,'deadline',2,'2019-05-21 12:35:53'),
	(73,14,'plan_budget',3,'2019-05-21 12:35:53'),
	(74,14,'Owner',4,'2019-05-21 12:35:53'),
	(75,14,'project_status_id',5,'2019-05-21 12:35:53'),
	(76,15,'task_order',0,'2019-05-21 12:35:53'),
	(77,15,'description',1,'2019-05-21 12:35:53'),
	(78,15,'date',2,'2019-05-21 12:35:53'),
	(79,15,'completion',3,'2019-05-21 12:35:53'),
	(80,15,'TaskOwner',4,'2019-05-21 12:35:53'),
	(81,16,'description',0,'2019-05-21 12:35:53'),
	(82,16,'expiration',1,'2019-05-21 12:35:53'),
	(83,16,'closure_date',2,'2019-05-21 12:35:53'),
	(84,16,'Requestor',3,'2019-05-21 12:35:53'),
	(85,16,'status',4,'2019-05-21 12:35:53'),
	(86,17,'title',0,'2019-05-21 12:35:53'),
	(87,17,'description',1,'2019-05-21 12:35:53'),
	(88,17,'residual_score',2,'2019-05-21 12:35:53'),
	(89,18,'title',0,'2019-05-21 12:35:53'),
	(90,18,'description',1,'2019-05-21 12:35:53'),
	(91,18,'residual_score',2,'2019-05-21 12:35:53'),
	(92,19,'title',0,'2019-05-21 12:35:53'),
	(93,19,'description',1,'2019-05-21 12:35:53'),
	(94,19,'risk_score',2,'2019-05-21 12:35:53'),
	(95,20,'description',0,'2019-05-21 12:35:53'),
	(96,20,'Asset',1,'2019-05-21 12:35:53'),
	(97,20,'Owner',2,'2019-05-21 12:35:53'),
	(98,20,'Stakeholder',3,'2019-05-21 12:35:53'),
	(99,20,'risk_score',4,'2019-05-21 12:35:53'),
	(100,20,'residual_score',5,'2019-05-21 12:35:54'),
	(101,21,'planned_date',0,'2019-05-21 12:35:54'),
	(102,21,'actual_date',1,'2019-05-21 12:35:54'),
	(103,21,'description',2,'2019-05-21 12:35:54'),
	(104,21,'description',3,'2019-05-21 12:35:54'),
	(105,21,'user_id',4,'2019-05-21 12:35:54'),
	(106,22,'risk_mitigation_strategy_id',0,'2019-05-21 12:35:54'),
	(107,22,'SecurityService',1,'2019-05-21 12:35:54'),
	(108,22,'SecurityPolicyTreatment',2,'2019-05-21 12:35:54'),
	(109,22,'Project',3,'2019-05-21 12:35:54'),
	(110,22,'RiskException',4,'2019-05-21 12:35:54'),
	(111,23,'type',0,'2019-05-21 12:35:54'),
	(112,23,'description',1,'2019-05-21 12:35:54'),
	(113,23,'open_date',2,'2019-05-21 12:35:54'),
	(114,23,'closure_date',3,'2019-05-21 12:35:54'),
	(115,23,'reporter',4,'2019-05-21 12:35:54'),
	(116,23,'victim',5,'2019-05-21 12:35:54'),
	(117,24,'stage_name',0,'2019-05-21 12:35:54'),
	(118,24,'stage_description',1,'2019-05-21 12:35:54'),
	(119,24,'status',2,'2019-05-21 12:35:54'),
	(120,25,'short_description',0,'2019-05-21 12:35:54'),
	(121,25,'published_date',1,'2019-05-21 12:35:54'),
	(122,25,'version',2,'2019-05-21 12:35:54'),
	(123,25,'Owner',3,'2019-05-21 12:35:54'),
	(124,25,'Collaborator',4,'2019-05-21 12:35:54'),
	(125,26,'planned_date',0,'2019-05-21 12:35:54'),
	(126,26,'actual_date',1,'2019-05-21 12:35:54'),
	(127,26,'description',2,'2019-05-21 12:35:54'),
	(128,26,'version',3,'2019-05-21 12:35:54'),
	(129,26,'use_attachments',4,'2019-05-21 12:35:54'),
	(130,27,'audit_metric_description',0,'2019-05-21 12:35:54'),
	(131,27,'audit_success_criteria',1,'2019-05-21 12:35:54'),
	(132,27,'result_description',2,'2019-05-21 12:35:54'),
	(133,27,'result',3,'2019-05-21 12:35:54'),
	(134,28,'objective',0,'2019-05-21 12:35:54'),
	(135,28,'ServiceOwner',1,'2019-05-21 12:35:54'),
	(136,28,'Collaborator',2,'2019-05-21 12:35:54'),
	(137,28,'SecurityPolicy',3,'2019-05-21 12:35:54'),
	(138,29,'audit_metric_description',0,'2019-05-21 12:35:54'),
	(139,29,'audit_success_criteria',1,'2019-05-21 12:35:54'),
	(140,29,'AuditEvidenceOwner',2,'2019-05-21 12:35:54'),
	(141,29,'AuditOwner',3,'2019-05-21 12:35:54'),
	(142,30,'audit_metric_description',0,'2019-05-21 12:35:54'),
	(143,30,'audit_success_criteria',1,'2019-05-21 12:35:54'),
	(144,30,'result',2,'2019-05-21 12:35:54'),
	(145,30,'result_description',3,'2019-05-21 12:35:54'),
	(146,30,'planned_date',4,'2019-05-21 12:35:54'),
	(147,30,'end_date',5,'2019-05-21 12:35:54'),
	(148,31,'description',0,'2019-05-21 12:35:54'),
	(149,31,'Asset',1,'2019-05-21 12:35:54'),
	(150,31,'ThirdParty',2,'2019-05-21 12:35:54'),
	(151,31,'Owner',3,'2019-05-21 12:35:54'),
	(152,31,'Stakeholder',4,'2019-05-21 12:35:54'),
	(153,31,'risk_score',5,'2019-05-21 12:35:54'),
	(154,31,'residual_score',6,'2019-05-21 12:35:54'),
	(155,32,'risk_mitigation_strategy_id',0,'2019-05-21 12:35:54'),
	(156,32,'SecurityService',1,'2019-05-21 12:35:54'),
	(157,32,'SecurityPolicyTreatment',2,'2019-05-21 12:35:54'),
	(158,32,'Project',3,'2019-05-21 12:35:54'),
	(159,32,'RiskException',4,'2019-05-21 12:35:54'),
	(160,33,'description',0,'2019-05-21 12:35:54'),
	(161,33,'start_date',1,'2019-05-21 12:35:54'),
	(162,33,'end_date',2,'2019-05-21 12:35:54'),
	(163,33,'recurrence_period',3,'2019-05-21 12:35:54'),
	(164,33,'Auditor',4,'2019-05-21 12:35:54'),
	(165,33,'Auditee',5,'2019-05-21 12:35:54'),
	(166,33,'vendor_assessment_questionnaire_id',6,'2019-05-21 12:35:54'),
	(167,34,'vendor_assessment_id',0,'2019-05-21 12:35:54'),
	(168,34,'vendor_assessment_question_id',1,'2019-05-21 12:35:54'),
	(169,34,'ObjectStatus_completed',2,'2019-05-21 12:35:54'),
	(170,34,'ObjectStatus_not_completed',3,'2019-05-21 12:35:54'),
	(171,34,'vendor_assessment_option_id',4,'2019-05-21 12:35:54'),
	(172,34,'answer',5,'2019-05-21 12:35:54');
ALTER TABLE `report_block_table_fields` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `report_block_text_settings` WRITE;
ALTER TABLE `report_block_text_settings` DISABLE KEYS;
INSERT INTO `report_block_text_settings` (`id`, `report_id`, `report_block_id`, `content`, `created`, `modified`) VALUES 
	(1,1,1,'<h1><b>Asset Report: %ASSET_NAME%</b></h1><p>This report describes general attributes for this asset.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(2,2,5,'<h1><b>Awareness Report: %AWARENESSPROGRAM_TITLE%</b></h1><p>This report describes general attributes for this Awareness Training.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(3,3,8,'<h1><b>Business Risk Report: %BUSINESSCONTINUITY_TITLE%</b></h1><p>This report describes general attributes for this Business Risk.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(4,4,11,'<h1><b>Business Risk Summary</b></h1><p>This report describes general attributes for all Business Risks in the scope of this GRC program.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(5,5,24,'<h1><b>Compliance Analysis Finding Report: %COMPLIANCEANALYSISFINDING_TITLE%</b></h1><p>This report describes general attributes for this Compliance Audit Finding.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(6,6,27,'<h1><b>Compliance Exception Report: %COMPLIANCEEXCEPTION_TITLE%</b></h1><p>This report describes general attributes for this exception.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(7,7,30,'<h1><b>Compliance Exception Summary</b></h1>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(8,8,33,'<h1><b>Compliance Analysis Report: %COMPLIANCEPACKAGEINSTANCE_NAME%</b></h1><p>This report describes general attributes for this Compliance Package.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(9,9,39,'<h1><b>Compliance Analysis Summary</b></h1><p>This report describes general attributes for all Compliance Packages in the scope of this GRC program.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(10,10,42,'<h1><b>Data Flow Basic Report: %DATAASSETINSTANCE_ASSET_ID%</b></h1><p>This report describes general attributes for this asset data flow.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(11,11,46,'<h1><b>Policy Exception Report: %POLICYEXCEPTION_TITLE%</b></h1><p>This report describes general attributes for this policy exception.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(12,12,49,'<h1><b>Policy Exception Summary</b></h1>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(13,13,52,'<h1><b>Project Report: %PROJECT_TITLE%</b></h1><p>This report describes general attributes for this Project.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(14,14,56,'<h1><b>Risk Exception Report: %RISKEXCEPTION_TITLE%</b></h1><p>This report describes general attributes for this Risk Exception.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(15,15,61,'<h1><b>Risk Exception Summary</b></h1>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(16,16,64,'<h1><b>Asset Risk Report: %RISK_TITLE%</b></h1><p>This report describes general attributes for this Risk.</p>','2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(17,17,70,'<h1><b>Asset Risk Summary</b></h1><p>This report describes general attributes for all Asset Risks in the scope of this GRC program.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(18,18,83,'<h1><b>Incident Report: %SECURITYINCIDENT_TITLE%</b></h1><p>This report describes general attributes for this Incident.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(19,19,87,'<h1><b>Security Policy Report: %SECURITYPOLICY_TITLE%</b></h1><p>This report general attributes for this policy.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(20,20,94,'<h1><b>Policies Summary</b></h1><p>This report describes general attributes for all policies in the scope of this GRC program.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(21,21,97,'<h1><b>Control Audit Report: %INTERNAL_CONTROL_NAME%</b></h1><p>This is the report for the testing planned for the date %SECURITYSERVICEAUDIT_PLANNED_DATE% which started on %SECURITYSERVICEAUDIT_START_DATE% and finished on %SECURITYSERVICEAUDIT_END_DATE%.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(22,22,99,'<h1><b>Internal Control Report: %INTERNAL_CONTROL_NAME%</b></h1><p>This report describes general attributes for this control.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(23,23,110,'<h1><b>Internal Controls Summary</b></h1><p>This report describes general attributes for all controls in the scope of this GRC program.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(24,24,118,'<h1><b>Third Party Risk Report: %THIRDPARTYRISK_TITLE%</b></h1><p>This report describes general attributes for this Third Party Risk.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(25,25,123,'<h1><b>Third Party Risk Summary</b></h1><p>This report describes general attributes for all Third Party Risks in the scope of this GRC program.</p>','2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(26,26,136,'<h1><b>Online Assessment Report: %ONLINE_ASSESSMENT_TITLE%</b></h1><p>This report provides an summary overview for this online assessment. At this moment the questionnaire status is: <b><font color="#ff0000">%ONLINE_ASSESSMENT_STATUS%</font></b></p>','2019-05-21 12:35:54','2019-05-21 12:35:54');
ALTER TABLE `report_block_text_settings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `report_templates` WRITE;
ALTER TABLE `report_templates` DISABLE KEYS;
INSERT INTO `report_templates` (`id`, `name`, `type`, `format`, `created`, `modified`) VALUES 
	(1,'System Report Template - Item',2,1,'2019-05-21 12:35:52','2019-05-21 12:35:52'),
	(2,'System Report Template - Item',2,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(3,'System Report Template - Item',2,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(4,'System Report Template - Section',1,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(5,'System Report Template - Item',2,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(6,'System Report Template - Item',2,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(7,'System Report Template - Section',1,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(8,'System Report Template - Item',2,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(9,'System Report Template - Section',1,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(10,'System Report Template - Item',2,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(11,'System Report Template - Item',2,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(12,'System Report Template - Section',1,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(13,'System Report Template - Item',2,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(14,'System Report Template - Item',2,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(15,'System Report Template - Section',1,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(16,'System Report Template - Item',2,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(17,'System Report Template - Section',1,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(18,'System Report Template - Item',2,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(19,'System Report Template - Item',2,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(20,'System Report Template - Section',1,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(21,'System Report Template - Item',2,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(22,'System Report Template - Item',2,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(23,'System Report Template - Section',1,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(24,'System Report Template - Item',2,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(25,'System Report Template - Section',1,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(26,'System Report Template - Item',2,1,'2019-05-21 12:35:54','2019-05-21 12:35:54');
ALTER TABLE `report_templates` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `report_blocks` WRITE;
ALTER TABLE `report_blocks` DISABLE KEYS;
INSERT INTO `report_blocks` (`id`, `report_template_id`, `parent_id`, `type`, `design`, `size`, `order`, `created`, `modified`) VALUES 
	(1,1,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(2,1,NULL,3,1,12,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(3,1,NULL,5,1,12,2,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(4,1,NULL,3,1,12,3,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(5,2,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(6,2,NULL,3,1,12,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(7,2,NULL,5,1,12,2,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(8,3,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(9,3,NULL,3,1,12,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(10,3,NULL,5,1,12,2,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(11,4,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(12,4,NULL,5,1,6,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(13,4,NULL,5,1,6,2,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(14,4,NULL,5,1,12,3,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(15,4,NULL,5,1,12,4,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(16,4,NULL,5,1,6,5,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(17,4,NULL,5,1,6,6,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(18,4,NULL,5,1,12,7,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(19,4,NULL,5,1,12,8,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(20,4,NULL,5,1,6,9,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(21,4,NULL,5,1,6,10,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(22,4,NULL,5,1,6,11,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(23,4,NULL,5,1,6,12,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(24,5,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(25,5,NULL,3,1,12,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(26,5,NULL,3,1,12,2,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(27,6,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(28,6,NULL,3,1,12,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(29,6,NULL,3,1,12,2,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(30,7,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(31,7,NULL,5,1,6,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(32,7,NULL,5,1,12,2,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(33,8,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(34,8,NULL,5,1,12,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(35,8,NULL,5,1,12,2,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(36,8,NULL,5,1,12,3,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(37,8,NULL,5,1,12,4,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(38,8,NULL,3,1,12,5,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(39,9,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(40,9,NULL,5,1,12,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(41,9,NULL,5,1,12,2,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(42,10,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(43,10,NULL,3,1,12,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(44,10,NULL,5,1,12,2,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(45,10,NULL,3,1,12,3,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(46,11,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(47,11,NULL,3,1,12,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(48,11,NULL,3,1,12,2,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(49,12,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(50,12,NULL,5,1,6,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(51,12,NULL,5,1,12,2,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(52,13,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(53,13,NULL,3,1,12,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(54,13,NULL,5,1,12,2,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(55,13,NULL,3,1,12,3,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(56,14,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(57,14,NULL,3,1,12,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(58,14,NULL,3,1,12,2,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(59,14,NULL,3,1,12,3,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(60,14,NULL,3,1,12,4,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(61,15,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(62,15,NULL,5,1,6,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(63,15,NULL,5,1,12,2,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(64,16,NULL,2,1,12,0,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(65,16,NULL,3,1,12,1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(66,16,NULL,3,1,12,2,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(67,16,NULL,5,1,12,3,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(68,16,NULL,3,1,12,4,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(69,16,NULL,5,1,12,5,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(70,17,NULL,2,1,12,0,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(71,17,NULL,5,1,12,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(72,17,NULL,5,1,12,2,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(73,17,NULL,5,1,6,3,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(74,17,NULL,5,1,6,4,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(75,17,NULL,5,1,6,5,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(76,17,NULL,5,1,6,6,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(77,17,NULL,5,1,12,7,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(78,17,NULL,5,1,12,8,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(79,17,NULL,5,1,6,9,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(80,17,NULL,5,1,6,10,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(81,17,NULL,5,1,6,11,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(82,17,NULL,5,1,6,12,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(83,18,NULL,2,1,12,0,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(84,18,NULL,3,1,12,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(85,18,NULL,5,1,12,2,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(86,18,NULL,3,1,12,3,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(87,19,NULL,2,1,12,0,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(88,19,NULL,3,1,12,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(89,19,NULL,5,1,12,2,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(90,19,NULL,5,1,12,3,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(91,19,NULL,5,1,12,4,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(92,19,NULL,3,1,12,5,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(93,19,NULL,5,1,12,6,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(94,20,NULL,2,1,12,0,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(95,20,NULL,5,1,12,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(96,20,NULL,5,1,12,2,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(97,21,NULL,2,1,12,0,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(98,21,NULL,3,1,12,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(99,22,NULL,2,1,12,0,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(100,22,NULL,3,1,12,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(101,22,NULL,5,1,12,2,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(102,22,NULL,5,1,12,3,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(103,22,NULL,5,1,12,4,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(104,22,NULL,5,1,12,5,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(105,22,NULL,3,1,12,6,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(106,22,NULL,5,1,6,7,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(107,22,NULL,5,1,6,8,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(108,22,NULL,5,1,12,9,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(109,22,NULL,3,1,12,10,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(110,23,NULL,2,1,12,0,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(111,23,NULL,5,1,6,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(112,23,NULL,5,1,6,2,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(113,23,NULL,5,1,6,3,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(114,23,NULL,5,1,6,4,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(115,23,NULL,5,1,12,5,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(116,23,NULL,5,1,12,6,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(117,23,NULL,5,1,12,7,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(118,24,NULL,2,1,12,0,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(119,24,NULL,3,1,12,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(120,24,NULL,5,1,12,2,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(121,24,NULL,3,1,12,3,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(122,24,NULL,5,1,12,4,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(123,25,NULL,2,1,12,0,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(124,25,NULL,5,1,6,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(125,25,NULL,5,1,6,2,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(126,25,NULL,5,1,12,3,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(127,25,NULL,5,1,12,4,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(128,25,NULL,5,1,6,5,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(129,25,NULL,5,1,6,6,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(130,25,NULL,5,1,12,7,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(131,25,NULL,5,1,12,8,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(132,25,NULL,5,1,6,9,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(133,25,NULL,5,1,6,10,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(134,25,NULL,5,1,6,11,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(135,25,NULL,5,1,6,12,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(136,26,NULL,2,1,12,0,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(137,26,NULL,3,1,12,1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(138,26,NULL,5,1,12,2,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(139,26,NULL,5,1,12,3,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(140,26,NULL,3,1,12,4,'2019-05-21 12:35:54','2019-05-21 12:35:54');
ALTER TABLE `report_blocks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `reports` WRITE;
ALTER TABLE `reports` DISABLE KEYS;
INSERT INTO `reports` (`id`, `report_template_id`, `slug`, `model`, `foreign_key`, `name`, `protected`, `created`, `modified`) VALUES 
	(1,1,'asset-item-default-report','Asset',NULL,'System Report - Item',1,'2019-05-21 12:35:52','2019-05-21 12:35:52'),
	(2,2,'awareness-program-item-default-report','AwarenessProgram',NULL,'System Report - Item',1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(3,3,'business-continuity-item-default-report','BusinessContinuity',NULL,'System Report - Item',1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(4,4,'business-continuity-section-default-report','BusinessContinuity',NULL,'System Report - Section',1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(5,5,'compliance-analysis-finding-item-default-report','ComplianceAnalysisFinding',NULL,'System Report - Item',1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(6,6,'compliance-exception-item-default-report','ComplianceException',NULL,'System Report - Item',1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(7,7,'compliance-exception-section-default-report','ComplianceException',NULL,'System Report - Section',1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(8,8,'compliance-package-instance-item-default-report','CompliancePackageInstance',NULL,'System Report - Item',1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(9,9,'compliance-package-instance-section-default-report','CompliancePackageInstance',NULL,'System Report - Section',1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(10,10,'data-asset-instance-item-default-report','DataAssetInstance',NULL,'System Report - Item',1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(11,11,'policy-exception-item-default-report','PolicyException',NULL,'System Report - Item',1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(12,12,'policy-exception-section-default-report','PolicyException',NULL,'System Report - Section',1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(13,13,'project-item-default-report','Project',NULL,'System Report - Item',1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(14,14,'risk-exception-item-default-report','RiskException',NULL,'System Report - Item',1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(15,15,'risk-exception-section-default-report','RiskException',NULL,'System Report - Section',1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(16,16,'risk-item-default-report','Risk',NULL,'System Report - Item',1,'2019-05-21 12:35:53','2019-05-21 12:35:53'),
	(17,17,'risk-section-default-report','Risk',NULL,'System Report - Section',1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(18,18,'security-incident-item-default-report','SecurityIncident',NULL,'System Report - Item',1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(19,19,'security-policy-item-default-report','SecurityPolicy',NULL,'System Report - Item',1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(20,20,'security-policy-section-default-report','SecurityPolicy',NULL,'System Report - Section',1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(21,21,'security-service-audit-item-default-report','SecurityServiceAudit',NULL,'System Report - Item',1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(22,22,'security-service-item-default-report','SecurityService',NULL,'System Report - Item',1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(23,23,'security-service-section-default-report','SecurityService',NULL,'System Report - Section',1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(24,24,'third-party-risk-item-default-report','ThirdPartyRisk',NULL,'System Report - Item',1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(25,25,'third-party-risk-section-default-report','ThirdPartyRisk',NULL,'System Report - Section',1,'2019-05-21 12:35:54','2019-05-21 12:35:54'),
	(26,26,'vendor-assessment-item-default-report','VendorAssessments.VendorAssessment',NULL,'System Report - Item',1,'2019-05-21 12:35:54','2019-05-21 12:35:54');
ALTER TABLE `reports` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `reviews` WRITE;
ALTER TABLE `reviews` DISABLE KEYS;
ALTER TABLE `reviews` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_appetite_thresholds` WRITE;
ALTER TABLE `risk_appetite_thresholds` DISABLE KEYS;
ALTER TABLE `risk_appetite_thresholds` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_appetite_threshold_risk_classifications` WRITE;
ALTER TABLE `risk_appetite_threshold_risk_classifications` DISABLE KEYS;
ALTER TABLE `risk_appetite_threshold_risk_classifications` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_appetite_thresholds_risks` WRITE;
ALTER TABLE `risk_appetite_thresholds_risks` DISABLE KEYS;
ALTER TABLE `risk_appetite_thresholds_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_appetites` WRITE;
ALTER TABLE `risk_appetites` DISABLE KEYS;
INSERT INTO `risk_appetites` (`id`, `method`, `modified`) VALUES 
	(1,0,'2019-05-21 12:34:53');
ALTER TABLE `risk_appetites` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_classification_types` WRITE;
ALTER TABLE `risk_classification_types` DISABLE KEYS;
ALTER TABLE `risk_classification_types` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_appetites_risk_classification_types` WRITE;
ALTER TABLE `risk_appetites_risk_classification_types` DISABLE KEYS;
ALTER TABLE `risk_appetites_risk_classification_types` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_calculations` WRITE;
ALTER TABLE `risk_calculations` DISABLE KEYS;
INSERT INTO `risk_calculations` (`id`, `model`, `method`, `modified`) VALUES 
	(1,'Risk','eramba','2016-11-18 14:38:23'),
	(2,'ThirdPartyRisk','eramba','2016-11-18 14:38:23'),
	(3,'BusinessContinuity','eramba','2016-11-18 14:38:23');
ALTER TABLE `risk_calculations` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_calculation_values` WRITE;
ALTER TABLE `risk_calculation_values` DISABLE KEYS;
ALTER TABLE `risk_calculation_values` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_classifications` WRITE;
ALTER TABLE `risk_classifications` DISABLE KEYS;
ALTER TABLE `risk_classifications` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_classifications_risks` WRITE;
ALTER TABLE `risk_classifications_risks` DISABLE KEYS;
ALTER TABLE `risk_classifications_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_classifications_third_party_risks` WRITE;
ALTER TABLE `risk_classifications_third_party_risks` DISABLE KEYS;
ALTER TABLE `risk_classifications_third_party_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_exceptions` WRITE;
ALTER TABLE `risk_exceptions` DISABLE KEYS;
ALTER TABLE `risk_exceptions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_exceptions_risks` WRITE;
ALTER TABLE `risk_exceptions_risks` DISABLE KEYS;
ALTER TABLE `risk_exceptions_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_exceptions_third_party_risks` WRITE;
ALTER TABLE `risk_exceptions_third_party_risks` DISABLE KEYS;
ALTER TABLE `risk_exceptions_third_party_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_mitigation_strategies` WRITE;
ALTER TABLE `risk_mitigation_strategies` DISABLE KEYS;
INSERT INTO `risk_mitigation_strategies` (`id`, `name`) VALUES 
	(1,'Accept'),
	(2,'Avoid'),
	(3,'Mitigate'),
	(4,'Transfer');
ALTER TABLE `risk_mitigation_strategies` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risk_overtime_graphs` WRITE;
ALTER TABLE `risk_overtime_graphs` DISABLE KEYS;
ALTER TABLE `risk_overtime_graphs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risks` WRITE;
ALTER TABLE `risks` DISABLE KEYS;
ALTER TABLE `risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risks_security_incidents` WRITE;
ALTER TABLE `risks_security_incidents` DISABLE KEYS;
ALTER TABLE `risks_security_incidents` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risks_security_policies` WRITE;
ALTER TABLE `risks_security_policies` DISABLE KEYS;
ALTER TABLE `risks_security_policies` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risks_security_services` WRITE;
ALTER TABLE `risks_security_services` DISABLE KEYS;
ALTER TABLE `risks_security_services` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risks_threats` WRITE;
ALTER TABLE `risks_threats` DISABLE KEYS;
ALTER TABLE `risks_threats` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `risks_vulnerabilities` WRITE;
ALTER TABLE `risks_vulnerabilities` DISABLE KEYS;
ALTER TABLE `risks_vulnerabilities` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `saml_connectors` WRITE;
ALTER TABLE `saml_connectors` DISABLE KEYS;
ALTER TABLE `saml_connectors` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `schema_migrations` WRITE;
ALTER TABLE `schema_migrations` DISABLE KEYS;
INSERT INTO `schema_migrations` (`id`, `class`, `type`, `created`) VALUES 
	(1,'InitMigrations','Migrations','2016-01-17 20:45:25'),
	(2,'ConvertVersionToClassNames','Migrations','2016-01-17 20:45:25'),
	(3,'IncreaseClassNameLength','Migrations','2016-01-17 20:45:25'),
	(4,'E101000','app','2016-01-17 20:47:16'),
	(5,'E101001','app','2016-11-18 14:34:44'),
	(6,'E101002','app','2016-11-18 14:38:23'),
	(7,'E101003','app','2016-11-18 14:39:17'),
	(8,'E101004','app','2016-11-18 14:39:23'),
	(9,'E101005','app','2016-11-18 14:40:22'),
	(10,'E101006','app','2016-11-18 14:40:47'),
	(11,'E101007','app','2016-11-18 14:42:46'),
	(12,'E101008','app','2016-11-18 14:47:11'),
	(13,'E101009','app','2016-11-18 14:48:32'),
	(14,'E101010','app','2017-02-22 21:32:29'),
	(15,'E101011','app','2017-02-22 21:32:35'),
	(16,'E101012','app','2017-02-22 21:32:37'),
	(17,'E101013','app','2017-02-22 21:32:39'),
	(18,'E101014','app','2017-02-22 21:32:39'),
	(19,'E101015','app','2017-02-22 21:32:40'),
	(20,'E101016','app','2017-02-22 21:32:40');
ALTER TABLE `schema_migrations` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `scopes` WRITE;
ALTER TABLE `scopes` DISABLE KEYS;
ALTER TABLE `scopes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `sections` WRITE;
ALTER TABLE `sections` DISABLE KEYS;
ALTER TABLE `sections` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_incident_classifications` WRITE;
ALTER TABLE `security_incident_classifications` DISABLE KEYS;
ALTER TABLE `security_incident_classifications` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_incident_stages` WRITE;
ALTER TABLE `security_incident_stages` DISABLE KEYS;
ALTER TABLE `security_incident_stages` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_incident_stages_security_incidents` WRITE;
ALTER TABLE `security_incident_stages_security_incidents` DISABLE KEYS;
ALTER TABLE `security_incident_stages_security_incidents` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_incident_statuses` WRITE;
ALTER TABLE `security_incident_statuses` DISABLE KEYS;
INSERT INTO `security_incident_statuses` (`id`, `name`) VALUES 
	(2,'Ongoing'),
	(3,'Closed');
ALTER TABLE `security_incident_statuses` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_incidents` WRITE;
ALTER TABLE `security_incidents` DISABLE KEYS;
ALTER TABLE `security_incidents` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_incidents_security_service_audit_improvements` WRITE;
ALTER TABLE `security_incidents_security_service_audit_improvements` DISABLE KEYS;
ALTER TABLE `security_incidents_security_service_audit_improvements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_incidents_security_services` WRITE;
ALTER TABLE `security_incidents_security_services` DISABLE KEYS;
ALTER TABLE `security_incidents_security_services` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_incidents_third_parties` WRITE;
ALTER TABLE `security_incidents_third_parties` DISABLE KEYS;
ALTER TABLE `security_incidents_third_parties` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_policies` WRITE;
ALTER TABLE `security_policies` DISABLE KEYS;
ALTER TABLE `security_policies` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_policies_related` WRITE;
ALTER TABLE `security_policies_related` DISABLE KEYS;
ALTER TABLE `security_policies_related` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_policies_security_services` WRITE;
ALTER TABLE `security_policies_security_services` DISABLE KEYS;
ALTER TABLE `security_policies_security_services` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_policy_document_types` WRITE;
ALTER TABLE `security_policy_document_types` DISABLE KEYS;
INSERT INTO `security_policy_document_types` (`id`, `name`, `editable`, `created`, `modified`) VALUES 
	(1,'Procedure',0,'0000-00-00 00:00:00','0000-00-00 00:00:00'),
	(2,'Standard',0,'0000-00-00 00:00:00','0000-00-00 00:00:00'),
	(3,'Policy',0,'0000-00-00 00:00:00','0000-00-00 00:00:00');
ALTER TABLE `security_policy_document_types` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_policy_ldap_groups` WRITE;
ALTER TABLE `security_policy_ldap_groups` DISABLE KEYS;
ALTER TABLE `security_policy_ldap_groups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_policy_reviews` WRITE;
ALTER TABLE `security_policy_reviews` DISABLE KEYS;
ALTER TABLE `security_policy_reviews` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_service_audit_dates` WRITE;
ALTER TABLE `security_service_audit_dates` DISABLE KEYS;
ALTER TABLE `security_service_audit_dates` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_service_audits` WRITE;
ALTER TABLE `security_service_audits` DISABLE KEYS;
ALTER TABLE `security_service_audits` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_service_audit_improvements` WRITE;
ALTER TABLE `security_service_audit_improvements` DISABLE KEYS;
ALTER TABLE `security_service_audit_improvements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_service_classifications` WRITE;
ALTER TABLE `security_service_classifications` DISABLE KEYS;
ALTER TABLE `security_service_classifications` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_service_maintenance_dates` WRITE;
ALTER TABLE `security_service_maintenance_dates` DISABLE KEYS;
ALTER TABLE `security_service_maintenance_dates` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `service_classifications` WRITE;
ALTER TABLE `service_classifications` DISABLE KEYS;
ALTER TABLE `service_classifications` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_services` WRITE;
ALTER TABLE `security_services` DISABLE KEYS;
ALTER TABLE `security_services` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_service_maintenances` WRITE;
ALTER TABLE `security_service_maintenances` DISABLE KEYS;
ALTER TABLE `security_service_maintenances` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_service_types` WRITE;
ALTER TABLE `security_service_types` DISABLE KEYS;
INSERT INTO `security_service_types` (`id`, `name`) VALUES 
	(2,'Design'),
	(4,'Production');
ALTER TABLE `security_service_types` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `service_contracts` WRITE;
ALTER TABLE `service_contracts` DISABLE KEYS;
ALTER TABLE `service_contracts` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_services_service_contracts` WRITE;
ALTER TABLE `security_services_service_contracts` DISABLE KEYS;
ALTER TABLE `security_services_service_contracts` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `security_services_third_party_risks` WRITE;
ALTER TABLE `security_services_third_party_risks` DISABLE KEYS;
ALTER TABLE `security_services_third_party_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `setting_groups` WRITE;
ALTER TABLE `setting_groups` DISABLE KEYS;
INSERT INTO `setting_groups` (`id`, `slug`, `parent_slug`, `name`, `icon_code`, `notes`, `url`, `modal`, `hidden`, `order`) VALUES 
	(1,'ACCESSLST','ACCESSMGT','Access Lists',NULL,NULL,'{"controller":"admin", "action":"acl", "0" :"aros", "1":"ajax_role_permissions"}',0,0,0),
	(2,'ACCESSMGT',NULL,'Access Management','icon-cog',NULL,NULL,0,0,0),
	(3,'AUTH','ACCESSMGT','Authentication ',NULL,NULL,'{"controller":"ldapConnectorAuthentications","action":"edit"}',1,0,0),
	(4,'BANNER','SEC','Banners',NULL,NULL,NULL,0,1,0),
	(5,'BAR','DB','Backup & Restore',NULL,NULL,'{"controller":"backupRestore","action":"index", "plugin":"backupRestore"}',1,0,0),
	(6,'BFP','SEC','Brute Force Protection',NULL,'This setting allows you to protect the login page of eramba from being brute-force attacked.',NULL,0,0,0),
	(7,'CUE','LOC','Currency',NULL,NULL,NULL,0,0,0),
	(8,'DASH',NULL,'Dashboard','icon-cog',NULL,NULL,0,0,0),
	(9,'DASHRESET','DASH','Reset Dashboards',NULL,NULL,'{"controller":"settings","action":"resetDashboards"}',0,0,0),
	(10,'DB',NULL,'Database','icon-cog',NULL,NULL,0,0,0),
	(11,'DBCNF','DB','Database Configurations',NULL,NULL,NULL,0,1,0),
	(12,'DBRESET','DB','Reset Database',NULL,NULL,'{"controller":"settings","action":"resetDatabase"}',1,0,0),
	(13,'DEBUG',NULL,'Debug Settings and Logs','icon-cog',NULL,NULL,0,0,0),
	(14,'DEBUGCFG','DEBUG','Debug Config',NULL,NULL,NULL,0,0,0),
	(15,'ERRORLOG','DEBUG','Error Log',NULL,NULL,'{"controller":"settings","action":"logs", "0":"error"}',1,0,0),
	(16,'GROUP','ACCESSMGT','Groups ',NULL,NULL,'{"controller":"groups","action":"index"}',0,0,0),
	(17,'LDAP','ACCESSMGT','LDAP Connectors',NULL,NULL,'{"controller":"ldapConnectors","action":"index"}',0,0,0),
	(18,'LOC',NULL,'Localization','icon-cog',NULL,NULL,0,0,0),
	(19,'MAIL',NULL,'Mail','icon-cog',NULL,NULL,0,0,0),
	(20,'MAILCNF','MAIL','Mail Configurations',NULL,NULL,NULL,0,0,0),
	(21,'MAILLOG','DEBUG','Email Log',NULL,NULL,'{"controller":"settings","action":"logs", "0":"email"}',1,0,0),
	(22,'PRELOAD','DB','Pre-load the database with default databases',NULL,NULL,NULL,0,1,0),
	(23,'RISK',NULL,'Risk','icon-cog',NULL,NULL,0,1,0),
	(24,'RISKAPPETITE','RISK','Risk appetite',NULL,NULL,NULL,0,0,0),
	(25,'ROLES','ACCESSMGT','Roles',NULL,NULL,'{"controller":"scopes","action":"index"}',0,1,0),
	(26,'SEC',NULL,'Security','icon-cog',NULL,NULL,0,0,0),
	(27,'SECKEY','CRONJOBS','Crontab Security Key',NULL,NULL,NULL,0,0,0),
	(28,'USER','ACCESSMGT','User Management',NULL,NULL,'{"controller":"users","action":"index"}',0,0,0),
	(29,'CLRCACHE','DEBUG','Clear Cache',NULL,NULL,'{"controller":"settings","action":"deleteCache"}',0,0,0),
	(30,'CLRACLCACHE','DEBUG','Clear ACL Cache',NULL,NULL,'{"controller":"settings","action":"deleteCache", "0":"acl"}',0,1,0),
	(31,'LOGO','LOC','Custom Logo',NULL,NULL,'{"controller":"settings","action":"customLogo"}',1,0,0),
	(32,'HEALTH','SEC','System Health',NULL,NULL,'{"controller":"settings","action":"systemHealth"}',1,0,0),
	(33,'TZONE','LOC','Timezone',NULL,NULL,NULL,0,0,0),
	(34,'UPDATES','SEC','Updates',NULL,NULL,'{"controller":"updates","action":"index"}',0,0,0),
	(35,'NOTIFICATION','ACCESSMGT','Notifications',NULL,NULL,'{"controller":"notificationSystem","action":"listItems"}',0,1,0),
	(36,'CRON','CRONJOBS','Crontab History',NULL,NULL,'{"controller":"cron","action":"index"}',0,0,0),
	(37,'BACKUP','DB','Backup Configuration',NULL,NULL,NULL,0,0,2),
	(38,'QUEUE','MAIL','Emails In Queue',NULL,NULL,'{"controller":"queue", "action":"index"}',0,0,0),
	(39,'VISUALISATION','ACCESSMGT','Visualisation',NULL,NULL,'{"controller":"visualisationSettings","action":"index", "plugin":"visualisation"}',0,0,0),
	(40,'OAUTH','ACCESSMGT','OAuth Connectors',NULL,NULL,'{"controller":"oauthConnectors","action":"index"}',0,0,0),
	(41,'CRONJOBS',NULL,'Cron Jobs','icon-cog',NULL,NULL,0,0,0),
	(42,'GENERAL',NULL,'General Settings','icon-cog',NULL,NULL,0,0,0),
	(43,'PDFCONFIG','GENERAL','PDF Configuration',NULL,NULL,NULL,0,0,0),
	(44,'SSLOFFLOAD','SEC','SSL/TLS Offload',NULL,NULL,NULL,0,0,0),
	(45,'ENTERPRISE_USERS','SEC','Enterprise Users',NULL,NULL,NULL,0,0,0),
	(46,'SECSALT','SEC','Security Salt',NULL,NULL,NULL,0,1,0),
	(47,'CSV','LOC','CSV Delimiter',NULL,NULL,NULL,0,0,0),
	(48,'TRANSLATION','LOC','Languages',NULL,NULL,'{"plugin":"translations","controller":"translations","action":"index"}',0,0,0),
	(49,'DEFAULT_TRANSLATION','LOC','Default Language',NULL,NULL,NULL,1,1,0);
ALTER TABLE `setting_groups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `settings` WRITE;
ALTER TABLE `settings` DISABLE KEYS;
INSERT INTO `settings` (`id`, `active`, `name`, `variable`, `value`, `default_value`, `values`, `type`, `options`, `hidden`, `required`, `setting_group_slug`, `setting_type`, `order`, `modified`, `created`) VALUES 
	(2,1,'DB Schema Version','DB_SCHEMA_VERSION','c2.8.1',NULL,NULL,'text',NULL,1,0,NULL,'constant',0,'2017-02-22 21:32:39','2015-12-19 00:00:00'),
	(3,1,'Client ID','CLIENT_ID',NULL,NULL,NULL,'text',NULL,1,0,NULL,'constant',0,'2016-11-18 14:37:22','2015-12-19 00:00:00'),
	(4,1,'Bruteforce wrong logins','BRUTEFORCE_WRONG_LOGINS','3',NULL,NULL,'number','{"min":1,"max":10,"step":1}',0,0,'BFP','constant',0,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(5,1,'Bruteforce second ago','BRUTEFORCE_SECONDS_AGO','60',NULL,NULL,'number','{"min":10,"max":120,"step":1}',0,0,'BFP','constant',0,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(10,1,'Default currency','DEFAULT_CURRENCY','EUR',NULL,'configDefaultCurrency','select','{"AUD":"AUD","CAD":"CAD","USD":"USD","EUR":"EUR","GBP":"GBP","JPY":"JPY"}',0,0,'CUE','config',0,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(11,1,'Type','SMTP_USE','0',NULL,NULL,'select','{"0":"Mail","1":"SMTP"}',0,0,'MAILCNF','constant',0,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(12,1,'SMTP host','SMTP_HOST','',NULL,NULL,'text',NULL,0,0,'MAILCNF','constant',1,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(13,1,'SMTP user','SMTP_USER','',NULL,NULL,'text',NULL,0,0,'MAILCNF','constant',3,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(14,1,'SMTP password','SMTP_PWD','',NULL,NULL,'password',NULL,0,0,'MAILCNF','constant',4,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(15,1,'SMTP timeout','SMTP_TIMEOUT','60',NULL,NULL,'number','{"min":1,"max":120,"step":1}',0,0,'MAILCNF','constant',5,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(16,1,'SMTP port','SMTP_PORT','',NULL,NULL,'text',NULL,0,0,'MAILCNF','constant',6,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(18,1,'No reply Email','NO_REPLY_EMAIL','noreply@domain.org',NULL,NULL,'text',NULL,0,0,'MAILCNF','constant',7,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(19,1,'Cron security key','CRON_SECURITY_KEY','egkrjng328525798',NULL,NULL,'text',NULL,0,0,'SECKEY','constant',2,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(20,1,'Bruteforce ban from minutes','BRUTEFORCE_BAN_FOR_MINUTES','5',NULL,NULL,'number','{"min":1,"max":120,"step":1}',0,0,'BFP','constant',0,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(21,1,'Banners off','BANNERS_OFF','1',NULL,NULL,'checkbox',NULL,0,0,'BANNER','constant',0,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(22,1,'Debug','DEBUG','0',NULL,'configDebug','checkbox',NULL,0,0,'DEBUGCFG','config',0,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(23,1,'Email Debug','EMAIL_DEBUG','0',NULL,'configEmailDebug','checkbox',NULL,0,0,'DEBUGCFG','config',0,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(24,1,'Risk Appetite','RISK_APPETITE','1',NULL,NULL,'number','{"min":0,"max":999999,"step":1}',0,0,'RISKAPPETITE','constant',0,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(25,1,'Encryption','USE_SSL','0',NULL,NULL,'select','{"0":"No Encryption","1":"SSL","2":"TLS"}',0,0,'MAILCNF','constant',2,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(26,1,'Timezone','TIMEZONE',NULL,NULL,'configTimezone','select',NULL,0,0,'TZONE','config',0,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(27,1,'Backups Enabled','BACKUPS_ENABLED','1',NULL,NULL,'checkbox',NULL,0,0,'BACKUP','constant',0,'2017-02-22 21:32:29','2017-02-22 21:32:29'),
	(28,1,'Backup Day Period','BACKUP_DAY_PERIOD','1',NULL,NULL,'select','{"1":"Every day","2":"Every 2 days","3":"Every 3 days","4":"Every 4 days","5":"Every 5 days","6":"Every 6 days","7":"Every 7 days"}',0,0,'BACKUP','constant',0,'2017-02-22 21:32:29','2017-02-22 21:32:29'),
	(29,1,'Backup Files Limit','BACKUP_FILES_LIMIT','15',NULL,NULL,'select','{"1":"1","5":"5","10":"10","15":"15"}',0,0,'BACKUP','constant',0,'2017-02-22 21:32:29','2017-02-22 21:32:29'),
	(30,1,'Name','EMAIL_NAME','',NULL,NULL,'text',NULL,0,0,'MAILCNF','constant',6,'2017-02-22 21:32:29','2017-02-22 21:32:29'),
	(31,1,'Risk Granularity','RISK_GRANULARITY','10',NULL,NULL,'number',NULL,0,0,NULL,'constant',0,'2017-04-19 00:00:00','2017-04-19 00:00:00'),
	(32,1,'Email Queue Throughput','QUEUE_TRANSPORT_LIMIT','15',NULL,NULL,'number',NULL,0,0,'MAILCNF','constant',8,'2019-05-21 12:34:54','2019-05-21 12:34:54'),
	(33,1,'WKHTMLTOPDF path to bin file','PDF_PATH_TO_BIN','/usr/local/bin/wkhtmltopdf','/usr/local/bin/wkhtmltopdf',NULL,'text',NULL,0,0,'PDFCONFIG','constant',0,'2019-05-21 12:35:34','2019-05-21 12:35:34'),
	(34,1,'Enable SSL/TLS Offload Requests','SSL_OFFLOAD_ENABLED','0','0',NULL,'checkbox',NULL,0,0,'SSLOFFLOAD','config',0,'2019-05-21 12:36:50','2019-05-21 12:36:50'),
	(35,1,'Enterprise Activation Key','CLIENT_KEY','',NULL,NULL,'text',NULL,0,0,'ENTERPRISE_USERS','config',0,'2019-05-21 12:37:16','2019-05-21 12:37:16'),
	(36,1,'Security Salt','SECURITY_SALT','5ce3f0fc-9254-4196-8d97-96a700000000',NULL,NULL,'text',NULL,0,0,'SECSALT','config',0,'2019-05-21 12:37:16','2019-05-21 12:37:16'),
	(37,1,'CSV Delimiter','CSV_DELIMITER',',',NULL,NULL,'select','{",":"\\",\\" (Comma)",";":"\\";\\" (Semicolon)"}',0,0,'CSV','config',0,'2019-05-21 12:37:16','2019-05-21 12:37:16'),
	(38,1,'Cron Type','CRON_TYPE','cli',NULL,NULL,'select','{"web":"Web","cli":"CLI"}',0,0,'SECKEY','constant',0,'2019-06-11 15:17:23','2019-06-11 15:17:23'),
	(39,1,'Cron URL','CRON_URL','http://localhost',NULL,NULL,'text',NULL,0,1,'SECKEY','constant',1,'2019-06-11 15:17:23','2019-06-11 15:17:23'),
	(40,1,'Default Language','DEFAULT_TRANSLATION','1','1',NULL,'select',NULL,1,0,'DEFAULT_TRANSLATION','constant',0,'2019-07-11 09:00:12','2019-07-11 09:00:12');
ALTER TABLE `settings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `status_triggers` WRITE;
ALTER TABLE `status_triggers` DISABLE KEYS;
ALTER TABLE `status_triggers` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `suggestions` WRITE;
ALTER TABLE `suggestions` DISABLE KEYS;
ALTER TABLE `suggestions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `system_logs` WRITE;
ALTER TABLE `system_logs` DISABLE KEYS;
INSERT INTO `system_logs` (`id`, `model`, `foreign_key`, `sub_model`, `sub_foreign_key`, `action`, `result`, `message`, `user_model`, `user_id`, `ip`, `uri`, `request_id`, `created`, `modified`, `edited`) VALUES 
	(1,'Visualisation.VisualisationShare',NULL,'User',1,901,'1','Object shared.','User',NULL,'','','5da9e7da-32ec-48df-b0de-34c8415c481f','2019-10-18 16:27:06','2019-10-18 16:27:06',NULL);
ALTER TABLE `system_logs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `system_records` WRITE;
ALTER TABLE `system_records` DISABLE KEYS;
ALTER TABLE `system_records` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `tags` WRITE;
ALTER TABLE `tags` DISABLE KEYS;
ALTER TABLE `tags` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `team_roles` WRITE;
ALTER TABLE `team_roles` DISABLE KEYS;
ALTER TABLE `team_roles` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `third_parties` WRITE;
ALTER TABLE `third_parties` DISABLE KEYS;
INSERT INTO `third_parties` (`id`, `name`, `description`, `third_party_type_id`, `security_incident_count`, `security_incident_open_count`, `service_contract_count`, `workflow_status`, `workflow_owner_id`, `_hidden`, `created`, `modified`, `edited`, `deleted`, `deleted_date`) VALUES 
	(1,'None','',NULL,0,0,0,0,NULL,1,'2015-12-19 00:00:00','2015-12-19 00:00:00',NULL,0,NULL);
ALTER TABLE `third_parties` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `third_parties_third_party_risks` WRITE;
ALTER TABLE `third_parties_third_party_risks` DISABLE KEYS;
ALTER TABLE `third_parties_third_party_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `third_parties_vendor_assessments` WRITE;
ALTER TABLE `third_parties_vendor_assessments` DISABLE KEYS;
ALTER TABLE `third_parties_vendor_assessments` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `third_party_audit_overtime_graphs` WRITE;
ALTER TABLE `third_party_audit_overtime_graphs` DISABLE KEYS;
ALTER TABLE `third_party_audit_overtime_graphs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `third_party_incident_overtime_graphs` WRITE;
ALTER TABLE `third_party_incident_overtime_graphs` DISABLE KEYS;
ALTER TABLE `third_party_incident_overtime_graphs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `third_party_overtime_graphs` WRITE;
ALTER TABLE `third_party_overtime_graphs` DISABLE KEYS;
ALTER TABLE `third_party_overtime_graphs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `third_party_risk_overtime_graphs` WRITE;
ALTER TABLE `third_party_risk_overtime_graphs` DISABLE KEYS;
ALTER TABLE `third_party_risk_overtime_graphs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `third_party_risks` WRITE;
ALTER TABLE `third_party_risks` DISABLE KEYS;
ALTER TABLE `third_party_risks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `third_party_risks_threats` WRITE;
ALTER TABLE `third_party_risks_threats` DISABLE KEYS;
ALTER TABLE `third_party_risks_threats` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `third_party_risks_vulnerabilities` WRITE;
ALTER TABLE `third_party_risks_vulnerabilities` DISABLE KEYS;
ALTER TABLE `third_party_risks_vulnerabilities` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `third_party_types` WRITE;
ALTER TABLE `third_party_types` DISABLE KEYS;
INSERT INTO `third_party_types` (`id`, `name`) VALUES 
	(1,'Customers'),
	(2,'Suppliers'),
	(3,'Regulators');
ALTER TABLE `third_party_types` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `threats` WRITE;
ALTER TABLE `threats` DISABLE KEYS;
INSERT INTO `threats` (`id`, `name`) VALUES 
	(1,'Intentional Complot'),
	(2,'Pandemic Issues'),
	(3,'Strikes'),
	(4,'Unintentional Loss of Equipment'),
	(5,'Intentional Theft of Equipment'),
	(6,'Unintentional Loss of Information'),
	(7,'Intentional Theft of Information'),
	(8,'Remote Exploit'),
	(9,'Abuse of Service'),
	(10,'Web Application Attack'),
	(11,'Network Attack'),
	(12,'Sniffing'),
	(13,'Phishing'),
	(14,'Malware/Trojan Distribution'),
	(15,'Viruses'),
	(16,'Copyright Infrigment'),
	(17,'Social Engineering'),
	(18,'Natural Disasters'),
	(19,'Fire'),
	(20,'Flooding'),
	(21,'Ilegal Infiltration'),
	(22,'DOS Attack'),
	(23,'Brute Force Attack'),
	(24,'Tampering'),
	(25,'Tunneling'),
	(26,'Man in the Middle'),
	(27,'Fraud'),
	(28,'Other'),
	(30,'Terrorist Attack'),
	(31,'Floodings'),
	(32,'Third Party Intrusion'),
	(33,'Abuse of Priviledge'),
	(34,'Unauthorised records'),
	(35,'Spying');
ALTER TABLE `threats` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `tickets` WRITE;
ALTER TABLE `tickets` DISABLE KEYS;
ALTER TABLE `tickets` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `tooltip_logs` WRITE;
ALTER TABLE `tooltip_logs` DISABLE KEYS;
ALTER TABLE `tooltip_logs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `translations` WRITE;
ALTER TABLE `translations` DISABLE KEYS;
INSERT INTO `translations` (`id`, `name`, `folder`, `status`, `type`, `created`, `modified`) VALUES 
	(1,'Default (English)','eng',1,0,'2019-07-11 09:00:12','2019-07-11 09:00:12'),
	(2,'Spanish (Spain)','spa',1,0,'2019-07-11 09:00:12','2019-07-11 09:00:12'),
	(3,'French (France)','fra',1,0,'2019-07-11 09:00:12','2019-07-11 09:00:12'),
	(4,'Portuguese (Portugal)','por',1,0,'2019-07-11 09:00:12','2019-07-11 09:00:12'),
	(5,'Norwegian Bokmål (Norway)','nob',1,0,'2019-07-11 09:00:12','2019-07-11 09:00:12');
ALTER TABLE `translations` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `user_bans` WRITE;
ALTER TABLE `user_bans` DISABLE KEYS;
ALTER TABLE `user_bans` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `user_fields_groups` WRITE;
ALTER TABLE `user_fields_groups` DISABLE KEYS;
ALTER TABLE `user_fields_groups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `user_fields_objects` WRITE;
ALTER TABLE `user_fields_objects` DISABLE KEYS;
INSERT INTO `user_fields_objects` (`id`, `model`, `foreign_key`, `field`, `object_id`, `object_key`, `object_model`, `created`, `modified`) VALUES 
	(1,'VisualisationShare',1,'SharedUser',1,'User-1','User','2019-10-18 16:27:06','2019-10-18 16:27:06'),
	(2,'VisualisationShare',1,'SharedUser',1,'User-1','User','2019-10-18 16:27:06','2019-10-18 16:27:06'),
	(3,'VisualisationShare',1,'SharedUser',1,'User-1','User','2019-10-18 16:27:06','2019-10-18 16:27:06');
ALTER TABLE `user_fields_objects` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `users` WRITE;
ALTER TABLE `users` DISABLE KEYS;
INSERT INTO `users` (`id`, `name`, `surname`, `email`, `login`, `password`, `language`, `status`, `blocked`, `local_account`, `api_allow`, `default_password`, `account_ready`, `ldap_sync`, `ldap_synchronization_id`, `created`, `modified`, `edited`) VALUES 
	(1,'Admin','Admin','admin@eramba.org','admin','$2a$10$WhVO3Jj4nFhCj6bToUOztun/oceKY6rT2db2bu430dW5/lU0w9KJ.','eng',1,0,1,0,1,1,0,NULL,'2013-10-14 16:19:04','2015-09-11 18:19:52',NULL);
ALTER TABLE `users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `user_fields_users` WRITE;
ALTER TABLE `user_fields_users` DISABLE KEYS;
INSERT INTO `user_fields_users` (`id`, `model`, `foreign_key`, `field`, `user_id`, `created`, `modified`) VALUES 
	(1,'VisualisationShare',1,'SharedUser',1,'2019-10-18 16:27:06','2019-10-18 16:27:06');
ALTER TABLE `user_fields_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `users_groups` WRITE;
ALTER TABLE `users_groups` DISABLE KEYS;
INSERT INTO `users_groups` (`id`, `user_id`, `group_id`) VALUES 
	(1,1,10);
ALTER TABLE `users_groups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `users_ldap_synchronizations` WRITE;
ALTER TABLE `users_ldap_synchronizations` DISABLE KEYS;
ALTER TABLE `users_ldap_synchronizations` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `users_portals` WRITE;
ALTER TABLE `users_portals` DISABLE KEYS;
INSERT INTO `users_portals` (`id`, `user_id`, `portal_id`, `created`, `modified`) VALUES 
	(1,1,1,'2019-05-21 12:35:33','2019-05-21 12:35:33');
ALTER TABLE `users_portals` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `vendor_assessment_feedbacks` WRITE;
ALTER TABLE `vendor_assessment_feedbacks` DISABLE KEYS;
ALTER TABLE `vendor_assessment_feedbacks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `vendor_assessment_files` WRITE;
ALTER TABLE `vendor_assessment_files` DISABLE KEYS;
ALTER TABLE `vendor_assessment_files` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `vendor_assessment_findings` WRITE;
ALTER TABLE `vendor_assessment_findings` DISABLE KEYS;
ALTER TABLE `vendor_assessment_findings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `vendor_assessment_findings_questions` WRITE;
ALTER TABLE `vendor_assessment_findings_questions` DISABLE KEYS;
ALTER TABLE `vendor_assessment_findings_questions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `vendor_assessment_options` WRITE;
ALTER TABLE `vendor_assessment_options` DISABLE KEYS;
ALTER TABLE `vendor_assessment_options` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `vendor_assessment_questionnaires` WRITE;
ALTER TABLE `vendor_assessment_questionnaires` DISABLE KEYS;
ALTER TABLE `vendor_assessment_questionnaires` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `vendor_assessment_questions` WRITE;
ALTER TABLE `vendor_assessment_questions` DISABLE KEYS;
ALTER TABLE `vendor_assessment_questions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `vendor_assessments` WRITE;
ALTER TABLE `vendor_assessments` DISABLE KEYS;
ALTER TABLE `vendor_assessments` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `visualisation_settings` WRITE;
ALTER TABLE `visualisation_settings` DISABLE KEYS;
INSERT INTO `visualisation_settings` (`id`, `model`, `status`, `order`) VALUES 
	(1,'Asset',1,1),
	(2,'AssetReview',1,2),
	(3,'Risk',1,10),
	(4,'ThirdPartyRisk',1,17),
	(5,'BusinessContinuity',1,3),
	(6,'RiskReview',1,11),
	(7,'ThirdPartyRiskReview',1,18),
	(8,'BusinessContinuityReview',1,4),
	(9,'SecurityPolicy',1,12),
	(10,'SecurityPolicyReview',1,13),
	(11,'SecurityService',1,14),
	(12,'SecurityServiceAudit',1,15),
	(13,'SecurityServiceMaintenance',1,16),
	(14,'ComplianceException',1,8),
	(16,'ComplianceAudit',1,6),
	(17,'ComplianceAnalysisFinding',1,5),
	(18,'ComplianceAuditSetting',1,7),
	(19,'ComplianceFinding',1,9),
	(20,'BusinessUnit',1,999),
	(21,'AwarenessProgram',1,999),
	(22,'BusinessContinuityPlan',1,999),
	(23,'BusinessContinuityPlanAudit',1,999),
	(24,'DataAssetInstance',1,999),
	(25,'DataAsset',1,999),
	(26,'Goal',1,999),
	(27,'Legal',1,999),
	(28,'PolicyException',1,999),
	(29,'Process',1,999),
	(30,'ProgramIssue',1,999),
	(31,'ProgramScope',1,999),
	(32,'Project',1,999),
	(33,'ProjectAchievement',1,999),
	(34,'ProjectExpense',1,999),
	(35,'RiskException',1,999),
	(36,'SecurityIncident',1,999),
	(37,'ThirdParty',1,999),
	(38,'VendorAssessment',1,999),
	(39,'VendorAssessmentFinding',1,999),
	(40,'AccountReview',1,999),
	(41,'AccountReviewPull',1,999),
	(42,'AccountReviewFeedback',1,999),
	(43,'AccountReviewFinding',1,999),
	(44,'ComplianceManagement',1,999),
	(45,'ServiceContract',1,999),
	(46,'TeamRole',1,999),
	(47,'SecurityServiceIssue',1,999),
	(48,'CompliancePackage',1,999),
	(49,'DataAssetSetting',1,999),
	(50,'GoalAudit',1,999),
	(52,'BusinessContinuityTask',1,999),
	(53,'CompliancePackageItem',1,999),
	(54,'VendorAssessmentFeedback',1,999),
	(55,'AppNotification',1,999),
	(56,'DashboardCalendarEvent',1,999),
	(57,'CompliancePackageRegulator',1,999),
	(58,'User',1,999);
ALTER TABLE `visualisation_settings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `visualisation_settings_groups` WRITE;
ALTER TABLE `visualisation_settings_groups` DISABLE KEYS;
ALTER TABLE `visualisation_settings_groups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `visualisation_settings_users` WRITE;
ALTER TABLE `visualisation_settings_users` DISABLE KEYS;
ALTER TABLE `visualisation_settings_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `visualisation_share` WRITE;
ALTER TABLE `visualisation_share` DISABLE KEYS;
INSERT INTO `visualisation_share` (`id`, `model`, `foreign_key`) VALUES 
	(1,'User',1);
ALTER TABLE `visualisation_share` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `visualisation_share_groups` WRITE;
ALTER TABLE `visualisation_share_groups` DISABLE KEYS;
ALTER TABLE `visualisation_share_groups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `visualisation_share_users` WRITE;
ALTER TABLE `visualisation_share_users` DISABLE KEYS;
INSERT INTO `visualisation_share_users` (`id`, `visualisation_share_id`, `aros_acos_id`, `user_fields_user_id`, `created`) VALUES 
	(1,1,87,1,'2019-10-18 16:27:06');
ALTER TABLE `visualisation_share_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `vulnerabilities` WRITE;
ALTER TABLE `vulnerabilities` DISABLE KEYS;
INSERT INTO `vulnerabilities` (`id`, `name`) VALUES 
	(1,'Lack of Information'),
	(2,'Lack of Integrity Checks'),
	(3,'Lack of Logs'),
	(4,'No Change Management'),
	(5,'Weak CheckOut Procedures'),
	(6,'Supplier Failure'),
	(7,'Lack of alternative Power Sources'),
	(8,'Lack of Physical Guards'),
	(9,'Lack of Patching'),
	(10,'Web Application Vulnerabilities'),
	(11,'Lack of CCTV'),
	(12,'Lack of Movement Sensors'),
	(13,'Lack of Procedures'),
	(14,'Lack of Network Controls'),
	(15,'Lack of Strong Authentication'),
	(16,'Lack of Encryption in Motion'),
	(17,'Lack of Encryption at Rest'),
	(18,'Creeping Accounts'),
	(19,'Hardware Malfunction'),
	(20,'Software Malfunction'),
	(21,'Lack of Fire Extinguishers'),
	(22,'Lack of alternative exit doors'),
	(23,'Weak Passwords'),
	(24,'Weak Awareness'),
	(25,'Missing Configuration Standards'),
	(26,'Open Network Ports'),
	(27,'Reputational Issues'),
	(28,'Seismic Areas'),
	(29,'Prone to Natural Disasters Area'),
	(30,'Flood Prone Areas'),
	(31,'Other'),
	(32,'Unprotected Network'),
	(33,'Cabling Unsecured'),
	(34,'Weak Software Development Procedures');
ALTER TABLE `vulnerabilities` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `wf_access_models` WRITE;
ALTER TABLE `wf_access_models` DISABLE KEYS;
ALTER TABLE `wf_access_models` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `wf_access_types` WRITE;
ALTER TABLE `wf_access_types` DISABLE KEYS;
ALTER TABLE `wf_access_types` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `wf_accesses` WRITE;
ALTER TABLE `wf_accesses` DISABLE KEYS;
ALTER TABLE `wf_accesses` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `wf_instance_approvals` WRITE;
ALTER TABLE `wf_instance_approvals` DISABLE KEYS;
ALTER TABLE `wf_instance_approvals` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `wf_settings` WRITE;
ALTER TABLE `wf_settings` DISABLE KEYS;
ALTER TABLE `wf_settings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `wf_stages` WRITE;
ALTER TABLE `wf_stages` DISABLE KEYS;
ALTER TABLE `wf_stages` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `wf_instances` WRITE;
ALTER TABLE `wf_instances` DISABLE KEYS;
ALTER TABLE `wf_instances` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `wf_instance_logs` WRITE;
ALTER TABLE `wf_instance_logs` DISABLE KEYS;
ALTER TABLE `wf_instance_logs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `wf_stage_steps` WRITE;
ALTER TABLE `wf_stage_steps` DISABLE KEYS;
ALTER TABLE `wf_stage_steps` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `wf_instance_requests` WRITE;
ALTER TABLE `wf_instance_requests` DISABLE KEYS;
ALTER TABLE `wf_instance_requests` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `wf_stage_step_conditions` WRITE;
ALTER TABLE `wf_stage_step_conditions` DISABLE KEYS;
ALTER TABLE `wf_stage_step_conditions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `widget_views` WRITE;
ALTER TABLE `widget_views` DISABLE KEYS;
ALTER TABLE `widget_views` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `workflow_acknowledgements` WRITE;
ALTER TABLE `workflow_acknowledgements` DISABLE KEYS;
ALTER TABLE `workflow_acknowledgements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `workflow_items` WRITE;
ALTER TABLE `workflow_items` DISABLE KEYS;
ALTER TABLE `workflow_items` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `workflow_logs` WRITE;
ALTER TABLE `workflow_logs` DISABLE KEYS;
ALTER TABLE `workflow_logs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `workflows` WRITE;
ALTER TABLE `workflows` DISABLE KEYS;
INSERT INTO `workflows` (`id`, `model`, `name`, `notifications`, `parent_id`, `created`, `modified`) VALUES 
	(1,'SecurityIncident','Security Incidents',1,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(2,'BusinessUnit','Business Units',1,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(3,'Legal','Legals',1,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(4,'ThirdParty','Third Parties',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(5,'Process','Processes',0,2,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(6,'Asset','Assets',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(7,'AssetClassification','Asset Classifications',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(8,'AssetLabel','Asset Labeling',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(9,'RiskClassification','Risk Classifications',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(10,'RiskException','Risk Exceptions',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(11,'Risk','Risks',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(12,'ThirdPartyRisk','Third Party Risks',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(13,'BusinessContinuity','Business Continuities',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(14,'SecurityService','Security Services',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(15,'ServiceContract','Service Contracts',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(16,'ServiceClassification','Service Classifications',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(17,'BusinessContinuityPlan','Business Continuity Plans',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(18,'SecurityPolicy','Security Policies',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(19,'PolicyException','Policy Exceptions',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(20,'Project','Projects',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(22,'ProjectAchievement','Project Achievements',0,20,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(23,'ProjectExpense','Project Expenses',0,20,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(24,'SecurityServiceAudit','Security Service Audits',0,14,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(25,'SecurityServiceMaintenance','Security Service Maintenances',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(26,'CompliancePackageItem','Compliance Package Items',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(27,'DataAsset','Data Assets',0,6,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(28,'ComplianceManagement','Compliance Managements',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(29,'BusinessContinuityPlanAudit','Business Continuity Plan Audits',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(31,'BusinessContinuityTask','Business Continuity Tasks',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(32,'LdapConnector','LDAP Connectors',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(33,'SecurityPolicyReview','Security Policy Reviews',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(34,'RiskReview','Risk Reviews',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(35,'ThirdPartyRiskReview','ThirdPartyRisk Reviews',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(36,'BusinessContinuityReview','BusinessContinuity Reviews',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(37,'AssetReview','Asset Reviews',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(38,'SecurityIncidentStage','Security Incident Stage',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(39,'SecurityIncidentStagesSecurityIncident','Security Incident Stages Security Incident',0,39,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(41,'AwarenessProgram','Awareness Programs',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(42,'ProgramScope','Scopes',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(43,'ProgramIssue','Issues',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(44,'TeamRole','Team Roles',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(45,'Goal','Goals',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(46,'GoalAudit','Goal Audits',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00'),
	(47,'SecurityServiceIssue','Security Service Issues',0,NULL,'2015-12-19 00:00:00','2015-12-19 00:00:00');
ALTER TABLE `workflows` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `workflows_all_approver_items` WRITE;
ALTER TABLE `workflows_all_approver_items` DISABLE KEYS;
ALTER TABLE `workflows_all_approver_items` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `workflows_all_validator_items` WRITE;
ALTER TABLE `workflows_all_validator_items` DISABLE KEYS;
ALTER TABLE `workflows_all_validator_items` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `workflows_approver_scopes` WRITE;
ALTER TABLE `workflows_approver_scopes` DISABLE KEYS;
ALTER TABLE `workflows_approver_scopes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `workflows_approvers` WRITE;
ALTER TABLE `workflows_approvers` DISABLE KEYS;
ALTER TABLE `workflows_approvers` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `workflows_custom_approvers` WRITE;
ALTER TABLE `workflows_custom_approvers` DISABLE KEYS;
ALTER TABLE `workflows_custom_approvers` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `workflows_custom_validators` WRITE;
ALTER TABLE `workflows_custom_validators` DISABLE KEYS;
ALTER TABLE `workflows_custom_validators` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `workflows_validator_scopes` WRITE;
ALTER TABLE `workflows_validator_scopes` DISABLE KEYS;
ALTER TABLE `workflows_validator_scopes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `workflows_validators` WRITE;
ALTER TABLE `workflows_validators` DISABLE KEYS;
ALTER TABLE `workflows_validators` ENABLE KEYS;
UNLOCK TABLES;




SET FOREIGN_KEY_CHECKS = @PREVIOUS_FOREIGN_KEY_CHECKS;


