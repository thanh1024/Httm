<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Upload dữ liệu</title>

    <%--
      TOÀN BỘ CSS ĐƯỢC NHÚNG TRỰC TIẾP TẠI ĐÂY
      (Dựa trên file dashboard của bạn + style cho form)
    --%>
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
        justify-content: center; /* Đưa tab ra giữa */
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
        max-width: 900px; /* Giới hạn chiều rộng cho form */
        margin: 0 auto; /* Căn giữa */
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
        line-height: 1.3;
      }

      /* Form Elements (Bổ sung) */
      .form-group {
        margin-bottom: 20px;
      }
      .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        font-size: 14px;
      }
      /* Áp dụng style cho input */
      .form-control {
        width: 100%;
        padding: 10px 12px;
        border: 1px solid var(--border);
        border-radius: 8px;
        font-size: 14px;
        background: #fff;
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

      /* Thông báo (cho message/error) */
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
        <a class="tab active" href="/admin/data/upload">Quản lý dữ liệu</a>
        <a class="tab" href="/admin/training/form">Huấn luyện Mô hình</a>

    </div>
</header>


<main>
    <div class="page-title">Tải lên tệp dữ liệu</div>

    <c:if test="${not empty message}">
        <p class="message">${message}</p>
    </c:if>
    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>

    <article class="panel">
        <div class="panel-head">
            <div class="panel-title">Tải lên tệp dữ liệu (Excel/CSV)</div>
        </div>

        <form method="POST" action="/admin/data/upload" enctype="multipart/form-data">

            <div class="form-group">
                <label for="dataSourceName">Tên nguồn dữ liệu:</label>
                <input type="text" id="dataSourceName" name="dataSourceName" class="form-control"
                       placeholder="e.g., Dữ liệu T10/2025" required>
            </div>

            <div class="form-group">
                <label for="modelType">Loại Model <span style="color: red;">*</span></label>
                <select id="modelType" name="modelType" class="form-control" required>
                    <option value="">-- Chọn loại model --</option>
                    <option value="general">General Sentiment (Tổng quát)</option>
                    <option value="aspect">Aspect-Based Sentiment (Theo khía cạnh)</option>
                </select>
                <small style="color: #6b7280; display: block; margin-top: 4px;">
                    General: Dữ liệu để train model phân tích sentiment tổng quan<br>
                    Aspect: Dữ liệu để train model phân tích theo từng khía cạnh
                </small>
            </div>

            <div class="form-group">
                <label for="file">Chọn tệp Excel/CSV:</label>
                <input type="file" id="file" name="file" class="form-control"
                       accept=".xlsx, .xls, .csv" required>
                <small style="color: #6b7280; display: block; margin-top: 4px;">
                    Chấp nhận file: .xlsx, .xls, .csv (phân cách bằng dấu |)
                </small>
            </div>

            <button type="submit" class="btn">Tải lên và Lưu</button>
        </form>
    </article>
</main>

</body>
</html>