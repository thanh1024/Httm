<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${isNew ? 'Tạo Dataset Mới' : 'Sửa Dataset'} - PTHTTM</title>
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
            max-width: 800px;
            margin: 0 auto;
        }

        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 40px;
        }

        h1 {
            color: #1a202c;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .subtitle {
            color: #718096;
            font-size: 14px;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 24px;
        }

        label {
            display: block;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .required {
            color: #f56565;
        }

        input[type="text"],
        select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.2s;
        }

        input[type="text"]:focus,
        select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .help-text {
            font-size: 13px;
            color: #718096;
            margin-top: 6px;
        }

        .alert {
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .alert-error {
            background: #fed7d7;
            color: #742a2a;
            border-left: 4px solid #f56565;
        }

        .alert-success {
            background: #c6f6d5;
            color: #22543d;
            border-left: 4px solid #48bb78;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid #e2e8f0;
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

        .btn-secondary {
            background: #e2e8f0;
            color: #4a5568;
        }

        .btn-secondary:hover {
            background: #cbd5e0;
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
    </style>
</head>
<body>
    <div class="container">
        <a href="/admin/data" class="back-link">
            ← Quay lại Danh sách Dataset
        </a>

        <div class="card">
            <h1>${isNew ? '➕ Tạo Dataset Mới' : '✏ Sửa Dataset'}</h1>
            <p class="subtitle">
                ${isNew ? 'Tạo dataset mới để thêm samples huấn luyện thủ công' : 'Cập nhật thông tin dataset'}
            </p>

            <!-- Flash Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    ✗ ${error}
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    ✓ ${success}
                </div>
            </c:if>

            <form action="${isNew ? '/admin/data/create' : '/admin/data/'.concat(dataSource.id).concat('/update')}" 
                  method="post" id="datasetForm">
                
                <div class="form-group">
                    <label for="name">
                        Tên Dataset <span class="required">*</span>
                    </label>
                    <input type="text" 
                           id="name" 
                           name="name" 
                           value="${not empty dataSource ? dataSource.name : ''}"
                           placeholder="Ví dụ: Review điện thoại Samsung 2024"
                           required>
                    <div class="help-text">
                        Đặt tên mô tả rõ ràng cho dataset
                    </div>
                </div>

                <div class="form-group">
                    <label for="modelType">
                        Loại Model <span class="required">*</span>
                    </label>
                    <select id="modelType" name="modelType" required>
                        <option value="">-- Chọn loại model --</option>
                        <option value="aspect" ${not empty dataSource && dataSource.modelType == 'aspect' ? 'selected' : ''}>
                            Aspect-Based Sentiment Analysis
                        </option>
                        <option value="sentiment" ${not empty dataSource && dataSource.modelType == 'sentiment' ? 'selected' : ''}>
                            Sentiment Classification
                        </option>
                        <option value="classification" ${not empty dataSource && dataSource.modelType == 'classification' ? 'selected' : ''}>
                            General Classification
                        </option>
                    </select>
                    <div class="help-text">
                        Chọn loại model phù hợp với dữ liệu
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        ${isNew ? '✓ Tạo Dataset và Thêm Samples' : '✓ Lưu Thay đổi'}
                    </button>
                    <a href="/admin/data" class="btn btn-secondary">
                        ✗ Hủy
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.getElementById('datasetForm').addEventListener('submit', function(e) {
            var name = document.getElementById('name').value.trim();
            var modelType = document.getElementById('modelType').value;

            if (!name) {
                e.preventDefault();
                alert('Vui lòng nhập tên dataset');
                return false;
            }

            if (!modelType) {
                e.preventDefault();
                alert('Vui lòng chọn loại model');
                return false;
            }
        });
    </script>
</body>
</html>

