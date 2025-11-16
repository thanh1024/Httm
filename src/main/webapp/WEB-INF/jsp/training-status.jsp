<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Trạng thái huấn luyện</title>

    <meta http-equiv="refresh" content="10">

    <%--
      TOÀN BỘ CSS ĐƯỢC NHÚNG TRỰC TIẾP TẠI ĐÂY
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
      }
      .panel-title {
        font-size: 18px;
        font-weight: 700;
      }
      .panel-sub {
        font-size: 14px;
        color: var(--muted);
        font-weight: 500;
        align-self: flex-end;
      }

      /* Status / Result Boxes (Bổ sung) */
      .status-box {
        border: 1px solid var(--border);
        border-radius: 12px;
        padding: 24px;
      }
      /* Style cho trạng thái đang chạy */
      .status-box.pending {
        border-color: #f59e0b;
        background-color: #fffbeb;
      }
      .status-box h2 {
        margin-top: 0;
        font-size: 20px;
        color: #b45309;
      }
      .status-box p {
        font-size: 15px;
        color: #374151;
      }

      /* Spinner (Bổ sung) */
      .spinner {
        border: 4px solid #f3f4f6;
        border-top: 4px solid var(--primary);
        border-radius: 50%;
        width: 24px;
        height: 24px;
        animation: spin 1s linear infinite;
        display: inline-block;
        margin-right: 12px;
        vertical-align: middle;
      }
      @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
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
      .btn-secondary {
        background: #fff;
        color: var(--text);
        border: 1px solid var(--border);
      }

      /* Thông báo lỗi */
      .error {
        padding: 12px 16px;
        border-radius: 8px;
        background: #fef2f2;
        color: #b91c1c;
        border: 1px solid #fecaca;
        margin-bottom: 20px;
      }
    </style>
</head>
<body>


<header>
    <div class="tabs">
        <a class="tab" href="/admin/dashboard">Bảng điều khiển</a>
        <a class="tab" href="/admin/data/list">Quản lý dữ liệu</a>
        <a class="tab active" href="/admin/training/form">Huấn luyện Mô hình</a>
    </div>
</header>

<main>
    <div class="page-title">Trạng thái Job huấn luyện</div>

    <c:if test="${not empty job}">
        <article class="panel">
            <div class="panel-head">
                <div class="panel-title">Job ID: ${job.id}</div>
                <div class="panel-sub">Model: ${job.modelVersion.name}</div>
            </div>

                <%-- Sử dụng class 'pending' cho trạng thái đang chạy --%>
            <div class="status-box pending">
                <h2>
                    <span class="spinner"></span>
                    Trạng thái: ${job.status}
                </h2>

                <c:choose>
                    <c:when test="${job.status == 'STARTED'}">
                        <p>Yêu cầu huấn luyện đã được gửi đến dịch vụ ML. Đang chờ xử lý...</p>
                    </c:when>
                    <c:when test="${job.status == 'TRAINING'}">
                        <p>Dịch vụ ML đang huấn luyện mô hình. Quá trình này có thể mất vài phút...</p>
                    </c:when>
                    <c:otherwise>
                        <p>Đang kiểm tra trạng thái cuối cùng...</p>
                    </c:otherwise>
                </c:choose>

                <p style="margin-top: 20px; font-style: italic; color: var(--muted);">
                    Trang này sẽ tự động tải lại sau 10 giây.
                </p>
            </div>

            <a href="/admin/training/form" class="btn btn-secondary" style="margin-top: 10px;">
                Quay lại Form
            </a>
        </article>
    </c:if>

    <c:if test="${empty job}">
        <p class="error">Không thể tải chi tiết Job. Vui lòng quay lại trang huấn luyện.</p>
        <a href="/admin/training/form" class="btn btn-secondary">Quay lại Form</a>
    </c:if>
</main>

</body>
</html>