package utils

import (
	"fmt"
	"os"

	mailjet "github.com/mailjet/mailjet-apiv3-go/v4"
)

// SendOTPEmail sends an OTP to the specified recipient email address.
func SendOTPEmail(recipientEmail, otp string) error {
	apiKey := os.Getenv("MAILJET_API_KEY")
	secretKey := os.Getenv("MAILJET_SECRET_KEY")

	// Check if API key and secret are set
	if apiKey == "" || secretKey == "" {
		return fmt.Errorf("mailjet API key and/or secret key not set in environment variables")
	}

	mailjetClient := mailjet.NewMailjetClient(apiKey, secretKey)

	messagesInfo := []mailjet.InfoMessagesV31{
		{
			From: &mailjet.RecipientV31{
				Email: "dulahanmeow@gmail.com",
				Name:  "FundFlow",
			},
			To: &mailjet.RecipientsV31{
				{
					Email: recipientEmail,
					Name:  "FundFlow User",
				},
			},
			Subject:  "Your OTP Code",
			TextPart: fmt.Sprintf("Your OTP code is: %s", otp),
			HTMLPart: fmt.Sprintf("<h3>Your OTP code is: %s</h3>", otp),
		},
	}

	messages := mailjet.MessagesV31{Info: messagesInfo}
	_, err := mailjetClient.SendMailV31(&messages)
	if err != nil {
		// Log the error for debugging purposes
		return fmt.Errorf("failed to send OTP email: %w", err)
	}

	return nil
}
