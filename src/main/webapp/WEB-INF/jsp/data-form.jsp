<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${mode == 'create'}">Tạo Dataset Mới</c:when>
            <c:otherwise>Sửa Dataset</c:otherwise>
        </c:choose>
    </title>
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
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            max-width: 600px;
            width: 100%;
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
            font-size: 24px;
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
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #495057;
            font-size: 14px;
        }
        .form-group label .required {
            color: #dc3545;
        }
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        .form-control:focus {
            outline: none;
            border-color: #667eea;
        }
        .form-control:disabled {
            background: #f8f9fa;
            cursor: not-allowed;
        }
        .help-text {
            font-size: 13px;
            color: #6c757d;
            margin-top: 5px;
        }
        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 30px;
        }
        .btn {
            flex: 1;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
            text-align: center;
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
            <h1>
                <c:choose>
                    <c:when test="${mode == 'create'}">➕ Tạo Dataset Mới</c:when>
                    <c:otherwise>✏️ Sửa Dataset</c:otherwise>
                </c:choose>
            </h1>
        </div>
        
        <div class="nav-menu">
            <a href="/admin/dashboard" class="nav-link">Bảng điều khiển</a>
            <a href="/admin/data/list" class="nav-link active">Quản lý dữ liệu</a>
            <a href="/admin/training/form" class="nav-link">Huấn luyện Mô hình</a>
        </div>
        
        <div class="content">
            <a href="/admin/data/list" class="back-link">← Quay lại Danh sách</a>
            
            <!-- Flash Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <!-- Form -->
            <c:choose>
                <c:when test="${mode == 'create'}">
                    <form action="/admin/data/save" method="post">
                        <div class="form-group">
                            <label>Tên Dataset <span class="required">*</span></label>
                            <input type="text" name="name" class="form-control" 
                                   placeholder="Ví dụ: Dataset Review Sách" required>
                            <div class="help-text">Đặt tên mô tả cho dataset của bạn</div>
                        </div>
                        
                        <div class="button-group">
                            <button type="submit" class="btn btn-primary">💾 Tạo Dataset</button>
                            <a href="/admin/data/list" class="btn btn-secondary">❌ Hủy</a>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <form action="/admin/data/update/${dataSource.id}" method="post">
                        <div class="form-group">
                            <label>Tên Dataset <span class="required">*</span></label>
                            <input type="text" name="name" class="form-control" 
                                   value="${dataSource.name}" required>
                            <div class="help-text">Đặt tên mô tả cho dataset của bạn</div>
                        </div>
                        
                        <div class="form-group">
                            <label>Số Mẫu</label>
                            <input type="text" class="form-control" 
                                   value="${fn:length(dataSource.samples)} mẫu" disabled>
                        </div>
                        
                        <div class="button-group">
                            <button type="submit" class="btn btn-primary">💾 Cập Nhật</button>
                            <a href="/admin/data/list" class="btn btn-secondary">❌ Hủy</a>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>

