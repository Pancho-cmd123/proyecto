<?php
session_start();
require 'config.php';

$error = '';
$registerError = '';
$registerSuccess = '';

// Obtener lista de marcas
$brandsStmt = $pdo->query('SELECT id, name FROM brands');
$brands = $brandsStmt->fetchAll(PDO::FETCH_ASSOC);

// Filtrar productos según los parámetros de la URL
$categoryFilter = isset($_GET['categoria']) ? $_GET['categoria'] : '';
$brandFilter = isset($_GET['marca']) ? $_GET['marca'] : '';
$menuFilter = '';

if (isset($_GET['nuevo'])) {
    $menuFilter = 'nuevo';
} elseif (isset($_GET['hombre'])) {
    $menuFilter = 'hombre';
} elseif (isset($_GET['mujer'])) {
    $menuFilter = 'mujer';
} elseif (isset($_GET['unisex'])) {
    $menuFilter = 'unisex';
} elseif (isset($_GET['nino'])) {
    $menuFilter = 'nino';
} elseif (isset($_GET['ofertas'])) {
    $menuFilter = 'ofertas';
}

$query = '
    SELECT s.*, 
           b.name AS brand_name, 
           g.gender AS gender_name, 
           sci.image_url, 
           sc.color AS color_name, 
           o.discount_percentage, 
           sz.color_id, 
           MAX(sz.stock) AS max_stock 
    FROM shoes s
    JOIN brands b ON s.brand_id = b.id 
    JOIN shoe_genders g ON s.gender_id = g.id
    LEFT JOIN shoe_sizes sz ON s.id = sz.shoe_id
    LEFT JOIN shoe_colors sc ON sz.color_id = sc.id
    LEFT JOIN shoe_color_images sci ON s.id = sci.shoe_id 
                                    AND sc.id = sci.color_id
    LEFT JOIN offers o ON s.id = o.shoe_id
    WHERE 1=1';

if ($menuFilter == 'nuevo') {
    $query .= ' AND s.added_at >= DATE_SUB(CURDATE(), INTERVAL 2 DAY)';
} elseif ($menuFilter == 'hombre') {
    $query .= ' AND g.gender = "Masculino"';
} elseif ($menuFilter == 'mujer') {
    $query .= ' AND g.gender = "Femenino"';
} elseif ($menuFilter == 'unisex') {
    $query .= ' AND g.gender = "Unisex"';
} elseif ($menuFilter == 'nino') {
    $query .= ' AND g.gender = "Niños"';
} elseif ($menuFilter == 'ofertas') {
    $query .= ' AND o.discount_percentage IS NOT NULL';
}

if ($categoryFilter) {
    $query .= ' AND s.category = :category';
}
if ($brandFilter) {
    $query .= ' AND s.brand_id = :brand_id';
}

$query .= ' GROUP BY s.id, sc.id';

$productsStmt = $pdo->prepare($query);

if ($categoryFilter) {
    $productsStmt->bindParam(':category', $categoryFilter);
}
if ($brandFilter) {
    $productsStmt->bindParam(':brand_id', $brandFilter);
}

$productsStmt->execute();
$products = $productsStmt->fetchAll(PDO::FETCH_ASSOC);

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['login'])) {
        $email = $_POST['email'];
        $password = $_POST['password'];

        $stmt = $pdo->prepare('SELECT id, name, password, blocked FROM customers WHERE email = :email');
        $stmt->execute(['email' => $email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user) {
            if ($user['blocked'] == 1) {
                $error = 'Su cuenta ha sido bloqueada temporalmente';
            } elseif ($password === $user['password']) {
                $_SESSION['user_id'] = $user['id'];
                $_SESSION['user_name'] = $user['name'];
                header('Location: index.php');
                exit();
            } else {
                $error = 'Email o contraseña incorrectos';
            }
        } else {
            $error = 'Email o contraseña incorrectos';
        }
    } elseif (isset($_POST['register'])) {
        $name = $_POST['name'];
        $last_name = $_POST['last_name'];
        $email = $_POST['email'];
        $password = $_POST['password'];
        $address = $_POST['address'];
        $dni = $_POST['dni'];

        $stmt = $pdo->prepare('SELECT id FROM customers WHERE email = :email');
        $stmt->execute(['email' => $email]);
        $existingUser = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($existingUser) {
            $registerError = 'El email ya está registrado.';
        } else {
            $stmt = $pdo->prepare('INSERT INTO customers (name, last_name, email, password, address, dni) VALUES (:name, :last_name, :email, :password, :address, :dni)');
            $stmt->execute([
                'name' => $name,
                'last_name' => $last_name,
                'email' => $email,
                'password' => $password,
                'address' => $address,
                'dni' => $dni
            ]);
            $registerSuccess = 'Registro exitoso. Ahora puedes iniciar sesión.';
        }
    }
}

