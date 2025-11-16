<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- Để format số --%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Kết quả huấn luyện</title>

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

      /* Form Elements (Cho ô input readonly) */
      .form-group {
        margin-top: 20px;
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
        background: #f9fafb; /* Màu nền cho ô readonly */
        color: var(--muted);
      }

      /* Metric cards (Từ dashboard) */
      .metrics {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 14px;
        margin-top: 10px;
      }
      .metric {
        border: 1px solid var(--border);
        border-radius: 10px;
        padding: 16px;
        display: flex;
        flex-direction: column;
        gap: 8px;
        background: #f9fafb;
      }
      .metric h4 {
        margin: 0;
        font-size: 14px;
        font-weight: 700;
        color: #374151;
      }
      .metric .val {
        font-size: 28px;
        font-weight: 800;
        color: var(--primary);
      }

      /* Status / Result Boxes */
      .status-box {
        border: 1px solid var(--border);
        border-radius: 12px;
        padding: 24px;
      }
      .status-box.success {
        border-color: #16a34a;
        background-color: #f0fdf4;
      }
      .status-box.failure {
        border-color: #dc2626;
        background-color: #fef2f2;
      }
      .status-box h2 {
        margin-top: 0;
      }
      .status-box.success h2 { color: #15803d; }
      .status-box.failure h2 { color: #b91c1c; }

      /* Thẻ <pre> cho traceback lỗi */
      pre {
        background: #f1f5f9;
        padding: 12px;
        border-radius: 8px;
        border: 1px solid var(--border);
        white-space: pre-wrap; /* Wrap traceback dài */
        word-break: break-all;
        font-family: monospace;
        color: #334155;
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
        font-size: 14px;
      }
      .btn-secondary {
        background: #fff;
        color: var(--text);
        border: 1px solid var(--border);
      }
      .actions {
        display: flex;
        gap: 10px;
        margin-top: 20px;
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

      /* Responsive */
      @media (max-width: 900px) {
        .metrics {
          grid-template-columns: repeat(2, 1fr);
        }
      }
      @media (max-width: 600px) {
        .metrics {
          grid-template-columns: 1fr;
        }
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
    <div class="page-title">Kết quả Job huấn luyện</div>

    <c:if test="${not empty job}">
        <article class="panel">
            <div class="panel-head">
                <div class="panel-title">Job ID: ${job.id}</div>
                <div class="panel-sub">Model: ${job.modelVersion.name}</div>
            </div>

            <c:choose>
                <%-- Trường hợp 1: Huấn luyện Thành công --%>
                <c:when test="${job.status == 'COMPLETED'}">
                    <div class="status-box success">
                        <h2>Huấn luyện Hoàn thành!</h2>
                        <p>Mô hình đã được huấn luyện và lưu thành công.</p>
                    </div>

                    <c:if test="${not empty result}">
                        <h3 style="font-size: 16px; margin-bottom: 15px;">Chỉ số đánh giá (Test Set):</h3>

                        <%-- Áp dụng style .metrics từ dashboard --%>
                        <div class="metrics">
                            <div class="metric">
                                <h4>Độ chính xác (Accuracy)</h4>
                                <div class="val"><fmt:formatNumber value="${result.accuracy}" pattern="#0.0000" /></div>
                            </div>
                            <div class="metric">
                                <h4>Điểm F1</h4>
                                <div class="val"><fmt:formatNumber value="${result.f1Score}" pattern="#0.0000" /></div>
                            </div>
                            <div class="metric">
                                <h4>Precision</h4>
                                <div class="val"><fmt:formatNumber value="${result.precision}" pattern="#0.0000" /></div>
                            </div>
                            <div class="metric">
                                <h4>Recall</h4>
                                <div class="val"><fmt:formatNumber value="${result.recall}" pattern="#0.0000" /></div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Đường dẫn Model đã lưu:</label>
                            <input type="text" class="form-control"
                                   value="${job.modelVersion.checkpointUrl}" readonly>
                        </div>
                    </c:if>

                    <c:if test="${empty result}">
                        <p class="error" style="background-color: #fffbeb; color: #b45309; border-color: #fde68a;">
                            Huấn luyện hoàn tất, nhưng không tìm thấy kết quả chi tiết.
                        </p>
                    </c:if>

                    <div class="actions">
                        <form method="POST" action="/admin/training/approve/${job.id}" style="display:inline;">
                            <button type="submit" class="btn">Phê duyệt & Kích hoạt</button>
                        </form>
                        <a href="/admin/training/form" class="btn btn-secondary">Hủy bỏ</a>
                    </div>
                </c:when>

                <%-- Trường hợp 2: Huấn luyện Thất bại --%>
                <c:when test="${job.status == 'FAILED'}">
                    <div class="status-box failure">
                        <h2>Huấn luyện Thất bại!</h2>
                        <p><strong>Chi tiết lỗi (từ Python):</strong></p>
                        <pre>${job.errorMessage}</pre>
                    </div>
                    <a href="/admin/training/form" class="btn btn-secondary" style="margin-top: 10px;">
                        Quay lại Form
                    </a>
                </c:when>

                <%-- Trường hợp 3: Khác --%>
                <c:otherwise>
                    <p>Trạng thái Job là: ${job.status}. Chi tiết kết quả chưa có.</p>
                    <a href="/admin/training/form" class="btn btn-secondary">Quay lại Form</a>
                </c:otherwise>
            </c:choose>

        </article>
    </c:if>

    <c:if test="${empty job}">
        <p class="error">Không thể tải chi tiết Job. Vui lòng quay lại trang huấn luyện.</p>
        <a href="/admin/training/form" class="btn btn-secondary">Quay lại Form</a>
    </c:if>
</main>

</body>
</html>