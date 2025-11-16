<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Dữ Liệu - PhoBERT Aspect Sentiment</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .header h1 {
            font-size: 28px;
            margin-bottom: 8px;
        }
        .header p {
            opacity: 0.9;
            font-size: 14px;
        }
        .content {
            padding: 30px;
        }
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            gap: 15px;
            flex-wrap: wrap;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
        .btn-success {
            background: #28a745;
            color: white;
        }
        .btn-success:hover {
            background: #218838;
        }
        .btn-danger {
            background: #dc3545;
            color: white;
            font-size: 13px;
            padding: 8px 16px;
        }
        .btn-danger:hover {
            background: #c82333;
        }
        .btn-sm {
            padding: 6px 12px;
            font-size: 13px;
        }
        .dataset-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .dataset-table th {
            background: #f8f9fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
        }
        .dataset-table td {
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
        }
        .dataset-table tr:hover {
            background: #f8f9fa;
        }
        .dataset-name {
            font-weight: 600;
            color: #667eea;
            font-size: 15px;
        }
        .dataset-type {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            background: #e7f5ff;
            color: #1971c2;
        }
        .dataset-meta {
            font-size: 13px;
            color: #6c757d;
            margin-top: 5px;
        }
        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .import-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .import-section h3 {
            margin-bottom: 15px;
            color: #495057;
            font-size: 16px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #495057;
            font-size: 14px;
        }
        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        .form-control:focus {
            outline: none;
            border-color: #667eea;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        .empty-state svg {
            width: 100px;
            height: 100px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .nav-menu {
            background: #f8f9fa;
            padding: 15px 30px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .nav-link {
            text-decoration: none;
            color: #495057;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.2s;
        }
        .nav-link:hover {
            background: #e9ecef;
        }
        .nav-link.active {
            background: #667eea;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 Quản Lý Dữ Liệu</h1>
            <p>Quản lý datasets và mẫu dữ liệu huấn luyện</p>
        </div>
        
        <div class="nav-menu">
            <a href="/admin/dashboard" class="nav-link">Bảng điều khiển</a>
            <a href="/admin/data/list" class="nav-link active">Quản lý dữ liệu</a>
            <a href="/admin/training/form" class="nav-link">Huấn luyện Mô hình</a>
        </div>
        
        <div class="content">
            
            <!-- Flash Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <!-- Import CSV Section -->
            <div class="import-section">
                <h3>📥 Import Dataset từ CSV</h3>
                <form action="/admin/data/import" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label>Tên Dataset</label>
                        <input type="text" name="name" class="form-control" placeholder="Ví dụ: Dataset Review Sách" required>
                    </div>
                    <div class="form-group">
                        <label>File CSV</label>
                        <input type="file" name="file" class="form-control" accept=".csv" required>
                        <small style="color: #6c757d; display: block; margin-top: 5px;">
                            Format: text|rating hoặc text,rating hoặc text	rating (tab-separated)
                        </small>
                    </div>
                    <button type="submit" class="btn btn-success">📥 Import CSV</button>
                </form>
            </div>
            
            <!-- Action Bar -->
            <div class="action-bar">
                <h2 style="margin: 0; color: #495057;">Danh sách Datasets</h2>
                <a href="/admin/data/new" class="btn btn-primary">➕ Tạo Dataset Mới</a>
            </div>
            
            <!-- Datasets Table -->
            <c:choose>
                <c:when test="${not empty dataSources}">
                    <table class="dataset-table">
                        <thead>
                            <tr>
                                <th>Dataset</th>
                                <th>Số Mẫu</th>
                                <th>Nguồn</th>
                                <th>Ngày Tạo</th>
                                <th>Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ds" items="${dataSources}">
                                <tr>
                                    <td>
                                        <div class="dataset-name">${ds.name}</div>
                                    </td>
                                    <td>
                                        <strong style="color: #667eea;">${fn:length(ds.samples)}</strong> mẫu
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty ds.fileUrl}">
                                                <span style="color: #28a745;">📄 CSV</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #6c757d;">✏️ Manual</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="dataset-meta">${fn:substring(ds.createdAt, 0, 16)}</div>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a href="/admin/data/samples/${ds.id}" class="btn btn-primary btn-sm">📝 Quản Lý Mẫu</a>
                                            <form action="/admin/data/delete/${ds.id}" method="post" style="display: inline;" 
                                                  onsubmit="return confirm('Bạn có chắc muốn xóa dataset này? Tất cả mẫu sẽ bị xóa.');">
                                                <button type="submit" class="btn btn-danger btn-sm">🗑️ Xóa</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                        </svg>
                        <h3>Chưa có dataset nào</h3>
                        <p>Hãy import CSV hoặc tạo dataset mới</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>

