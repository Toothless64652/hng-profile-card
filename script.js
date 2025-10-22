/**
 * HNG Task 0 - Profile Card JavaScript
 * Updates the current time in milliseconds using Date.now()
 */

// Function to update the time display
function updateTime() {
    // Get the time element using the required data-testid
    const timeElement = document.querySelector('[data-testid="test-user-time"]');
    
    if (timeElement) {
        // Get current time in milliseconds
        const currentTime = Date.now();
        
        // Update the element with the current time
        timeElement.textContent = `Time: ${currentTime} ms`;
        
        // Optional: Add a visual indicator that the time was updated
        timeElement.style.opacity = '0.7';
        setTimeout(() => {
            timeElement.style.opacity = '1';
        }, 100);
    } else {
        console.error('Time element with data-testid="test-user-time" not found');
    }
}

// Function to format time in a more readable way (optional enhancement)
function updateTimeFormatted() {
    const timeElement = document.querySelector('[data-testid="test-user-time"]');
    
    if (timeElement) {
        const currentTime = Date.now();
        const date = new Date(currentTime);
        
        // Format: milliseconds + readable date/time
        const formattedTime = `${currentTime} ms (${date.toLocaleString()})`;
        timeElement.textContent = `Current Time: ${formattedTime}`;
        
        // Add visual feedback
        timeElement.style.opacity = '0.7';
        setTimeout(() => {
            timeElement.style.opacity = '1';
        }, 100);
    }
}

// Initialize the time display when the page loads
document.addEventListener('DOMContentLoaded', function() {
    console.log('HNG Task 0 - Profile Card loaded successfully');
    
    // Set initial time
    updateTime();
    
    // Update time every second (1000ms)
    setInterval(updateTime, 1000);
    
    // Optional: Add click event to manually refresh time
    const timeElement = document.querySelector('[data-testid="test-user-time"]');
    if (timeElement) {
        timeElement.style.cursor = 'pointer';
        timeElement.title = 'Click to refresh time';
        
        timeElement.addEventListener('click', function() {
            updateTime();
        });
    }
    
    // Add smooth loading animation
    const profileCard = document.querySelector('[data-testid="test-profile-card"]');
    if (profileCard) {
        profileCard.style.opacity = '0';
        profileCard.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            profileCard.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            profileCard.style.opacity = '1';
            profileCard.style.transform = 'translateY(0)';
        }, 100);
    }
});

// Optional: Add keyboard navigation enhancement
document.addEventListener('keydown', function(event) {
    // Press 'T' key to manually update time
    if (event.key.toLowerCase() === 't' && !event.ctrlKey && !event.altKey) {
        updateTime();
        console.log('Time manually updated via keyboard shortcut (T key)');
    }
});

// Export functions for potential testing (if using modules)
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        updateTime,
        updateTimeFormatted
    };
}
