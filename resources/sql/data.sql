SELECT * from get_immediate_subordinates(1);
/*INSERT INTO category values(1,'ITEMS');
INSERT INTO category values(2,'HOME');
INSERT INTO category values(3,'OFFICE');
INSERT INTO category values(4,'NSW');
INSERT INTO category values(5,'SYDNEY');
INSERT INTO category values(6,'NORTH WEST');
INSERT INTO category values(7,'FRUITS');
INSERT INTO category values(8,'VEGETABLES');
INSERT INTO category values(9,'APPLES');*/

/*INSERT INTO nested_category (nested_category_id,category_id,lft,rgt) VALUES(1,1,1,19);
INSERT INTO nested_category (nested_category_id,category_id,lft,rgt) VALUES(2,2,2,16);
INSERT INTO nested_category (nested_category_id,category_id,lft,rgt) VALUES(3,3,17,18);
INSERT INTO nested_category (nested_category_id,category_id,lft,rgt) VALUES(4,4,3,15);
INSERT INTO nested_category (nested_category_id,category_id,lft,rgt) VALUES(5,5,4,14);
INSERT INTO nested_category (nested_category_id,category_id,lft,rgt) VALUES(6,6,5,13);
INSERT INTO nested_category (nested_category_id,category_id,lft,rgt) VALUES(7,7,6,9);
INSERT INTO nested_category (nested_category_id,category_id,lft,rgt) VALUES(8,8,11,12);
INSERT INTO nested_category (nested_category_id,category_id,lft,rgt) VALUES(9,9,7,8);*/


----Retrieving all records-----
--SELECT c.* FROM nested_category nc,category c where c.category_id=nc.category_id ORDER BY c.category_id;
----Retrieving a Full Tree----
--SELECT coredata.* FROM nested_category AS node,nested_category AS parent,category AS coredata WHERE coredata.category_id=node.category_id and node.lft BETWEEN parent.lft AND parent.rgt AND parent.category_id = 1 ORDER BY coredata.category_id;
----Finding all the Leaf Nodes----
--SELECT c.* FROM nested_category nc,category c where c.category_id=nc.category_id and rgt = lft + 1;
----Retrieving a Single Path----
--SELECT * FROM category where category_id in (SELECT parent.category_id FROM nested_category AS node,nested_category AS parent WHERE node.lft BETWEEN parent.lft AND parent.rgt AND node.category_id = 8 ORDER BY node.lft);
----Finding the Depth of the Nodes----
/*SELECT coredata.name, (COUNT(parent.category_id) - 1) AS depth
FROM nested_category AS node,nested_category AS parent,category AS coredata
WHERE coredata.category_id=node.category_id and node.lft BETWEEN parent.lft AND parent.rgt
GROUP BY coredata.name;*/

/*SELECT node.category_id, (COUNT(parent.category_id)) AS depth
FROM nested_category AS node,
        nested_category AS parent,
        nested_category AS sub_parent,
        (
                SELECT node.category_id, (COUNT(parent.category_id) - 1) AS depth
                FROM nested_category AS node,
                        nested_category AS parent
                WHERE node.lft BETWEEN parent.lft AND parent.rgt
                        AND node.category_id = 2
                GROUP BY node.category_id
                --ORDER BY node.lft
        )AS sub_tree
WHERE node.lft BETWEEN parent.lft AND parent.rgt
        AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
        AND sub_parent.category_id = sub_tree.category_id
GROUP BY node.category_id
HAVING (COUNT(parent.category_id)) <= 2
--ORDER BY node.lft;
*/
---SELECT * FROM sale_item;
----produce a query that can retrieve our category tree, along with a product count for each category:
/*SELECT parent.name, COUNT(product.name)
FROM nested_category AS node ,
        nested_category AS parent,
        product
WHERE node.lft BETWEEN parent.lft AND parent.rgt
        AND node.category_id = product.category_id
GROUP BY parent.name;*/

--SELECT get_nested_categor_edge_id('rgt','ITEMS');

