-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-02-2025 a las 20:51:46
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tienda_zapatos`
--

DELIMITER $$
--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `calcular_total` (`cart_id` INT) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    DECLARE total DECIMAL(10, 2);

    SELECT SUM(ci.quantity * s.price) 
    INTO total
    FROM cart_items ci
    INNER JOIN shoe_sizes ss ON ci.shoe_sizes_id = ss.id
    INNER JOIN shoes s ON ss.shoe_id = s.id
    WHERE ci.cart_id = cart_id;

    RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `administrators`
--

CREATE TABLE `administrators` (
  `id` bigint(20) NOT NULL,
  `name` text NOT NULL,
  `last_name` text DEFAULT NULL,
  `email` text NOT NULL,
  `password` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `blocked` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `administrators`
--

INSERT INTO `administrators` (`id`, `name`, `last_name`, `email`, `password`, `created_at`, `blocked`) VALUES
(1, 'Sistema Web', 'General', 'admin@example.com', 'adminpass', '2025-01-26 22:28:57', 0),
(2, 'Sofia', 'Rodriguez', 'sofia.admin@example.com', 'adminpass', '2025-01-26 22:28:57', 0),
(3, 'Admin1', 'Gómez', 'admin1@gmail.com', 'adminpass123', '2025-01-26 22:31:19', 0),
(4, 'Admin2', 'Fernández', 'admin2@gmail.com', 'adminpass456', '2025-01-26 22:31:19', 0),
(5, 'Kalefc', 'Gonzales Contreras', 'kalefcgonzaleshl2@gmail.com', 'Loop123++', '2025-01-26 23:03:42', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `brands`
--

CREATE TABLE `brands` (
  `id` bigint(20) NOT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `brands`
--

INSERT INTO `brands` (`id`, `name`) VALUES
(1, 'Nike'),
(2, 'Adidas'),
(3, 'Puma'),
(4, 'Walon');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cart`
--

