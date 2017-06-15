-- Database: "ESALE"

-- DROP DATABASE "ESALE";

/*CREATE DATABASE "ESALE"
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'English_United States.1252'
       LC_CTYPE = 'English_United States.1252'
       CONNECTION LIMIT = -1;





DROP table nested_category_sale_item;
DROP table nested_category;
DROP table sale_item;
DROP table category;
DROP SEQUENCE sale_item_sq;
DROP SEQUENCE category_sq;
DROP SEQUENCE nested_category_sq;
DROP SEQUENCE securityuser_sq;
DROP SEQUENCE voicecontact_sq;
DROP SEQUENCE locationcontact_sq;
DROP TABLE user_voicecontact;
DROP TABLE user_locationcontact;
DROP TABLE voicecontact;
DROP TABLE locationcontact;
DROP TABLE securityuser;

DROP FUNCTION get_nested_category_depth(integer);
DROP FUNCTION delete_nodes(integer,text);
DROP FUNCTION add_new_node(integer, integer, text, integer, text, text);
DROP FUNCTION get_nested_category_edge_id(text, integer);
DROP FUNCTION get_single_path(integer);
DROP FUNCTION get_immediate_subordinates(integer);
DROP type nested_category_record;
*/

CREATE SEQUENCE category_sq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE category_sq OWNER TO postgres;

-- Table: category

-- DROP TABLE category;

