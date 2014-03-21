##!DEFAULT TOOPHER_API_URL https://api.toopher.com/v1/
##!DEFAULT TOOPHER_API_KEY YOUR CONSUMER KEY
##!DEFAULT TOOPHER_API_SECRET YOUR CONSUMER SECRET
##!DEFAULT TOOPHER_POLL_TIMEOUT 30
##!DEFAULT TERMINAL_IDENTIFIER []
##!DEFAULT PROMPT_PAIRING_CHALLENGE Toopher 2-factor authentication is enabled for your account.  Please enter the pairing phrase generated by the Toopher mobile app:
##!DEFAULT PROMPT_OTP_CHALLENGE Timeout while contacting the Toopher API.  Please enter the OTP generated by the Toopher Mobile App to proceed.
##!DEFAULT PROMPT_NAME_TERMINAL_CHALLENGE To enable Toopher Automation, please enter a name for this terminal (e.g. "Home Laptop" or "Office PC")
##!DEFAULT PROMPT_SELF_RESET If you have lost your mobile device and need to recover your pairing, enter the word "reset"
##!DEFAULT PROMPT_RESET_LINK_SENT An email has been sent to %email% with a link to reset the Toopher pairing associated with this account
package toopher_radius_config;
use strict;

use constant VERSION => 1.4;

{
  my $toopher_config = 
  {
    toopher_api => {  
      # These values control how your server connects to the Toopher API
      url   =>  '{{TOOPHER_API_URL}}',
      key   =>  '{{TOOPHER_API_KEY}}', 
      secret=>  '{{TOOPHER_API_SECRET}}',
      poll_timeout => {{TOOPHER_POLL_TIMEOUT}},
    },
    # if your VPN provider implements custom RADIUS attributes that
    # can be used to uniquely identify the client terminal, you
    # can list them here to take advantage of Toopher Automation.
    # If this list is empty, automation will be disabled.
    # Note that Calling-Station-Id (or any other attribute
    # reporting the user's IP address) is not considered
    # a secure terminal identifier when used alone, though it
    # may be used in combination with other keys.
    terminal_identifier => {{TERMINAL_IDENTIFIER}}, 
    prompts => {
      pairing_challenge => '{{PROMPT_PAIRING_CHALLENGE}}',
      otp_challenge => '{{PROMPT_OTP_CHALLENGE}}',
      self_reset => '{{PROMPT_SELF_RESET}}',
      name_terminal_challenge => '{{PROMPT_NAME_TERMINAL_CHALLENGE}}',
      reset_link_sent => '{{PROMPT_RESET_LINK_SENT}}',
    },
  };
  sub get_config { return $toopher_config; }
}