// Obtener el carrito del usuario
$cartItems = [];
if (isset($_SESSION['user_id'])) {
    $stmt = $pdo->prepare('
        SELECT ci.*, s.name AS shoe_name, sz.size, sc.color, sci.image_url, s.price
        FROM cart_items ci
        JOIN shoe_sizes sz ON ci.shoe_sizes_id = sz.id
        JOIN shoes s ON sz.shoe_id = s.id
        JOIN shoe_colors sc ON sz.color_id = sc.id
        JOIN shoe_color_images sci ON s.id = sci.shoe_id AND sc.id = sci.color_id
        WHERE ci.cart_id = (SELECT id FROM cart WHERE customer_id = :customer_id AND id NOT IN (SELECT cart_id FROM sales))
    ');
    $stmt->execute(['customer_id' => $_SESSION['user_id']]);
    $cartItems = $stmt->fetchAll(PDO::FETCH_ASSOC);
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Moda y Estilo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f0f0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        header {
            background-color: #333;
            color: #fff;
            padding: 10px 0;
            text-align: center;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        header h1 {
            margin: 0;
            font-size: 24px;
        }
        nav {
            display: flex;
            justify-content: center;
            background-color: #444;
            padding: 10px 0;
        }
        nav a {
            color: #fff;
            text-decoration: none;
            margin: 0 15px;
            font-size: 18px;
        }
        nav a:hover {
            text-decoration: underline;
        }
        .container {
            padding: 20px;
            flex: 1;
        }
        .filters {
            margin-bottom: 20px;
        }
        .filters select {
            padding: 10px;
            font-size: 16px;
            margin-right: 10px;
        }
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }
        .product-card {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
        }
        .product-card img {
            max-width: 100%;
            border-radius: 8px;
            transition: transform 0.3s ease;
        }
        .product-card img:hover {
            transform: scale(1.05);
        }
        .product-card h2 {
            margin: 10px 0;
            font-size: 22px;
            color: #333;
        }
        .product-card p {
            margin: 10px 0;
            color: #555;
        }
        .product-card .price {
            font-size: 20px;
            color: #007bff;
            font-weight: bold;
        }
        .product-card .price-discount {
            color: red;
            font-weight: bold;
        }
        .add-to-cart {
            background-color: #28a745;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }
        .add-to-cart:hover {
            background-color: #218838;
        }
        .product-details {
            display: none;
        }
        .product-details.active {
            display: block;
        }
        footer {
            background-color: #333;
            color: #fff;
            text-align: center;
            padding: 20px 0;
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
        }
        .footer-section {
            margin-bottom: 20px;
            flex: 1;
            min-width: 200px;
        }
        .footer-section h3 {
            margin-top: 0;
            font-size: 18px;
            color: #fff;
        }
        .footer-section p, .footer-section a {
            color: #ccc;
            font-size: 14px;
            text-decoration: none;
        }
        .footer-section a:hover {
            text-decoration: underline;
        }
        .social-icons {
            display: flex;
            justify-content: center;
            margin-top: 10px;
        }
        .social-icons img {
            width: 30px;
            height: 30px;
            margin: 0 10px;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgb(0,0,0);
            background-color: rgba(0,0,0,0.4);
            padding-top: 60px;
        }
        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 400px;
            border-radius: 8px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
            animation: fadeIn 0.5s;
        }
        @keyframes fadeIn {
            from {opacity: 0;}
            to {opacity: 1;}
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
        .modal-content h2 {
            margin-top: 0;
            font-size: 24px;
            color: #333;
        }
        .modal-content label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }
        .modal-content input[type="email"],
        .modal-content input[type="password"],
        .modal-content input[type="text"] {
            width: calc(100% - 24px);
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 16px;
        }
        .modal-content button {
            width: 100%;
            padding: 12px;
            background-color: #007bff;
            border: none;
            border-radius: 4px;
            color: #fff;
            font-size: 18px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .modal-content button:hover {
            background-color: #0056b3;
        }
        .error {
            color: red;
            margin-bottom: 20px;
        }
        .success {
            color: green;
            margin-bottom: 20px;
        }
        .btn-login {
            background-color: #007bff;
            padding: 10px 20px;
            border-radius: 4px;
            color: #fff;
            text-decoration: none;
            margin-right: 10px;
        }
        .btn-register {
            background-color: #28a745;
            padding: 10px 20px;
            border-radius: 4px;
            color: #fff;
            text-decoration: none;
        }
        .user-info {
            display: flex;
            align-items: center;
            color: #fff;
        }
        .user-info img {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            margin-right: 8px;
        }
        .cart-icon {
            display: flex;
            align-items: center;
            margin-left: auto;
            margin-right: 20px;
        }
        .cart-icon img {
            width: 30px;
            height: 30px;
        }
        .cart-modal {
            display: none;
            position: fixed;
            right: 0;
            top: 0;
            width: 300px;
            height: 100%;
            background-color: #fff;
            box-shadow: -2px 0 5px rgba(0,0,0,0.5);
            overflow-y: auto;
            transition: transform 0.3s ease, opacity 0.3s ease;
            transform: translateX(100%);
            opacity: 0;
        }
        .cart-modal.open {
            display: block;
            transform: translateX(0);
            opacity: 1;
        }
        .cart-modal-header {
            background-color: #333;
            color: #fff;
            padding: 10px;
            text-align: center;
            position: relative;
        }
        .cart-modal-header .close {
            position: absolute;
            right: 10px;
            top: 10px;
            color: #fff;
            font-size: 24px;
            cursor: pointer;
        }
        .cart-modal-content {
            padding: 20px;
            max-height: 80vh;
            overflow-y: auto;
        }
        .cart-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            border-bottom: 1px solid #ccc;
            padding-bottom: 10px;
            position: relative;
        }
        .cart-item img {
            width: 50px;
            height: 50px;
            margin-right: 10px;
            border-radius: 8px;
        }
        .cart-item-details {
            flex: 1;
        }
        .cart-item-details p {
            margin: 0;
        }
        .cart-item-price {
            font-size: 16px;
            color: #007bff;
            font-weight: bold;
        }
        .cart-item-remove {
            color: red;
            cursor: pointer;
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 20px;
        }
        .cart-total {
            font-size: 18px;
            font-weight: bold;
            text-align: right;
            margin-top: 20px;
        }
        .checkout-btn {
            display: block;
            width: 100%;
            padding: 12px;
            background-color: #28a745;
            border: none;
            border-radius: 4px;
            color: #fff;
            font-size: 18px;
            cursor: pointer;
            text-align: center;
            margin-top: 20px;
            transition: background-color 0.3s ease;
        }
        .checkout-btn:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <header>
        <h1>MODA Y ESTILO</h1>
        <div class="cart-icon">
            <a href="#" id="cartBtn">
                <img src="images/carro.png" alt="Carrito de Compras">
            </a>
        </div>
    </header>
    <nav>
        <a href="index.php">Inicio</a>
        <a href="index.php?nuevo=1">Lo nuevo</a>
        <a href="index.php?hombre=1">Hombre</a>
        <a href="index.php?mujer=1">Mujer</a>
        <a href="index.php?unisex=1">Unisex</a>
        <a href="index.php?nino=1">Niño</a>
        <a href="index.php?ofertas=1">Ofertas</a>
        <a href="contactanos.php">Contáctanos</a>
        <?php if (isset($_SESSION['user_id'])): ?>
            <div class="user-info">
                <img src="images/default_profile.png" alt="Usuario">
                <span><?php echo $_SESSION['user_name']; ?></span>
                <a href="logout.php" class="btn-login">Salir</a>
                <img src="images/peru.webp" alt="Pais">
            </div>
        <?php else: ?>
            <a href="#" id="loginBtn" class="btn-login">Iniciar Sesión</a>
            <a href="#" id="registerBtn" class="btn-register">Registrarse</a>
        <?php endif; ?>
    </nav>
    <div class="container">
        <div class="filters">
            <form method="get" action="index.php">
                <input type="hidden" name="<?php echo $menuFilter; ?>" value="1">
                <select name="categoria">
                    <option value="">Todas las Categorías</option>
                    <option value="Clasico" <?php echo $categoryFilter == 'Clasico' ? 'selected' : ''; ?>>Clásicos</option>
                    <option value="Deportivas" <?php echo $categoryFilter == 'Deportivas' ? 'selected' : ''; ?>>Deportivos</option>
                </select>
                <select name="marca">
                    <option value="">Todas las Marcas</option>
                    <?php foreach ($brands as $brand): ?>
                        <option value="<?php echo $brand['id']; ?>" <?php echo $brandFilter == $brand['id'] ? 'selected' : ''; ?>><?php echo $brand['name']; ?></option>
                    <?php endforeach; ?>
                </select>
                <button type="submit">Filtrar</button>
            </form>
        </div>
        <h2>Todos los Productos</h2>
        <div class="product-grid">
            <?php foreach ($products as $product): ?>
                <div class="product-card">
                    <a href="index.php?producto=<?php echo $product['id']; ?>" class="product-link">
                        <img src="<?php echo $product['image_url']; ?>" alt="<?php echo $product['name']; ?>">
                        <h2><?php echo $product['name']; ?></h2>
                    </a>
                    <p><?php echo $product['description']; ?></p>
                    <p><strong>Color:</strong> <?php echo $product['color_name']; ?></p>
                    <?php if ($product['discount_percentage']): ?>
                        <p class="price"><span class="price-discount">$<?php echo number_format($product['price'] * (1 - $product['discount_percentage'] / 100), 2); ?></span> <del>$<?php echo number_format($product['price'], 2); ?></del></p>
                    <?php else: ?>
                        <p class="price">$<?php echo number_format($product['price'], 2); ?></p>
                    <?php endif; ?>
                    <button class="add-to-cart" data-product-id="<?php echo $product['id']; ?>">Agregar al Carrito</button>
                </div>
            <?php endforeach; ?>
        </div>
    </div>
    <footer>
        <div class="footer-section">
            <h3>Sobre Nosotros</h3>
            <p>Somos una tienda de moda dedicada a ofrecerte lo mejor en ropa y accesorios.</p>
        </div>
        <div class="footer-section">
            <h3>Contáctanos</h3>
            <p>Email: info@modayestilo.com</p>
            <p>Teléfono: +123 456 7890</p>
        </div>
        <div class="footer-section">
            <h3>Síguenos</h3>
            <div class="social-icons">
                <a href="#"><img src="images/facebook.png" alt="Facebook"></a>
                <a href="#"><img src="images/whatsapp.png" alt="WhatsApp"></a>
                <a href="#"><img src="images/instagram.png" alt="Instagram"></a>
            </div>
        </div>
    </footer>

    <div id="loginModal" class="modal">
        <div class="modal-content">
            <span class="close" id="closeLoginModal">&times;</span>
            <h2>Iniciar Sesión</h2>
            <?php if ($error): ?>
                <p class="error"><?php echo $error; ?></p>
            <?php endif; ?>
            <form method="post" action="index.php">
                <label for="login-email">Email:</label>
                <input type="email" id="login-email" name="email" required>
                <label for="login-password">Contraseña:</label>
                <input type="password" id="login-password" name="password" required>
                <button type="submit" name="login">Iniciar Sesión</button>
            </form>
        </div>
    </div>

    <div id="registerModal" class="modal">
        <div class="modal-content">
            <span class="close" id="closeRegisterModal">&times;</span>
            <h2>Registrarse</h2>
            <?php if ($registerError): ?>
                <p class="error"><?php echo $registerError; ?></p>
            <?php endif; ?>
            <?php if ($registerSuccess): ?>
                <p class="success"><?php echo $registerSuccess; ?></p>
            <?php endif; ?>
            <form method="post" action="index.php">
                <label for="register-name">Nombre:</label>
                <input type="text" id="register-name" name="name" required>
                <label for="register-last_name">Apellido:</label>
                <input type="text" id="register-last_name" name="last_name" required>
                <label for="register-email">Email:</label>
                <input type="email" id="register-email" name="email" required>
                <label for="register-password">Contraseña:</label>
                <input type="password" id="register-password" name="password" required>
                <label for="register-address">Dirección:</label>
                <input type="text" id="register-address" name="address" required>
                <label for="register-dni">DNI:</label>
                <input type="text" id="register-dni" name="dni" required>
                <button type="submit" name="register">Registrarse</button>
            </form>
        </div>
    </div>

    <div id="cartModal" class="cart-modal">
        <div class="cart-modal-header">
            <h2>Carrito de Compras</h2>
            <span class="close" id="closeCartModal">&times;</span>
        </div>
        <div class="cart-modal-content">
            <?php if (empty($cartItems)): ?>
                <p>No hay productos en el carrito.</p>
            <?php else: ?>
                <?php foreach ($cartItems as $item): ?>
                    <div class="cart-item">
                        <img src="<?php echo $item['image_url']; ?>" alt="<?php echo $item['shoe_name']; ?>">
                        <div class="cart-item-details">
                            <p><?php echo $item['shoe_name']; ?></p>
                            <p>Talla: <?php echo $item['size']; ?></p>
                            <p>Color: <?php echo $item['color']; ?></p>
                            <p class="cart-item-price">$<?php echo number_format($item['price'], 2); ?></p>
                        </div>
                        <span class="cart-item-remove" data-cart-item-id="<?php echo $item['id']; ?>">&times;</span>
                    </div>
                <?php endforeach; ?>
                <div class="cart-total">
                    Total: $<?php echo number_format(array_sum(array_column($cartItems, 'price')), 2); ?>
                </div>
                <button class="checkout-btn">Proceder al Pago</button>
            <?php endif; ?>
        </div>
    </div>

    <script>
        // Verificar si los elementos existen antes de agregar el event listener
        var loginBtn = document.getElementById('loginBtn');
        if (loginBtn) {
            loginBtn.addEventListener('click', function() {
                document.getElementById('loginModal').style.display = 'block';
            });
        }

        var registerBtn = document.getElementById('registerBtn');
        if (registerBtn) {
            registerBtn.addEventListener('click', function() {
                document.getElementById('registerModal').style.display = 'block';
            });
        }

        var closeLoginModal = document.getElementById('closeLoginModal');
        if (closeLoginModal) {
            closeLoginModal.addEventListener('click', function() {
                document.getElementById('loginModal').style.display = 'none';
            });
        }

        var closeRegisterModal = document.getElementById('closeRegisterModal');
        if (closeRegisterModal) {
            closeRegisterModal.addEventListener('click', function() {
                document.getElementById('registerModal').style.display = 'none';
            });
        }

        var cartBtn = document.getElementById('cartBtn');
        if (cartBtn) {
            cartBtn.addEventListener('click', function() {
                var cartModal = document.getElementById('cartModal');
                cartModal.classList.add('open');
                setTimeout(function() {
                    cartModal.style.opacity = '1';
                }, 10);
            });
        }

        var closeCartModal = document.getElementById('closeCartModal');
        if (closeCartModal) {
            closeCartModal.addEventListener('click', function() {
                var cartModal = document.getElementById('cartModal');
                cartModal.style.opacity = '0';
                setTimeout(function() {
                    cartModal.classList.remove('open');
                }, 300);
            });
        }

        document.querySelectorAll('.cart-item-remove').forEach(function(element) {
            element.addEventListener('click', function() {
                var cartItemId = this.getAttribute('data-cart-item-id');
                // Aquí puedes agregar la lógica para eliminar el producto del carrito
                console.log('Eliminar producto con ID:', cartItemId);
            });
        });

        document.querySelectorAll('.add-to-cart').forEach(function(button) {
            button.addEventListener('click', function() {
                var productId = this.getAttribute('data-product-id');
                // Aquí puedes agregar la lógica para agregar el producto al carrito
                console.log('Agregar producto con ID:', productId);
            });
        });
    </script>
</body>
</html>
