<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Mẫu - ${dataSource.name}</title>
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
            max-width: 1400px;
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
        }
        .header h1 {
            font-size: 28px;
            margin-bottom: 8px;
        }
        .header .dataset-info {
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
        .sample-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .sample-table th {
            background: #f8f9fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
        }
        .sample-table td {
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
            vertical-align: top;
        }
        .sample-table tr:hover {
            background: #f8f9fa;
        }
        .sample-text {
            max-width: 600px;
            word-wrap: break-word;
            line-height: 1.6;
            color: #212529;
        }
        .sample-label {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        .label-positive {
            background: #d4edda;
            color: #155724;
        }
        .label-neutral {
            background: #fff3cd;
            color: #856404;
        }
        .label-negative {
            background: #f8d7da;
            color: #721c24;
        }
        .rating-stars {
            color: #ffc107;
            font-size: 16px;
        }
        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
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
        .stats-bar {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
        }
        .stat-item {
            flex: 1;
            min-width: 150px;
        }
        .stat-label {
            font-size: 13px;
            color: #6c757d;
            margin-bottom: 5px;
        }
        .stat-value {
            font-size: 24px;
            font-weight: 700;
            color: #667eea;
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
            <h1>📝 Quản Lý Mẫu</h1>
            <div class="dataset-info">Dataset: ${dataSource.name}</div>
        </div>
        
        <div class="nav-menu">
            <a href="/admin/dashboard" class="nav-link">Bảng điều khiển</a>
            <a href="/admin/data/list" class="nav-link active">Quản lý dữ liệu</a>
            <a href="/admin/training/form" class="nav-link">Huấn luyện Mô hình</a>
        </div>
        
        <div class="content">
            <a href="/admin/data/list" class="back-link">← Quay lại Danh sách Dataset</a>
            
            <!-- Flash Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <!-- Stats Bar -->
            <div class="stats-bar">
                <div class="stat-item">
                    <div class="stat-label">Tổng Mẫu</div>
                    <div class="stat-value">${fn:length(samples)}</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">Dataset ID</div>
                    <div class="stat-value" style="font-size: 18px;">#${dataSource.id}</div>
                </div>
            </div>
            
            <!-- Action Bar -->
            <div class="action-bar">
                <h2 style="margin: 0; color: #495057;">Danh sách Mẫu</h2>
                <a href="/admin/data/samples/${dataSource.id}/new" class="btn btn-primary">➕ Thêm Mẫu Mới</a>
            </div>
            
            <!-- Samples Table -->
            <c:choose>
                <c:when test="${not empty samples}">
                    <table class="sample-table">
                        <thead>
                            <tr>
                                <th style="width: 60px;">ID</th>
                                <th>Nội Dung</th>
                                <th style="width: 120px;">Rating</th>
                                <th style="width: 120px;">Label</th>
                                <th style="width: 200px;">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="sample" items="${samples}" varStatus="status">
                                <tr>
                                    <td style="text-align: center; color: #6c757d; font-weight: 600;">
                                        #${sample.id}
                                    </td>
                                    <td>
                                        <div class="sample-text">${sample.text}</div>
                                    </td>
                                    <td style="text-align: center;">
                                        <c:if test="${not empty sample.rating && sample.rating > 0}">
                                            <div class="rating-stars">
                                                <c:forEach begin="1" end="${sample.rating}">★</c:forEach>
                                            </div>
                                            <div style="font-size: 12px; color: #6c757d; margin-top: 2px;">
                                                ${sample.rating}/5
                                            </div>
                                        </c:if>
                                        <c:if test="${empty sample.rating || sample.rating == 0}">
                                            <span style="color: #adb5bd;">-</span>
                                        </c:if>
                                    </td>
                                    <td style="text-align: center;">
                                        <c:if test="${not empty sample.label}">
                                            <c:choose>
                                                <c:when test="${fn:toUpperCase(sample.label) == 'POSITIVE'}">
                                                    <span class="sample-label label-positive">POSITIVE</span>
                                                </c:when>
                                                <c:when test="${fn:toUpperCase(sample.label) == 'NEUTRAL'}">
                                                    <span class="sample-label label-neutral">NEUTRAL</span>
                                                </c:when>
                                                <c:when test="${fn:toUpperCase(sample.label) == 'NEGATIVE'}">
                                                    <span class="sample-label label-negative">NEGATIVE</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="sample-label" style="background: #e9ecef; color: #495057;">
                                                        ${sample.label}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                        <c:if test="${empty sample.label}">
                                            <span style="color: #adb5bd;">-</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a href="/admin/data/samples/edit/${sample.id}" class="btn btn-secondary btn-sm">✏️ Sửa</a>
                                            <form action="/admin/data/samples/delete/${sample.id}" method="post" style="display: inline;" 
                                                  onsubmit="return confirm('Bạn có chắc muốn xóa mẫu này?');">
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
                            <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                        </svg>
                        <h3>Chưa có mẫu nào</h3>
                        <p>Hãy thêm mẫu mới cho dataset này</p>
                        <a href="/admin/data/samples/${dataSource.id}/new" class="btn btn-primary" style="margin-top: 20px;">
                            ➕ Thêm Mẫu Đầu Tiên
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>