CREATE TABLE category
(
  category_id bigint NOT NULL DEFAULT nextval('category_sq'::regclass),
  name character varying(255) NOT NULL,
  diff_factor integer,
  image_path character varying(255),
  CONSTRAINT category_pkey PRIMARY KEY (category_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE category OWNER TO postgres;
GRANT ALL ON TABLE category TO postgres;
GRANT ALL ON TABLE category TO public;

CREATE SEQUENCE nested_category_sq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE nested_category_sq OWNER TO postgres;
      

CREATE TABLE nested_category (
	nested_category_id bigint PRIMARY KEY DEFAULT nextval('nested_category_sq'),
	category_id bigint NOT NULL,
        lft integer NOT NULL,
        rgt integer NOT NULL,
	type character varying(126) NOT NULL,
        CONSTRAINT nested_category_fk FOREIGN KEY (category_id)
      REFERENCES category (category_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nested_category OWNER TO postgres;
GRANT ALL ON TABLE nested_category TO postgres;
GRANT ALL ON TABLE nested_category TO public;



CREATE SEQUENCE sale_item_sq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE sale_item_sq OWNER TO postgres;


CREATE TABLE sale_item
(
  sale_item_id bigint NOT NULL DEFAULT nextval('sale_item_sq'::regclass),
  name character varying(255) NOT NULL,
  description character varying(510),
  enabled boolean,
  image_path character varying(255),
  base_price numeric DEFAULT 0,
  price_for character varying(100),
  CONSTRAINT sale_item_pkey PRIMARY KEY (sale_item_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE sale_item OWNER TO postgres;
GRANT ALL ON TABLE sale_item TO postgres;
GRANT ALL ON TABLE sale_item TO public;


CREATE TABLE nested_category_sale_item 
(
  sale_item_id bigint NOT NULL,
  nested_category_id bigint NOT NULL,
  display_name character varying(255),
  description character varying(510),
  price numeric DEFAULT 0,
  active boolean,
  CONSTRAINT nested_category_sale_item_pk PRIMARY KEY (sale_item_id, nested_category_id),
  CONSTRAINT nested_category_sale_item_fk1 FOREIGN KEY (sale_item_id)
      REFERENCES sale_item (item_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT nested_category_sale_item_fk2 FOREIGN KEY (nested_category_id)
      REFERENCES nested_category (nested_category_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nested_category_sale_item OWNER TO postgres;
GRANT ALL ON TABLE nested_category_sale_item TO postgres;
GRANT ALL ON TABLE nested_category_sale_item TO public;

-- Sequence: securityuser_sq


CREATE SEQUENCE securityuser_sq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 64
  CACHE 1;
ALTER TABLE securityuser_sq OWNER TO postgres;


-- Sequence: voicecontact_sq


CREATE SEQUENCE voicecontact_sq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 60
  CACHE 1;
ALTER TABLE voicecontact_sq OWNER TO postgres;

-- Sequence: locationcontact_sq

-- DROP SEQUENCE locationcontact_sq;

CREATE SEQUENCE locationcontact_sq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 68
  CACHE 1;
ALTER TABLE locationcontact_sq OWNER TO postgres;

-- Table: securityuser


CREATE TABLE securityuser
(
  userid bigint NOT NULL,
  othernames character varying(255),
  lastname character varying(255),
  gender character(1),
  createdon date,
  lastupdatedon date,
  title character varying(255),
  enabled boolean,
  "password" character varying(255),
  username character varying(255) NOT NULL,
  email character varying(255),
  CONSTRAINT securityuser_pkey PRIMARY KEY (userid),
  CONSTRAINT securityuser_username_key UNIQUE (username)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE securityuser OWNER TO postgres;
GRANT ALL ON TABLE securityuser TO postgres;
GRANT ALL ON TABLE securityuser TO public;

-- Table: voicecontact

CREATE TABLE voicecontact
(
  voicecontactid bigint NOT NULL,
  contacttype character varying(25),
  contactnumber character varying(125) NOT NULL,
  prioritylevel integer,
  CONSTRAINT voicecontact_pk PRIMARY KEY (voicecontactid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE voicecontact OWNER TO postgres;

-- Table: user_voicecontact


CREATE TABLE user_voicecontact
(
  voicecontactid bigint NOT NULL,
  userid bigint NOT NULL,
  CONSTRAINT user_voicecontact_pk PRIMARY KEY (voicecontactid, userid),
  CONSTRAINT user_voicecontact_fk1 FOREIGN KEY (userid)
      REFERENCES securityuser (userid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT user_voicecontact_fk2 FOREIGN KEY (voicecontactid)
      REFERENCES voicecontact (voicecontactid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE user_voicecontact OWNER TO postgres;

-- Table: locationcontact

-- DROP TABLE locationcontact;

CREATE TABLE locationcontact
	(
	  locationcontactid bigint NOT NULL,
	  addressline1 character varying(256) NOT NULL,
	  addressline2 character varying(256),
	  city character varying(126),
	  postcode character varying(126),
	  statecode character varying(126),
	  countrycode character varying(126),
	  prioriylevel integer,
	  CONSTRAINT locationcontact_pk PRIMARY KEY (locationcontactid)
	)
	WITH (
	  OIDS=FALSE
	);
	ALTER TABLE locationcontact OWNER TO postgres;

-- Table: user_locationcontact

-- DROP TABLE user_locationcontact;

CREATE TABLE user_locationcontact
(
  locationcontactid bigint NOT NULL,
  userid bigint NOT NULL,
  CONSTRAINT user_locationcontact_pk PRIMARY KEY (locationcontactid, userid),
  CONSTRAINT user_locationcontact_fk1 FOREIGN KEY (userid)
      REFERENCES securityuser (userid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT user_locationcontact_fk2 FOREIGN KEY (locationcontactid)
      REFERENCES locationcontact (locationcontactid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE user_locationcontact OWNER TO postgres;




-- Function: get_nested_category_depth(integer)

-- DROP FUNCTION get_nested_category_depth(integer);

CREATE OR REPLACE FUNCTION get_nested_category_depth(integer)
  RETURNS integer AS
$BODY$
	
		DECLARE
		retId integer;
		BEGIN
		SELECT (COUNT(parent.category_id) - 1) INTO retId
                FROM nested_category AS node,
                        nested_category AS parent
                WHERE node.type = parent.type 
			AND node.lft BETWEEN parent.lft AND parent.rgt
                        AND node.category_id = $1
                GROUP BY node.category_id;
		
		RETURN retId;
		END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION get_nested_category_depth(integer) OWNER TO postgres;



---DROP FUNCTION get_immediate_subordinates(integer);
---DROP type nested_category_record;

create type nested_category_record AS (
nested_category_id bigint,
nested_category_type character varying(255),
category_id bigint,
category_name character varying(255),
diff_factor integer,
image_path  character varying(255),
category_lft integer,
category_rgt integer,
category_depth bigint
);
-- Function: get_immediate_subordinates(integer)

-- DROP FUNCTION get_immediate_subordinates(integer);

CREATE OR REPLACE FUNCTION get_immediate_subordinates(integer)
  RETURNS SETOF nested_category_record AS
$BODY$
declare
r nested_category_record;
depth integer;
begin
SELECT * from get_nested_category_depth($1) INTO depth;
for r in SELECT node.nested_category_id AS nested_category_id,node.type AS nested_category_type,main_category.category_id AS category_id,main_category.name AS category_name,main_category.diff_factor AS diff_factor,main_category.image_path AS image_path,node.lft AS category_lft,node.rgt AS category_rgt, (COUNT(parent.category_id) - (depth+1)) AS category_depth
FROM nested_category AS node,
        nested_category AS parent,
        nested_category AS sub_parent,
	category AS main_category,
        (
                SELECT node.category_id, (COUNT(parent.category_id) - 1)
                FROM nested_category AS node,
                        nested_category AS parent
                WHERE node.type = parent.type
			AND node.lft BETWEEN parent.lft AND parent.rgt
                        AND node.category_id = $1
                GROUP BY node.category_id
                --ORDER BY node.lft
        )AS sub_tree
WHERE node.type = parent.type
	AND node.type = sub_parent.type
	AND node.lft BETWEEN parent.lft AND parent.rgt
        AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
        AND sub_parent.category_id = sub_tree.category_id
	AND node.category_id = main_category.category_id
	AND node.category_id <> $1
GROUP BY node.nested_category_id,node.type,main_category.category_id,main_category.name,main_category.diff_factor,main_category.image_path,node.lft,node.rgt
HAVING (COUNT(parent.category_id) - (depth+1)) <= 1
ORDER BY node.lft
loop
return next r;
end loop;
return;
end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION get_immediate_subordinates(integer) OWNER TO postgres;

-- Function: get_single_path(integer)

-- DROP FUNCTION get_single_path(integer);

CREATE OR REPLACE FUNCTION get_single_path(integer)
  RETURNS SETOF nested_category_record AS
$BODY$
declare
r nested_category_record;
begin
for r in SELECT parent.nested_category_id AS nested_category_id,parent.type AS nested_category_type,main_category.category_id AS category_id,main_category.name AS category_name,main_category.diff_factor AS diff_factor,main_category.image_path AS image_path,parent.lft AS category_lft,parent.rgt AS category_rgt
FROM nested_category AS node,
        nested_category AS parent,
        category AS main_category
        WHERE node.type = parent.type
	AND node.lft BETWEEN parent.lft AND parent.rgt
	AND parent.category_id=main_category.category_id
        AND node.nested_category_id = $1
ORDER BY parent.lft
loop
return next r;
end loop;
return;
end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION get_single_path(integer) OWNER TO postgres;

-- Function: get_nested_category_edge_id(text, integer)

-- DROP FUNCTION get_nested_category_edge_id(text, integer);

CREATE OR REPLACE FUNCTION get_nested_category_edge_id(text, integer)
  RETURNS integer AS
$BODY$
	
		DECLARE
		retId integer;
		BEGIN
		IF $1 = 'lft' THEN
			SELECT INTO retId lft FROM nested_category WHERE nested_category_id =$2;
		ELSE
			SELECT INTO retId rgt FROM nested_category WHERE nested_category_id =$2;
		END IF;
		IF retId IS NULL THEN
			RETURN 0;
		ELSE 
			RETURN retId;
		END IF;
		END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION get_nested_category_edge_id(text, integer) OWNER TO postgres;

-- Function: add_new_node(integer, integer, text, integer, text, text)

-- DROP FUNCTION add_new_node(integer, integer, text, integer, text, text);

CREATE OR REPLACE FUNCTION add_new_node(integer, integer, text, integer, text, text)
  RETURNS bigint AS
$BODY$
	
		DECLARE
		edgeid integer;
		nestedcatid bigint;
		catid bigint;
		BEGIN
		IF $1 > 0 THEN
			SELECT * from get_nested_category_edge_id('rgt',$1) INTO edgeid;
		ELSE
			SELECT * from get_nested_category_edge_id('lft',$2) INTO edgeid;
		END IF;
		IF edgeid = NULL THEN
			edgeid=0;
		END IF;
		UPDATE nested_category SET rgt = rgt + 2 WHERE type = $5 AND rgt > edgeid;
		UPDATE nested_category SET lft = lft + 2 WHERE type = $5 AND lft > edgeid;
		SELECT nextval ('nested_category_sq') INTO nestedcatid; 
		SELECT nextval ('category_sq') INTO catid;
		INSERT INTO category(category_id,name,diff_factor,image_path) VALUES(catid,$3,$4,$6);
		INSERT INTO nested_category(nested_category_id,category_id, lft, rgt,type) VALUES(nestedcatid,catid,edgeid + 1, edgeid + 2, $5);

		
		return nestedcatid;
		END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION add_new_node(integer, integer, text, integer, text, text) OWNER TO postgres;


-- Function: delete_nodes(integer, text)

-- DROP FUNCTION delete_nodes(integer, text);

CREATE OR REPLACE FUNCTION delete_nodes(integer, text)
  RETURNS boolean AS
$BODY$
	
		DECLARE
		lftId integer;
		rgtId integer;
		widthId integer;
		rec nested_category_record;
		BEGIN
		SELECT INTO lftId,rgtId 
		lft,rgt 
		FROM nested_category
		WHERE nested_category_id = $1;
		widthId := rgtId - lftId + 1;
		for rec in SELECT nested_category_id,category_id 
			FROM nested_category 
			WHERE type = $2 
			AND lft BETWEEN lftId AND rgtId
		loop
		DELETE FROM nested_category_sale_item WHERE nested_category_id=rec.nested_category_id;
		DELETE FROM nested_category WHERE nested_category_id=rec.nested_category_id;
		DELETE FROM category WHERE category_id=rec.category_id;
		end loop;
		
		UPDATE nested_category SET rgt = rgt - widthId WHERE type = $2 AND rgt > rgtId;
		UPDATE nested_category SET lft = lft - widthId WHERE type = $2 AND lft > rgtId;	
		return true;
		END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION delete_nodes(integer, text) OWNER TO postgres;

SELECT nextval('category_sq');
SELECT nextval('nested_category_sq');
insert into category values(36,'DELIVERY',0);
insert into nested_category values(36,36,1,2,'DELIVERY');
SELECT nextval('category_sq');
SELECT nextval('nested_category_sq');
insert into category values(37,'SALE_ITEMS',0);
insert into nested_category values(37,37,1,2,'ITEM');