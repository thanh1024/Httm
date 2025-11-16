<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Samples - ${dataSource.name}</title>
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
            max-width: 1400px;
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
            margin-bottom: 5px;
        }

        .header .dataset-info {
            color: #718096;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 10px;
        }

        .badge-aspect {
            background: #bee3f8;
            color: #2c5282;
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

        .alert {
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
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

        .table-header {
            padding: 20px;
            background: #f7fafc;
            border-bottom: 2px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-header h2 {
            font-size: 18px;
            color: #2d3748;
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

        .text-preview {
            max-width: 500px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .text-preview:hover {
            white-space: normal;
            overflow: visible;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .delete-form {
            display: inline;
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

        .label-badge {
            padding: 4px 10px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
        }

        .label-positive {
            background: #c6f6d5;
            color: #22543d;
        }

        .label-negative {
            background: #fed7d7;
            color: #742a2a;
        }

        .label-neutral {
            background: #e2e8f0;
            color: #4a5568;
        }

        .stats-bar {
            display: flex;
            gap: 20px;
            padding: 20px;
            background: #f7fafc;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .stat-item {
            flex: 1;
            text-align: center;
        }

        .stat-value {
            font-size: 24px;
            font-weight: 700;
            color: #667eea;
        }

        .stat-label {
            font-size: 12px;
            color: #718096;
            margin-top: 4px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <a href="/admin/data" class="back-link">
                ← Quay lại Danh sách Dataset
            </a>
            <h1>📝 Quản lý Samples</h1>
            <div class="dataset-info">
                <strong>${dataSource.name}</strong>
                <span class="badge badge-aspect">${dataSource.modelType}</span>
                <span style="margin-left: 15px; color: #a0aec0;">
                    Dataset ID: #${dataSource.id}
                </span>
            </div>

            <div class="stats-bar">
                <div class="stat-item">
                    <div class="stat-value">${fn:length(samples)}</div>
                    <div class="stat-label">Tổng Samples</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">
                        <c:set var="positiveCount" value="0" />
                        <c:forEach var="sample" items="${samples}">
                            <c:if test="${sample.label == 'POSITIVE' || sample.rating >= 4}">
                                <c:set var="positiveCount" value="${positiveCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${positiveCount}
                    </div>
                    <div class="stat-label">Positive</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">
                        <c:set var="neutralCount" value="0" />
                        <c:forEach var="sample" items="${samples}">
                            <c:if test="${sample.label == 'NEUTRAL' || (sample.rating == 3 && sample.label == null)}">
                                <c:set var="neutralCount" value="${neutralCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${neutralCount}
                    </div>
                    <div class="stat-label">Neutral</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">
                        <c:set var="negativeCount" value="0" />
                        <c:forEach var="sample" items="${samples}">
                            <c:if test="${sample.label == 'NEGATIVE' || (sample.rating != null && sample.rating <= 2)}">
                                <c:set var="negativeCount" value="${negativeCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${negativeCount}
                    </div>
                    <div class="stat-label">Negative</div>
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
            <a href="/admin/data/${dataSource.id}/samples/new" class="btn btn-primary">
                ➕ Thêm Sample Mới
            </a>
            <a href="/admin/data/${dataSource.id}/edit" class="btn btn-success">
                ✏ Sửa Thông tin Dataset
            </a>
        </div>

        <!-- Samples Table -->
        <div class="card">
            <div class="table-header">
                <h2>Danh sách Samples (${fn:length(samples)})</h2>
            </div>
            <div class="table-container">
                <c:choose>
                    <c:when test="${not empty samples}">
                        <table>
                            <thead>
                                <tr>
                                    <th style="width: 60px;">ID</th>
                                    <th style="width: 50px;">#</th>
                                    <th>Nội dung Text</th>
                                    <th style="width: 100px;">Rating</th>
                                    <th style="width: 120px;">Label</th>
                                    <th style="width: 200px;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="sample" items="${samples}" varStatus="status">
                                    <tr>
                                        <td><strong>#${sample.id}</strong></td>
                                        <td>${sample.rowIndex != null ? sample.rowIndex + 1 : status.index + 1}</td>
                                        <td>
                                            <div class="text-preview" title="${sample.text}">
                                                ${sample.text}
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty sample.rating}">
                                                    <strong>${sample.rating}</strong>/5
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #a0aec0;">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${sample.label == 'POSITIVE'}">
                                                    <span class="label-badge label-positive">POSITIVE</span>
                                                </c:when>
                                                <c:when test="${sample.label == 'NEGATIVE'}">
                                                    <span class="label-badge label-negative">NEGATIVE</span>
                                                </c:when>
                                                <c:when test="${sample.label == 'NEUTRAL'}">
                                                    <span class="label-badge label-neutral">NEUTRAL</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #a0aec0;">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="/admin/data/${dataSource.id}/samples/${sample.id}/edit" 
                                                   class="btn btn-edit">
                                                    ✏ Sửa
                                                </a>
                                                <form action="/admin/data/${dataSource.id}/samples/${sample.id}/delete" 
                                                      method="post" 
                                                      class="delete-form"
                                                      onsubmit="return confirm('Bạn có chắc muốn xóa sample này?');">
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
                            <div class="empty-state-icon">📄</div>
                            <h3>Chưa có sample nào</h3>
                            <p>Bắt đầu bằng cách thêm sample đầu tiên cho dataset này</p>
                            <a href="/admin/data/${dataSource.id}/samples/new" class="btn btn-primary">
                                ➕ Thêm Sample Đầu Tiên
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>

