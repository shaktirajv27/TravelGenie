<?php
require_once 'config.php';
require_once 'database.php';

class AuthSystem {
    private $db;
    
    public function __construct() {
        $this->db = Database::getInstance();
    }
    
    public function register($userData) {
        // Validate input
        if (empty($userData['email']) || empty($userData['password']) || empty($userData['username'])) {
            throw new Exception('All fields are required');
        }
        
        if (!filter_var($userData['email'], FILTER_VALIDATE_EMAIL)) {
            throw new Exception('Invalid email format');
        }
        
        if (strlen($userData['password']) < 6) {
            throw new Exception('Password must be at least 6 characters');
        }
        
        // Check if user already exists
        $stmt = $this->db->prepare("SELECT id FROM users WHERE email = ? OR username = ?");
        $stmt->execute([$userData['email'], $userData['username']]);
        
        if ($stmt->fetch()) {
            throw new Exception('User already exists with this email or username');
        }
        
        // Hash password
        $passwordHash = password_hash($userData['password'], PASSWORD_DEFAULT);
        
        // Insert user
        $stmt = $this->db->prepare("
            INSERT INTO users (username, email, password_hash, first_name, last_name, phone) 
            VALUES (?, ?, ?, ?, ?, ?)
        ");
        
        $stmt->execute([
            $userData['username'],
            $userData['email'],
            $passwordHash,
            $userData['first_name'] ?? null,
            $userData['last_name'] ?? null,
            $userData['phone'] ?? null
        ]);
        
        return $this->db->lastInsertId();
    }
    
    public function login($email, $password) {
        $stmt = $this->db->prepare("SELECT id, username, password_hash, first_name, last_name FROM users WHERE email = ?");
        $stmt->execute([$email]);
        $user = $stmt->fetch();
        
        if (!$user || !password_verify($password, $user['password_hash'])) {
            throw new Exception('Invalid email or password');
        }
        
        // Set session
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['username'] = $user['username'];
        $_SESSION['email'] = $email;
        $_SESSION['first_name'] = $user['first_name'];
        $_SESSION['last_name'] = $user['last_name'];
        
        return [
            'user_id' => $user['id'],
            'username' => $user['username'],
            'email' => $email,
            'first_name' => $user['first_name'],
            'last_name' => $user['last_name']
        ];
    }
    
    public function getCurrentUser() {
        if (isset($_SESSION['user_id'])) {
            return [
                'id' => $_SESSION['user_id'],
                'username' => $_SESSION['username'],
                'email' => $_SESSION['email'],
                'first_name' => $_SESSION['first_name'],
                'last_name' => $_SESSION['last_name']
            ];
        }
        return null;
    }
    
    public function logout() {
        session_destroy();
        return true;
    }
}

// Handle authentication requests
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    header('Content-Type: application/json');
    
    try {
        // Get raw input
        $rawInput = file_get_contents('php://input');
        
        // Check if input is empty
        if (empty($rawInput)) {
            throw new Exception('No input data received');
        }
        
        // Decode JSON
        $input = json_decode($rawInput, true);
        
        // Check JSON decode errors
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new Exception('Invalid JSON format: ' . json_last_error_msg());
        }
        
        // Check if input is null or not an array
        if (!is_array($input)) {
            throw new Exception('Invalid input format');
        }
        
        // Check if action exists
        if (!isset($input['action']) || empty($input['action'])) {
            throw new Exception('Action parameter is required');
        }
        
        $auth = new AuthSystem();
        
        switch ($input['action']) {
            case 'register':
                $userId = $auth->register($input);
                echo json_encode(['success' => true, 'user_id' => $userId]);
                break;
                
            case 'login':
                if (empty($input['email']) || empty($input['password'])) {
                    throw new Exception('Email and password are required');
                }
                $result = $auth->login($input['email'], $input['password']);
                echo json_encode(['success' => true, 'data' => $result]);
                break;
                
            case 'logout':
                $auth->logout();
                echo json_encode(['success' => true]);
                break;
                
            case 'check':
                $user = $auth->getCurrentUser();
                echo json_encode(['success' => true, 'user' => $user]);
                break;
                
            default:
                throw new Exception('Invalid action: ' . $input['action']);
        }
        
    } catch (Exception $e) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
}
?>