CREATE TABLE `cart` (
  `id` bigint(20) NOT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cart`
--

INSERT INTO `cart` (`id`, `customer_id`, `created_at`) VALUES
(1, 1, '2025-01-26 22:32:48'),
(2, 2, '2025-01-26 22:32:48'),
(3, 3, '2025-01-26 22:32:48'),
(4, 5, '2025-02-01 11:25:15'),
(5, 5, '2025-02-01 11:25:55'),
(6, 5, '2025-02-01 11:29:23'),
(7, 1, '2025-02-01 11:30:47'),
(8, 5, '2025-02-01 12:50:47'),
(9, 5, '2025-02-01 12:55:53'),
(10, 5, '2025-02-01 12:58:25'),
(11, 5, '2025-02-01 13:01:25'),
(12, 5, '2025-02-01 13:03:35'),
(13, 5, '2025-02-01 13:03:40'),
(14, 5, '2025-02-01 13:04:10'),
(27, 21, '2025-02-01 22:10:59');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cart_items`
--

CREATE TABLE `cart_items` (
  `id` bigint(20) NOT NULL,
  `cart_id` bigint(20) DEFAULT NULL,
  `shoe_sizes_id` bigint(20) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cart_items`
--

INSERT INTO `cart_items` (`id`, `cart_id`, `shoe_sizes_id`, `quantity`) VALUES
(13, 1, 62, 2),
(14, 2, 74, 1),
(15, 2, 39, 1),
(16, 3, 39, 4),
(17, 3, 73, 1),
(18, 4, 99, 1),
(19, 5, 99, 3),
(20, 6, 92, 2),
(21, 6, 73, 1),
(22, 7, 90, 2),
(23, 8, 62, 20),
(24, 9, 61, 2),
(25, 10, 92, 2),
(26, 11, 90, 1),
(27, 12, 90, 1),
(28, 13, 90, 1),
(42, 14, 71, 2),
(43, 14, 71, 1),
(44, 14, 71, 1),
(45, 14, 71, 1),
(46, 14, 71, 1),
(47, 14, 71, 1),
(48, 14, 71, 1),
(49, 14, 71, 1),
(51, 14, 71, 1),
(52, 14, 71, 1),
(53, 14, 72, 1),
(54, 14, 71, 1),
(55, 14, 72, 1),
(56, 27, 100, 2),
(57, 27, 90, 3),
(58, 27, 93, 1),
(59, 27, 61, 1),
(60, 27, 71, 2),
(61, 27, 66, 1),
(62, 27, 62, 1),
(63, 27, 91, 1),
(64, 14, 61, 1),
(65, 14, 62, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `customers`
--

CREATE TABLE `customers` (
  `id` bigint(20) NOT NULL,
  `name` text NOT NULL,
  `last_name` text DEFAULT NULL,
  `email` text NOT NULL,
  `password` text NOT NULL,
  `address` text DEFAULT NULL,
  `dni` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `blocked` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `customers`
--

INSERT INTO `customers` (`id`, `name`, `last_name`, `email`, `password`, `address`, `dni`, `created_at`, `blocked`) VALUES
(1, 'Juan', 'Perez', 'juan.perez@example.com', 'password123', 'Av. Principal 123', '12345678', '2025-01-26 22:28:57', 0),
(2, 'Maria', 'Perez Perez', 'maria.lopez@example.com', 'password123', 'Calle Secundaria 456', '87654321', '2025-01-26 22:28:57', 0),
(3, 'Carlos', 'Garciaa', 'carlos.garcia@example.com', 'password123', 'Av. Siempreviva 742', '12348765', '2025-01-26 22:28:57', 0),
(5, 'Kalefc', 'Gonzales Contreras', 'kalefcgonzaleshl2@gmail.com', '12345678', 'Av.Luis Alberto Sanchez psaje.9 de agosto', '72279110', '2025-01-27 19:14:46', 0),
(21, 'Carlos', 'Gonzales Contreras', 'kalefcgonzaleshl233@gmail.com', '12345678', 'Calle Secundaria 456', '99999999', '2025-02-01 16:56:00', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `offers`
--

CREATE TABLE `offers` (
  `id` bigint(20) NOT NULL,
  `shoe_id` bigint(20) DEFAULT NULL,
  `discount_percentage` decimal(5,2) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `offers`
--

INSERT INTO `offers` (`id`, `shoe_id`, `discount_percentage`, `start_date`, `end_date`) VALUES
(4, 13849161, 12.00, '2025-01-27', '2025-02-20'),
(5, 59883518, 30.00, '2025-01-28', '2025-02-20'),
(8, 40873583, 13.00, '2025-02-02', '2025-03-03');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `product_reviews`
--

CREATE TABLE `product_reviews` (
  `id` bigint(20) NOT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `shoe_id` bigint(20) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `review_text` text DEFAULT NULL,
  `review_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `product_reviews`
--

INSERT INTO `product_reviews` (`id`, `customer_id`, `shoe_id`, `rating`, `review_text`, `review_date`) VALUES
(5, 2, 13849161, 4, 'Me encanta estas zapatillas nos las mejores que compre a mi hijo, lo amo!!!!!', '2025-01-27 17:00:29'),
(6, 1, 13849161, 1, 'Las zapatillas se rompieron a la semana, tengo 32 años y el la peor compra que hize, las zapatillas me ajustaban mucho y no puedo correr como el rayo, nolo recomiendo!!!', '2025-01-27 17:20:14'),
(7, 5, 55685914, 5, 'Fue la mejor compra que hize en el año jajaaj', '2025-02-01 22:40:55'),
(8, 5, 55685914, 1, 'Fue una buena compra jaja', '2025-02-01 22:41:24');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sales`
--

CREATE TABLE `sales` (
  `id` bigint(20) NOT NULL,
  `cart_id` bigint(20) NOT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `sale_date` datetime DEFAULT current_timestamp(),
  `admin_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sales`
--

INSERT INTO `sales` (`id`, `cart_id`, `total_amount`, `sale_date`, `admin_id`) VALUES
(19, 3, 200.00, '2025-01-29 00:05:51', 5),
(20, 2, 149.99, '2025-01-29 00:14:14', 5),
(21, 3, 299.99, '2025-01-29 00:17:55', 4),
(22, 4, 49.00, '2025-02-01 11:25:15', 5),
(23, 5, 147.00, '2025-02-01 11:25:55', 5),
(24, 6, 179.89, '2025-02-01 11:29:23', 5),
(25, 7, 298.00, '2025-02-01 11:30:47', 5),
(26, 8, 2460.00, '2025-02-01 12:50:47', 5),
(27, 9, 246.00, '2025-02-01 12:55:53', 5),
(28, 10, 79.90, '2025-02-01 12:58:25', 5),
(29, 11, 149.00, '2025-02-01 13:01:25', 5),
(30, 12, 149.00, '2025-02-01 13:03:35', 5),
(31, 13, 149.00, '2025-02-01 13:03:40', 5);

--
-- Disparadores `sales`
--
DELIMITER $$
CREATE TRIGGER `before_insert_sale` BEFORE INSERT ON `sales` FOR EACH ROW BEGIN
    SET NEW.total_amount = calcular_total(NEW.cart_id);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shipping`
--

CREATE TABLE `shipping` (
  `id` bigint(20) NOT NULL,
  `sale_id` bigint(20) DEFAULT NULL,
  `address` text NOT NULL,
  `shipped_date` datetime DEFAULT NULL,
  `delivery_date` datetime DEFAULT NULL,
  `status_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `shipping`
--

INSERT INTO `shipping` (`id`, `sale_id`, `address`, `shipped_date`, `delivery_date`, `status_id`) VALUES
(3, 19, 'direccion de envio', '2025-01-31 22:50:43', '2025-02-08 22:50:44', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shipping_statuses`
--

CREATE TABLE `shipping_statuses` (
  `id` bigint(20) NOT NULL,
  `status` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `shipping_statuses`
--

INSERT INTO `shipping_statuses` (`id`, `status`) VALUES
(1, 'en proceso'),
(2, 'enviado'),
(3, 'entregado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shoes`
--

CREATE TABLE `shoes` (
  `id` bigint(20) NOT NULL,
  `name` text NOT NULL,
  `description` text DEFAULT NULL,
  `brand_id` bigint(20) DEFAULT NULL,
  `category` text DEFAULT NULL,
  `gender_id` bigint(20) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `added_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `shoes`
--

INSERT INTO `shoes` (`id`, `name`, `description`, `brand_id`, `category`, `gender_id`, `price`, `added_at`) VALUES
(13849161, 'Zapatillas rayo mcqeeen', 'Zapatillas especificamente para correr corre como el rayo cuchao', 2, 'Deportivas', 6, 49.00, '2025-01-27 13:30:55'),
(40873583, 'Rayo McQueen Hook & Loop Zapatos para Niños', 'Nuevos Zapatos Iluminados 95 Coches Disney Niños Pequeños y Niños Pequeños', 3, 'Deportivas', 6, 39.95, '2025-01-28 22:14:01'),
(49855934, 'Zapatillas De Mujer Fashion', 'Zapatillas De Mujer Fashion a la moda ultimo modelo', 2, 'Clasico', 2, 123.00, '2025-01-27 23:19:14'),
(55685914, 'Zapatillas De Hombre', 'Zapatillas MODA Fashion PARA TI', 2, 'Clasico', 1, 99.99, '2025-01-28 00:41:25'),
(59883518, 'Under Armour Mojo 2', 'Zapatillas Urbano Mujer', 2, 'Clasico', 2, 149.00, '2025-01-28 14:44:55'),
(66844555, 'Zapatillas Elegantes', 'Zapatillas especificamente para correr', 1, 'Deportivos', 3, 100.00, '2025-01-31 22:36:33');

--
-- Disparadores `shoes`
--
DELIMITER $$
CREATE TRIGGER `generate_shoe_id` BEFORE INSERT ON `shoes` FOR EACH ROW BEGIN
    DECLARE random_id BIGINT;

    -- Generar un número aleatorio de 8 dígitos (10000000 a 99999999)
    SET random_id = FLOOR(10000000 + (RAND() * 89999999));

    -- Verificar que el ID generado no exista en la tabla
    WHILE EXISTS (SELECT 1 FROM shoes WHERE id = random_id) DO
        SET random_id = FLOOR(10000000 + (RAND() * 89999999));
    END WHILE;

    -- Asignar el ID generado al campo id
    SET NEW.id = random_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shoe_colors`
--

CREATE TABLE `shoe_colors` (
  `id` bigint(20) NOT NULL,
  `color` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `shoe_colors`
--

INSERT INTO `shoe_colors` (`id`, `color`) VALUES
(1, 'Rojo'),
(2, 'Azul'),
(3, 'Negro'),
(4, 'Blanco'),
(5, 'Rosado'),
(6, 'Celeste');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shoe_color_images`
--

CREATE TABLE `shoe_color_images` (
  `id` bigint(20) NOT NULL,
  `shoe_id` bigint(20) DEFAULT NULL,
  `color_id` bigint(20) DEFAULT NULL,
  `image_url` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `shoe_color_images`
--

INSERT INTO `shoe_color_images` (`id`, `shoe_id`, `color_id`, `image_url`) VALUES
(1, 49855934, 5, 'uploads/10341222154270.jpg'),
(4, 13849161, 1, 'uploads/rayo.jpg'),
(5, 13849161, 2, 'uploads/images.jpg'),
(9, 55685914, 1, 'uploads/w=1500,h=1500,fit=pad.avif'),
(10, 55685914, 3, 'uploads/64D11D8366285-Zapatilla-Walking-Mujer-Carina-2-0.webp'),
(11, 59883518, 3, 'uploads/9534271553566 (2).jpg'),
(14, 59883518, 2, 'uploads/Zapatilla.webp'),
(15, 40873583, 1, 'uploads/images (1).jpg'),
(20, 66844555, 3, 'uploads/elegantes.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shoe_genders`
--

CREATE TABLE `shoe_genders` (
  `id` bigint(20) NOT NULL,
  `gender` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `shoe_genders`
--

INSERT INTO `shoe_genders` (`id`, `gender`) VALUES
(1, 'Masculino'),
(2, 'Femenino'),
(3, 'Unisex'),
(6, 'Niños');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shoe_sizes`
--

CREATE TABLE `shoe_sizes` (
  `id` bigint(20) NOT NULL,
  `shoe_id` bigint(20) DEFAULT NULL,
  `size` int(11) NOT NULL,
  `stock` int(11) NOT NULL,
  `color_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `shoe_sizes`
--

INSERT INTO `shoe_sizes` (`id`, `shoe_id`, `size`, `stock`, `color_id`) VALUES
(39, 13849161, 38, 10, 1),
(61, 49855934, 34, 10, 5),
(62, 49855934, 36, 11, 5),
(66, 13849161, 32, 13, 1),
(71, 55685914, 36, 12, 1),
(72, 55685914, 40, 3, 1),
(73, 55685914, 41, 2, 1),
(74, 55685914, 42, 2, 1),
(75, 59883518, 35, 20, 3),
(76, 59883518, 36, 20, 3),
(77, 59883518, 37, 20, 3),
(78, 59883518, 38, 20, 3),
(79, 59883518, 39, 20, 3),
(90, 59883518, 34, 1, 2),
(91, 59883518, 35, 3, 2),
(92, 40873583, 24, 1, 1),
(93, 40873583, 25, 2, 1),
(94, 40873583, 26, 3, 1),
(95, 40873583, 27, 1, 1),
(99, 13849161, 31, 10, 1),
(100, 66844555, 37, 9, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `administrators`
--
ALTER TABLE `administrators`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`) USING HASH;

--
-- Indices de la tabla `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`) USING HASH;

--
-- Indices de la tabla `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indices de la tabla `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_id` (`cart_id`),
  ADD KEY `fk_shoe_sizes` (`shoe_sizes_id`);

--
-- Indices de la tabla `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`) USING HASH,
  ADD UNIQUE KEY `dni` (`dni`) USING HASH;

--
-- Indices de la tabla `offers`
--
ALTER TABLE `offers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `shoe_id` (`shoe_id`);

--
-- Indices de la tabla `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `shoe_id` (`shoe_id`);

--
-- Indices de la tabla `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `fk_sales_car_id` (`cart_id`);

--
-- Indices de la tabla `shipping`
--
ALTER TABLE `shipping`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sale_id` (`sale_id`),
  ADD KEY `status_id` (`status_id`);

--
-- Indices de la tabla `shipping_statuses`
--
ALTER TABLE `shipping_statuses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `status` (`status`) USING HASH;

--
-- Indices de la tabla `shoes`
--
ALTER TABLE `shoes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `brand_id` (`brand_id`),
  ADD KEY `gender_id` (`gender_id`);

--
-- Indices de la tabla `shoe_colors`
--
ALTER TABLE `shoe_colors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `color` (`color`) USING HASH;

--
-- Indices de la tabla `shoe_color_images`
--
ALTER TABLE `shoe_color_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `shoe_id` (`shoe_id`),
  ADD KEY `color_id` (`color_id`);

--
-- Indices de la tabla `shoe_genders`
--
ALTER TABLE `shoe_genders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `gender` (`gender`) USING HASH;

--
-- Indices de la tabla `shoe_sizes`
--
ALTER TABLE `shoe_sizes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `shoe_id` (`shoe_id`),
  ADD KEY `color_id` (`color_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `administrators`
--
ALTER TABLE `administrators`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `brands`
--
ALTER TABLE `brands`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `cart`
--
ALTER TABLE `cart`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT de la tabla `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT de la tabla `customers`
--
ALTER TABLE `customers`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `offers`
--
ALTER TABLE `offers`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `product_reviews`
--
ALTER TABLE `product_reviews`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `sales`
--
ALTER TABLE `sales`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT de la tabla `shipping`
--
ALTER TABLE `shipping`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `shipping_statuses`
--
ALTER TABLE `shipping_statuses`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `shoes`
--
ALTER TABLE `shoes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98738896;

--
-- AUTO_INCREMENT de la tabla `shoe_colors`
--
ALTER TABLE `shoe_colors`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `shoe_color_images`
--
ALTER TABLE `shoe_color_images`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `shoe_genders`
--
ALTER TABLE `shoe_genders`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `shoe_sizes`
--
ALTER TABLE `shoe_sizes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`);

--
-- Filtros para la tabla `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`),
  ADD CONSTRAINT `fk_shoe_sizes` FOREIGN KEY (`shoe_sizes_id`) REFERENCES `shoe_sizes` (`id`);

--
-- Filtros para la tabla `offers`
--
ALTER TABLE `offers`
  ADD CONSTRAINT `offers_ibfk_1` FOREIGN KEY (`shoe_id`) REFERENCES `shoes` (`id`);

--
-- Filtros para la tabla `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD CONSTRAINT `product_reviews_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  ADD CONSTRAINT `product_reviews_ibfk_2` FOREIGN KEY (`shoe_id`) REFERENCES `shoes` (`id`);

--
-- Filtros para la tabla `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `fk_sales_car_id` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`),
  ADD CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`admin_id`) REFERENCES `administrators` (`id`);

--
-- Filtros para la tabla `shipping`
--
ALTER TABLE `shipping`
  ADD CONSTRAINT `shipping_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`),
  ADD CONSTRAINT `shipping_ibfk_2` FOREIGN KEY (`status_id`) REFERENCES `shipping_statuses` (`id`);

--
-- Filtros para la tabla `shoes`
--
ALTER TABLE `shoes`
  ADD CONSTRAINT `shoes_ibfk_1` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`),
  ADD CONSTRAINT `shoes_ibfk_2` FOREIGN KEY (`gender_id`) REFERENCES `shoe_genders` (`id`);

--
-- Filtros para la tabla `shoe_color_images`
--
ALTER TABLE `shoe_color_images`
  ADD CONSTRAINT `shoe_color_images_ibfk_1` FOREIGN KEY (`shoe_id`) REFERENCES `shoes` (`id`),
  ADD CONSTRAINT `shoe_color_images_ibfk_2` FOREIGN KEY (`color_id`) REFERENCES `shoe_colors` (`id`);

--
-- Filtros para la tabla `shoe_sizes`
--
ALTER TABLE `shoe_sizes`
  ADD CONSTRAINT `shoe_sizes_ibfk_1` FOREIGN KEY (`shoe_id`) REFERENCES `shoes` (`id`),
  ADD CONSTRAINT `shoe_sizes_ibfk_2` FOREIGN KEY (`color_id`) REFERENCES `shoe_colors` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
