<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Huấn luyện Mô hình</title>

    <style>
      :root {
        --bg: #f5f6f8;
        --panel: #ffffff;
        --text: #111827;
        --muted: #6b7280;
        --primary: #2563eb;
        --primary-weak: #e6efff;
        --border: #e5e7eb;
      }
      * {
        box-sizing: border-box;
      }
      body {
        margin: 0;
        font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica,
        Arial, sans-serif;
        color: var(--text);
        background: var(--bg);
      }

      /* Header (Nav trên cùng) */
      header {
        background: #fff;
        border-bottom: 1px solid var(--border);
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 0 20px;
        height: 56px;
      }
      .tabs {
        display: flex;
        gap: 8px;
      }
      .tab {
        text-decoration: none;
        color: #374151;
        padding: 8px 12px;
        border-radius: 8px;
        font-weight: 500;
      }
      .tab.active {
        background: var(--primary-weak);
        color: #1e40af;
      }

      /* Main */
      main {
        padding: 24px;
        max-width: 900px;
        margin: 0 auto;
      }
      .page-title {
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 20px;
      }

      /* Panels (Khung nội dung) */
      .panel {
        background: var(--panel);
        border: 1px solid var(--border);
        border-radius: 12px;
        padding: 24px;
        display: flex;
        flex-direction: column;
        gap: 20px;
        margin-bottom: 20px;
      }
      .panel-head {
        display: flex;
        justify-content: space-between;
        flex-wrap: wrap;
        border-bottom: 1px solid var(--border);
        padding-bottom: 16px;
        margin-bottom: 8px;
      }
      .panel-title {
        font-size: 18px;
        font-weight: 700;
      }

      /* Form Elements */
      .form-group {
        margin-bottom: 20px;
      }
      .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        font-size: 14px;
      }
      .form-control {
        width: 100%;
        padding: 10px 12px;
        border: 1px solid var(--border);
        border-radius: 8px;
        font-size: 14px;
        background: #fff;
      }

      /* Checkbox list (Bổ sung style) */
      .data-source-list {
        border: 1px solid var(--border);
        padding: 16px;
        border-radius: 8px;
        max-height: 250px;
        overflow-y: auto;
        margin-bottom: 15px;
        background: #f9fafb; /* Nền mờ cho danh sách */
      }
      .data-source-item {
        display: block;
        margin-bottom: 10px;
        font-weight: 500;
        cursor: pointer;
        padding: 8px;
        border-radius: 6px;
      }
      .data-source-item:hover {
        background: #f0f9ff;
      }
      .data-source-item input {
        margin-right: 10px;
        transform: scale(1.1);
        vertical-align: middle;
      }
      .data-source-item .date {
        font-size: 12px;
        color: var(--muted);
        margin-left: 8px;
        font-weight: 400;
      }

      /* Buttons */
      .btn {
        align-self: start;
        background: var(--primary);
        color: #fff;
        border: none;
        border-radius: 8px;
        padding: 12px 18px;
        font-weight: 600;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
      }
      .btn:disabled {
        background: #9ca3af;
        cursor: not-allowed;
      }

      /* Thông báo */
      .message {
        padding: 12px 16px;
        border-radius: 8px;
        background: #f0fdf4;
        color: #15803d;
        border: 1px solid #bbf7d0;
        margin-bottom: 20px;
      }
      .error {
        padding: 12px 16px;
        border-radius: 8px;
        background: #fef2f2;
        color: #b91c1c;
        border: 1px solid #fecaca;
        margin-bottom: 20px;
      }

      /* Responsive */
      @media (max-width: 600px) {
        main {
          padding: 16px;
        }
      }
    </style>
</head>
<body>

<header>
    <div class="tabs">
        <a class="tab" href="/admin/dashboard">Bảng điều khiển</a>
        <a class="tab" href="/admin/data/upload">Quản lý dữ liệu</a>
        <a class="tab active" href="/admin/training/form">Huấn luyện Mô hình</a>
        <%-- <a class="tab" href="/admin/dashboard">Bảng điều khiển</a> --%>
    </div>
</header>

