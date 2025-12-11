--Group by/Having
SELECT Id_Cliente
FROM FazPedido
GROUP BY Id_Cliente
HAVING COUNT(Id_Pedido) > 3
-- mostra o ID dos clientes que realizaram mais de 3 pedidos


--Junção interna
SELECT F.Nome, FP.Id_Pedido
FROM Funcionario F JOIN FazPedido FP ON (F.CPF_Func = FP.CPF_Func)
-- mostra o nome dos funcionários ao lado do ID dos pedidos feitos por eles


--Junção externa
SELECT P.Nome
FROM Produto P LEFT OUTER JOIN Item_Pedido I ON (P.Id_Prod = I.Id_Prod)
WHERE I.Id_Pedido IS NULL
-- mostra o nome dos produtos que ainda não foram vendidos


--Semi junção
SELECT Nome
From PF
WHERE EXISTS (
    SELECT 1
    FROM FazPedido FP
    WHERE FP.Id_Cliente = PF.Id_Cliente
)
-- mostra o nome dos clientes ativos (que fizeram pelo menos um pedido)


--Anti-junção
SELECT Nome
FROM Produto P
WHERE NOT EXISTS (
    SELECT 1
    FROM Item_Pedido I
    WHERE I.Id_Prod = P.Id_Prod
)
-- mostra o nome dos produtos que nunca foram vendidos


--Subconsulta do tipo escalar
SELECT Nome, Preço
FROM Produto
WHERE Preço > (
    SELECT AVG(Preço)
    FROM Produto
)
-- mostra o nome e o preço dos produtos que custam mais do que a média


--Subconsulta do tipo linha
SELECT Id_Pedido, nro_item
FROM Item_Pedido
WHERE (Id_Prod, quantidade) = (
    SELECT Id_Prod, quantidade
    FROM Item_Pedido
    WHERE Id_Pedido = 7 AND nro_item = 2
)
-- mostra o ID e o número do item de compras idênticas (mesmo produto e quantidade) à compra do item 2 do pedido com ID 7


--Subconsulta do tipo tabela
SELECT Nome
FROM Funcionario
WHERE CPF_Func IN (
    SELECT CPF_Supervisor
    FROM Funcionario
    WHERE CPF_Supervisor IS NOT NULL
)
-- mostra o nome dos funcionários que são supervisores


--Operação de conjunto
SELECT Nome FROM PF
UNION
SELECT Nome FROM Funcionario
-- exibe uma lista única com o nome de todos os clientes e funcionários, unindo os dois conjuntos


--01 procedimento com SQL embutida e parâmetro, função com SQL embutida e parâmetro ou gatilho
CREATE OR REPLACE FUNCTION Calcular_Total_Itens(p_id_pedido IN NUMBER) RETURN NUMBER IS
    v_total NUMBER(10,2);
BEGIN
    -- Seleciona a soma do valor dos itens para o pedido informado
    SELECT SUM(quantidade * valor_unitario)
    INTO v_total
    FROM Item_Pedido
    WHERE Id_Pedido = p_id_pedido;

    RETURN v_total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/
-- recebe o ID de um pedido como parâmetro e retorna o valor total, calculado somando os itens
