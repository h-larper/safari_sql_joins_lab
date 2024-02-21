DROP TABLE IF EXISTS assignment;
DROP TABLE IF EXISTS animals;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS enclosures;


CREATE TABLE staff (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    employee_number INT
);

CREATE TABLE enclosures (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    capacity INT,
    closed_for_maintenance BOOLEAN
);

CREATE TABLE animals (
    id SERIAL PRIMARY KEY,
    enclosure_id INT REFERENCES enclosures(id),
    type VARCHAR(255),
    name VARCHAR(255),
    age INT
);

CREATE TABLE assignment (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES staff(id),
    enclosure_id INT REFERENCES enclosures(id),
    day VARCHAR(255)
);

INSERT INTO staff (name, employee_number) VALUES
    ('Dipper Pines', 11111),
    ('Mabel Pines', 22222),
    ('Grunkle Stan', 33333),
    ('Gideon Gleeful', 44444),
    ('Soos Ramirez', 55555),
    ('Wendy Corduroy', 66666);

INSERT INTO enclosures (name, capacity, closed_for_maintenance) VALUES
    ('Aquarium', 100, False),
    ('Aviary', 50, True),
    ('Terranium', 20, False),
    ('Big Cats', 5, False),
    ('Farmyard', 1, False);

INSERT INTO animals (name, type, age, enclosure_id) VALUES
    ('Waddles', 'Pig', 12, 5),
    ('Grayson', 'Betta Splendens', 10, 1),
    ('Magikarp', 'Pokemon', 19, 1),
    ('Finchly', 'Goldfinch', 2, 2),
    ('Simba', 'Lion', 5, 4),
    ('Lily Billy', 'Cat', 6, 4),
    ('Mustard', 'Gecko', 1, 3);

INSERT INTO assignment (employee_id, enclosure_id, day) VALUES
    (2, 5, 'Friday'),
    (3, 4, 'Monday'),
    (2, 5, 'Tuesday'),
    (5, 3, 'Wednesday'),
    (6, 3, 'Wednesday'),
    (4, 1, 'Thursday'),
    (1, 2, 'Monday');


-- Finding names of animals in Aquarium:
SELECT name FROM animals WHERE enclosure_id = 1;

-- Finding names of staff working Terrium:
SELECT name FROM staff AS s INNER JOIN assignment AS a ON s.id = a.employee_id WHERE a.enclosure_id = 3;

-- Finding names of staff working in enclosures closed for maintenance:
SELECT s.name FROM staff AS s
INNER JOIN assignment AS a ON s.id = a.employee_id
INNER JOIN enclosures AS e ON e.id = a.enclosure_id
WHERE e.closed_for_maintenance = true;

-- The name of the enclosure where the oldest animal lives. If 2 animals who are the same age choose the first one alphabetically. 
SELECT e.name FROM enclosures AS e
INNER JOIN animals AS a ON e.id = a.enclosure_id
ORDER BY age DESC, a.name LIMIT 1;

-- The number of different animal types a given keeper has been assigned to work with. 
SELECT COUNT(DISTINCT an.type) FROM animals AS an
INNER JOIN enclosures AS e ON e.id = an.enclosure_id
INNER JOIN assignment AS a ON a.enclosure_id = e.id
INNER JOIN staff AS s ON s.id = a.employee_id
WHERE s.id = 3;

-- The number of different keepers who have been assigned to work in a given enclosure.
SELECT COUNT(*) FROM staff AS s
INNER JOIN assignment AS a ON a.employee_id = s.id
INNER JOIN enclosures AS e ON e.id = a.enclosure_id
WHERE e.name = 'Aviary';

-- The names of the other animals sharing an enclosure with a given animal (eg. find the names of all the animals sharing the big cat field with Tony)
SELECT name FROM animals WHERE name != 'Simba' AND enclosure_id IN (SELECT enclosure_id FROM animals WHERE name = 'Simba');