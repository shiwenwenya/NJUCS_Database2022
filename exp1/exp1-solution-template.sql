-- 姓名：田馥雯
-- 学号：201220215
-- 提交前请确保本次实验独立完成，若有参考请注明并致谢。

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1
SELECT count(id) AS speciesCount
FROM species
WHERE species.description LIKE '%this%';
-- END Q1

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2
SELECT username, sum(phonemon.power) AS totalPhonemonPower
FROM player, phonemon
WHERE player.id = phonemon.player AND (player.username = 'Cook' OR player.username = 'Hughes')
GROUP BY player.username;
-- END Q2

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3
SELECT team.title AS title, count(player.id) AS numberOfPlayers
FROM team, player
WHERE team.id = player.team
GROUP BY team.title
ORDER BY numberOfPlayers DESC;
-- END Q3

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q4
SELECT species.id AS idSpecies, species.title AS title
FROM species, type
WHERE (species.type1 = type.id OR species.type2 = type.id) AND type.title = 'grass';
-- END Q4

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q5
SELECT player.id AS idPlayer, player.username AS username
FROM player
WHERE player.id NOT IN (
	SELECT purchase.player
	FROM purchase, item
	WHERE purchase.item = item.id AND item.type = 'F');
-- END Q5

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q6
SELECT player.level AS level, sum(item.price * purchase.quantity) AS totalAmountSpentByAllPlayersAtLevel
FROM player, purchase, item
WHERE player.id = purchase.player AND purchase.item = item.id
GROUP BY player.level
ORDER BY totalAmountSpentByAllPlayersAtLevel DESC;
-- END Q6

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q7
SELECT item.id AS item, item.title AS title, count(purchase.id) AS numTimesPurchased
FROM purchase, item
WHERE purchase.item = item.id
GROUP BY item.id
HAVING count(purchase.id) >= ALL(
	SELECT count(purchase.id)
	FROM purchase, item
	WHERE purchase.item = item.id
	GROUP BY item.id);
-- END Q7

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q8
SELECT player.id AS playerID, player.username AS username, count(DISTINCT item.id) AS numberDistinctFoodItemsPurchased
FROM player, purchase, item
WHERE (player.id = purchase.player AND purchase.item = item.id) AND item.type = 'F'
GROUP BY player.id
HAVING numberDistinctFoodItemsPurchased = ALL(
	SELECT count(*)
    FROM food);
-- END Q8

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q9
SELECT count(*) AS numberOfPhonemonPairs, ROUND(sqrt(pow(P1.latitude - P2.latitude, 2) + pow(P1.longitude - P2.longitude, 2)) * 100, 6) AS distanceX
FROM phonemon AS P1, phonemon AS P2
WHERE P1.id < P2.id
GROUP BY distanceX
HAVING distanceX <= ALL(
	SELECT ROUND(sqrt(pow(P1.latitude - P2.latitude, 2) + pow(P1.longitude - P2.longitude, 2)) * 100, 6)
    FROM phonemon AS P1, phonemon AS P2
    WHERE P1.id < P2.id);
-- END Q9

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q10
SELECT player.username AS username, type.title AS typeTitle
FROM player, phonemon, species, type
WHERE player.id = phonemon.player AND phonemon.species = species.id AND (species.type1 = type.id OR species.type2 = type.id)
GROUP BY player.id, type.id
HAVING count(DISTINCT species.id) = ALL(
	SELECT count(*)
	FROM species, type
    WHERE (species.type1 = type.id OR species.type2 = type.id) AND type.title = typeTitle);

-- END Q10