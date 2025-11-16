<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${mode == 'create'}">Thêm Mẫu Mới</c:when>
            <c:otherwise>Sửa Mẫu</c:otherwise>
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
            max-width: 800px;
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
        }
        .header h1 {
            font-size: 24px;
            margin-bottom: 5px;
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
            font-family: inherit;
        }
        .form-control:focus {
            outline: none;
            border-color: #667eea;
        }
        textarea.form-control {
            min-height: 150px;
            resize: vertical;
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
        .form-row {
            display: flex;
            gap: 20px;
        }
        .form-row .form-group {
            flex: 1;
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
    <script>
        function updateLabelFromRating() {
            const rating = document.getElementById('rating').value;
            const labelField = document.getElementById('label');
            
            if (rating && rating != '0') {
                const ratingInt = parseInt(rating);
                if (ratingInt >= 4) {
                    labelField.value = 'POSITIVE';
                } else if (ratingInt == 3) {
                    labelField.value = 'NEUTRAL';
                } else if (ratingInt <= 2) {
                    labelField.value = 'NEGATIVE';
                }
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>
                <c:choose>
                    <c:when test="${mode == 'create'}">➕ Thêm Mẫu Mới</c:when>
                    <c:otherwise>✏️ Sửa Mẫu</c:otherwise>
                </c:choose>
            </h1>
            <div class="dataset-info">Dataset: ${dataSource.name}</div>
        </div>
        
        <div class="nav-menu">
            <a href="/admin/dashboard" class="nav-link">Bảng điều khiển</a>
            <a href="/admin/data/list" class="nav-link active">Quản lý dữ liệu</a>
            <a href="/admin/training/form" class="nav-link">Huấn luyện Mô hình</a>
        </div>
        
        <div class="content">
            <a href="/admin/data/samples/${dataSource.id}" class="back-link">← Quay lại Danh sách Mẫu</a>
            
            <!-- Flash Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <!-- Form -->
            <c:choose>
                <c:when test="${mode == 'create'}">
                    <form action="/admin/data/samples/${dataSource.id}/save" method="post">
                        <div class="form-group">
                            <label>Nội Dung <span class="required">*</span></label>
                            <textarea name="text" class="form-control" required 
                                      placeholder="Nhập nội dung review của bạn..."></textarea>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label>Rating</label>
                                <select name="rating" id="rating" class="form-control" onchange="updateLabelFromRating()">
                                    <option value="0">-- Không có --</option>
                                    <option value="1">⭐ 1</option>
                                    <option value="2">⭐⭐ 2</option>
                                    <option value="3">⭐⭐⭐ 3</option>
                                    <option value="4">⭐⭐⭐⭐ 4</option>
                                    <option value="5">⭐⭐⭐⭐⭐ 5</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label>Label</label>
                                <select name="label" id="label" class="form-control">
                                    <option value="">-- Không có --</option>
                                    <option value="POSITIVE">POSITIVE</option>
                                    <option value="NEUTRAL">NEUTRAL</option>
                                    <option value="NEGATIVE">NEGATIVE</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="button-group">
                            <button type="submit" class="btn btn-primary">💾 Lưu Mẫu</button>
                            <a href="/admin/data/samples/${dataSource.id}" class="btn btn-secondary">❌ Hủy</a>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <form action="/admin/data/samples/update/${sample.id}" method="post">
                        <div class="form-group">
                            <label>Nội Dung <span class="required">*</span></label>
                            <textarea name="text" class="form-control" required>${sample.text}</textarea>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label>Rating</label>
                                <select name="rating" id="rating" class="form-control" onchange="updateLabelFromRating()">
                                    <option value="0" ${empty sample.rating || sample.rating == 0 ? 'selected' : ''}>-- Không có --</option>
                                    <option value="1" ${sample.rating == 1 ? 'selected' : ''}>⭐ 1</option>
                                    <option value="2" ${sample.rating == 2 ? 'selected' : ''}>⭐⭐ 2</option>
                                    <option value="3" ${sample.rating == 3 ? 'selected' : ''}>⭐⭐⭐ 3</option>
                                    <option value="4" ${sample.rating == 4 ? 'selected' : ''}>⭐⭐⭐⭐ 4</option>
                                    <option value="5" ${sample.rating == 5 ? 'selected' : ''}>⭐⭐⭐⭐⭐ 5</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label>Label</label>
                                <select name="label" id="label" class="form-control">
                                    <option value="" ${empty sample.label ? 'selected' : ''}>-- Không có --</option>
                                    <option value="POSITIVE" ${sample.label == 'POSITIVE' ? 'selected' : ''}>POSITIVE</option>
                                    <option value="NEUTRAL" ${sample.label == 'NEUTRAL' ? 'selected' : ''}>NEUTRAL</option>
                                    <option value="NEGATIVE" ${sample.label == 'NEGATIVE' ? 'selected' : ''}>NEGATIVE</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="button-group">
                            <button type="submit" class="btn btn-primary">💾 Cập Nhật</button>
                            <a href="/admin/data/samples/${dataSource.id}" class="btn btn-secondary">❌ Hủy</a>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