<main>
    <div class="page-title">Huấn luyện phiên bản mô hình mới</div>

    <c:if test="${not empty message}">
        <p class="message">${message}</p>
    </c:if>
    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>

    <article class="panel">
        <div class="panel-head">
            <div class="panel-title">Cấu hình huấn luyện</div>
        </div>

        <form method="POST" action="/admin/training/start" id="trainingForm">
            <!-- Bước 1: Chọn loại model -->
            <div class="form-group">
                <label for="modelType">Loại Model <span style="color: red;">*</span></label>
                <select id="modelType" name="modelType" class="form-control" required onchange="filterDataSources()">
                    <option value="">-- Chọn loại model --</option>
                    <option value="general" ${selectedModelType == 'general' ? 'selected' : ''}>General Sentiment (Tổng quát)</option>
                    <option value="aspect" ${selectedModelType == 'aspect' ? 'selected' : ''}>Aspect-Based Sentiment (Theo khía cạnh)</option>
                </select>
                <small style="color: #6b7280; display: block; margin-top: 4px;">
                    General: Phân tích sentiment tổng quan. Aspect: Phân tích theo từng khía cạnh (nội dung, hình thức, giá cả,...)
                </small>
            </div>

            <!-- Bước 2: Tên phiên bản -->
            <div class="form-group">
                <label for="versionName">Tên phiên bản mô hình mới <span style="color: red;">*</span></label>
                <input type="text" id="versionName" name="versionName" class="form-control"
                       placeholder="e.g., general_v1.1 hoặc aspect_v2.0" required>
            </div>

            <!-- Bước 3: Chọn data sources -->
            <div class="form-group">
                <label>Chọn nguồn dữ liệu để huấn luyện <span style="color: red;">*</span></label>
                <c:if test="${not empty selectedModelType}">
                    <small style="color: #6b7280; display: block; margin-bottom: 8px;">
                        Đang hiển thị data sources cho model: <strong>${selectedModelType}</strong>
                    </small>
                </c:if>

                <div class="data-source-list">
                    <c:choose>
                        <c:when test="${not empty dataSources}">
                            <c:forEach var="ds" items="${dataSources}">
                                <label class="data-source-item">
                                    <input type="checkbox" name="dataSourceIds" value="${ds.id}">
                                    <div>
                                        <strong>${ds.name}</strong>
                                        <small style="color: #6b7280; display: block;">
                                            Type: ${ds.modelType} | Created: ${fn:substring(ds.createdAt, 0, 16)}
                                        </small>
                                    </div>
                                </label>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p style="color: #6b7280;">
                                <c:choose>
                                    <c:when test="${not empty selectedModelType}">
                                        Không tìm thấy nguồn dữ liệu cho model type <strong>${selectedModelType}</strong>.
                                    </c:when>
                                    <c:otherwise>
                                        Vui lòng chọn loại model ở trên để hiển thị nguồn dữ liệu tương ứng.
                                    </c:otherwise>
                                </c:choose>
                                <a href="/admin/data/upload">Tải lên dữ liệu mới</a>
                            </p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <button type="submit" class="btn" 
                    <c:if test="${empty dataSources || empty selectedModelType}">disabled</c:if>>
                Bắt đầu Huấn luyện
            </button>
        </form>
    </article>
</main>

<script>
    function filterDataSources() {
        const modelType = document.getElementById('modelType').value;
        if (modelType) {
            // Reload page với modelType parameter để filter data sources
            window.location.href = '/admin/training/form?modelType=' + modelType;
        }
    }
    
    // Validate form trước khi submit
    document.getElementById('trainingForm').addEventListener('submit', function(e) {
        const modelType = document.getElementById('modelType').value;
        const checkedBoxes = document.querySelectorAll('input[name="dataSourceIds"]:checked');
        
        if (!modelType) {
            e.preventDefault();
            alert('Vui lòng chọn loại model');
            return false;
        }
        
        if (checkedBoxes.length === 0) {
            e.preventDefault();
            alert('Vui lòng chọn ít nhất một nguồn dữ liệu');
            return false;
        }
    });
</script>

</body>
</html>