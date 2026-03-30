WITH RECURSIVE AllSubordinates AS (
    -- Рекурсивно строим иерархию подчиненных для всех сотрудников
    SELECT 
        EmployeeID,
        Name,
        ManagerID,
        DepartmentID,
        RoleID,
        EmployeeID AS RootManagerID  -- сохраняем исходного "руководителя"
    FROM Employees

    UNION ALL

    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID,
        a.RootManagerID
    FROM Employees e
    INNER JOIN AllSubordinates a ON e.ManagerID = a.EmployeeID
)
SELECT 
    m.EmployeeID,
    m.Name AS EmployeeName,
    m.ManagerID,
    d.DepartmentName,
    r.RoleName,
    -- Проекты по отделу
    GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ') AS Projects,
    -- Задачи
    GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ') AS Tasks,
    -- Общее количество всех подчиненных (рекурсивно)
    COUNT(DISTINCT a.EmployeeID) AS TotalSubordinates
FROM Employees m
-- Роль менеджера
INNER JOIN Roles r ON m.RoleID = r.RoleID AND r.RoleName = 'Менеджер'
LEFT JOIN Departments d ON m.DepartmentID = d.DepartmentID
LEFT JOIN Projects p ON p.DepartmentID = m.DepartmentID
LEFT JOIN Tasks t ON t.AssignedTo = m.EmployeeID
-- Подсчет всех подчиненных
LEFT JOIN AllSubordinates a ON a.RootManagerID = m.EmployeeID AND a.EmployeeID != m.EmployeeID
GROUP BY m.EmployeeID, m.Name, m.ManagerID, d.DepartmentName, r.RoleName
HAVING TotalSubordinates > 0
ORDER BY m.Name;