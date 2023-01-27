INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_taxi', 'Taxi', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_taxi', 'Taxi', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_taxi', 'Taxi', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('taxi', 'Taxi')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary) VALUES
	('taxi',0,'recrue',' Recrue', 12),
	('taxi',1,'novice',' Novice', 24),
	('taxi',2,'experimente','Experimente', 36),
	('taxi',3,'uber','Uber',48),
	('taxi',4,'chefequipe','chef d\'équipe',48),
	('taxi',5,'boss','PDG', 0)
;