<?php
/**
 * Sentry Error Tracking Integration
 *
 * This helper initializes Sentry for error tracking in OpenCart
 */

use Sentry\SentrySdk;
use Sentry\Event;

/**
 * Initialize Sentry
 */
function initSentry() {
    // Get Sentry configuration from environment
    $dsn = getenv('SENTRY_DSN');
    
    if (empty($dsn) || $dsn === 'your_sentry_dsn_here') {
        // Sentry not configured, skip initialization
        return false;
    }
    
    \Sentry\init([
        'dsn' => $dsn,
        'environment' => getenv('SENTRY_ENVIRONMENT') ?: 'production',
        'traces_sample_rate' => (float) (getenv('SENTRY_TRACES_SAMPLE_RATE') ?: 0.1),
        'profiles_sample_rate' => 0.1,
        'integrations' => [
            new \Sentry\Integration\IgnoreErrorsIntegration([
                'ignore_exceptions' => [
                    // Add exceptions to ignore if needed
                ],
            ]),
        ],
        'before_send' => function (Event $event): ?Event {
            // Filter sensitive data
            if ($event->getRequest()) {
                $request = $event->getRequest();
                
                // Remove sensitive headers
                $headers = $request->getHeaders();
                unset($headers['authorization']);
                unset($headers['cookie']);
                
                // Remove sensitive data from request
                $data = $request->getData();
                if (is_array($data)) {
                    // Remove passwords and sensitive fields
                    $sensitiveFields = ['password', 'token', 'api_key', 'secret'];
                    foreach ($sensitiveFields as $field) {
                        if (isset($data[$field])) {
                            $data[$field] = '[FILTERED]';
                        }
                    }
                }
                
                $request->setHeaders($headers);
                $request->setData($data);
            }
            
            return $event;
        },
    ]);
    
    // Set user context if logged in
    if (isset($_SESSION['customer_id'])) {
        \Sentry\configureScope(function (\Sentry\State\Scope $scope): void {
            $scope->setUser([
                'id' => $_SESSION['customer_id'],
                'email' => $_SESSION['email'] ?? null,
            ]);
        });
    }
    
    // Set additional context
    \Sentry\configureScope(function (\Sentry\State\Scope $scope): void {
        $scope->setContext('opencart', [
            'version' => VERSION ?? 'unknown',
            'route' => $_GET['route'] ?? 'index',
        ]);
    });
    
    return true;
}

/**
 * Capture exception with Sentry
 */
function sentryException($exception, array $context = []) {
    if (function_exists('\Sentry\captureException')) {
        \Sentry\withScope(function (\Sentry\State\Scope $scope) use ($exception, $context): void {
            foreach ($context as $key => $value) {
                $scope->setContext($key, $value);
            }
            \Sentry\captureException($exception);
        });
    }
}

/**
 * Capture message with Sentry
 */
function sentryMessage($message, $level = 'info', array $context = []) {
    if (function_exists('\Sentry\captureMessage')) {
        \Sentry\withScope(function (\Sentry\State\Scope $scope) use ($message, $level, $context): void {
            foreach ($context as $key => $value) {
                $scope->setContext($key, $value);
            }
            \Sentry\captureMessage($message, $level);
        });
    }
}

/**
 * Add breadcrumb to Sentry
 */
function sentryBreadcrumb($message, $category = 'custom', array $data = []) {
    if (function_exists('\Sentry\addBreadcrumb')) {
        \Sentry\addBreadcrumb(
            new \Sentry\Breadcrumb(
                \Sentry\Breadcrumb::LEVEL_INFO,
                \Sentry\Breadcrumb::TYPE_DEFAULT,
                $category,
                $message,
                $data
            )
        );
    }
}