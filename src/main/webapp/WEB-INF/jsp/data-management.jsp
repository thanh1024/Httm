<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Dữ liệu - PTHTTM</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
        }

        .header {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .header h1 {
            color: #1a202c;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .header p {
            color: #718096;
            font-size: 14px;
        }

        .actions {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
        }

        .btn-primary {
            background: #667eea;
            color: white;
        }

        .btn-primary:hover {
            background: #5568d3;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-success {
            background: #48bb78;
            color: white;
        }

        .btn-success:hover {
            background: #38a169;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(72, 187, 120, 0.4);
        }

        .btn-secondary {
            background: #e2e8f0;
            color: #4a5568;
        }

        .btn-secondary:hover {
            background: #cbd5e0;
        }

        .btn-danger {
            background: #f56565;
            color: white;
            padding: 8px 16px;
            font-size: 13px;
        }

        .btn-danger:hover {
            background: #e53e3e;
        }

        .btn-edit {
            background: #4299e1;
            color: white;
            padding: 8px 16px;
            font-size: 13px;
        }

        .btn-edit:hover {
            background: #3182ce;
        }

        .btn-view {
            background: #ed8936;
            color: white;
            padding: 8px 16px;
            font-size: 13px;
        }

        .btn-view:hover {
            background: #dd6b20;
        }

        .alert {
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: #c6f6d5;
            color: #22543d;
            border-left: 4px solid #48bb78;
        }

        .alert-error {
            background: #fed7d7;
            color: #742a2a;
            border-left: 4px solid #f56565;
        }

        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: #f7fafc;
        }

        th {
            padding: 16px;
            text-align: left;
            font-size: 13px;
            font-weight: 600;
            color: #4a5568;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e2e8f0;
        }

        td {
            padding: 16px;
            border-bottom: 1px solid #e2e8f0;
            color: #2d3748;
            font-size: 14px;
        }

        tr:hover {
            background: #f7fafc;
        }

        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-aspect {
            background: #bee3f8;
            color: #2c5282;
        }

        .badge-sentiment {
            background: #c6f6d5;
            color: #22543d;
        }

        .badge-classification {
            background: #feebc8;
            color: #7c2d12;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #718096;
        }

        .empty-state-icon {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.3;
        }

        .empty-state h3 {
            font-size: 20px;
            margin-bottom: 10px;
            color: #2d3748;
        }

        .empty-state p {
            font-size: 14px;
            margin-bottom: 20px;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .delete-form {
            display: inline;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .back-link:hover {
            color: #5568d3;
        }

        .stats {
            display: flex;
            gap: 20px;
            margin-top: 20px;
        }

        .stat-item {
            flex: 1;
            background: #f7fafc;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #667eea;
            display: block;
        }

        .stat-label {
            font-size: 13px;
            color: #718096;
            margin-top: 8px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <a href="/admin" class="back-link">
                ← Quay lại Dashboard
            </a>
            <h1>📊 Quản lý Dữ liệu Huấn luyện</h1>
            <p>Quản lý datasets và samples cho việc huấn luyện mô hình</p>
            
            <div class="stats">
                <div class="stat-item">
                    <span class="stat-value">${fn:length(dataSources)}</span>
                    <div class="stat-label">Tổng Datasets</div>
                </div>
                <div class="stat-item">
                    <span class="stat-value">
                        <c:set var="totalSamples" value="0" />
                        <c:forEach var="ds" items="${dataSources}">
                            <c:set var="totalSamples" value="${totalSamples + sampleCounts[ds.id]}" />
                        </c:forEach>
                        ${totalSamples}
                    </span>
                    <div class="stat-label">Tổng Samples</div>
                </div>
            </div>
        </div>

        <!-- Flash Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ✓ ${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ✗ ${error}
            </div>
        </c:if>

        <!-- Actions -->
        <div class="actions">
            <a href="/admin/data/new" class="btn btn-primary">
                ➕ Tạo Dataset Mới
            </a>
            <a href="/admin/data/import" class="btn btn-success">
                📥 Import từ CSV
            </a>
            <a href="/admin/training/form" class="btn btn-secondary">
                🚀 Bắt đầu Huấn luyện
            </a>
        </div>

        <!-- Datasets Table -->
        <div class="card">
            <div class="table-container">
                <c:choose>
                    <c:when test="${not empty dataSources}">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tên Dataset</th>
                                    <th>Loại Model</th>
                                    <th>Số Samples</th>
                                    <th>Nguồn</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ds" items="${dataSources}">
                                    <tr>
                                        <td><strong>#${ds.id}</strong></td>
                                        <td>
                                            <strong>${ds.name}</strong>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${ds.modelType == 'aspect'}">
                                                    <span class="badge badge-aspect">ASPECT</span>
                                                </c:when>
                                                <c:when test="${ds.modelType == 'sentiment'}">
                                                    <span class="badge badge-sentiment">SENTIMENT</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-classification">${ds.modelType}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <strong>${sampleCounts[ds.id]}</strong> samples
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty ds.fileUrl}">
                                                    📄 CSV File
                                                </c:when>
                                                <c:otherwise>
                                                    ✋ Thủ công
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${fn:substring(ds.createdAt, 0, 16)}</td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="/admin/data/${ds.id}/samples" class="btn btn-view">
                                                    👁 Xem Samples
                                                </a>
                                                <a href="/admin/data/${ds.id}/edit" class="btn btn-edit">
                                                    ✏ Sửa
                                                </a>
                                                <form action="/admin/data/${ds.id}/delete" method="post" 
                                                      class="delete-form"
                                                      onsubmit="return confirm('Bạn có chắc muốn xóa dataset này? Tất cả samples sẽ bị xóa.');">
                                                    <button type="submit" class="btn btn-danger">
                                                        🗑 Xóa
                                                    </button>
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
                            <div class="empty-state-icon">📂</div>
                            <h3>Chưa có dataset nào</h3>
                            <p>Bắt đầu bằng cách tạo dataset mới hoặc import từ file CSV</p>
                            <div class="actions" style="justify-content: center;">
                                <a href="/admin/data/new" class="btn btn-primary">
                                    ➕ Tạo Dataset Mới
                                </a>
                                <a href="/admin/data/import" class="btn btn-success">
                                    📥 Import từ CSV
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>

