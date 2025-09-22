import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Smt. Anjali Menon');
  final _phoneController = TextEditingController(text: '+91 4935 23000');
  final _cropController = TextEditingController(text: 'Paddy, Banana, Coconut');
  final _feedbackController = TextEditingController();
  bool _isSubmittingFeedback = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cropController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Color(0xFF4A7C59),
        ),
      );
    }
  }

  Future<void> _sendFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your feedback message'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmittingFeedback = true;
    });

    try {
      // Simulate API call - replace with actual backend function
      await Future.delayed(const Duration(seconds: 2));
      
      // Placeholder backend function call
      await _submitFeedbackToBackend(_feedbackController.text.trim());
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted successfully!'),
          backgroundColor: Color(0xFF4A7C59),
        ),
      );
      
      _feedbackController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit feedback. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmittingFeedback = false;
      });
    }
  }

  // Placeholder backend function - replace with actual implementation
  Future<void> _submitFeedbackToBackend(String feedback) async {
    // This would typically make an HTTP request to your backend
    // For now, we'll just simulate the API call
    print('Submitting feedback: $feedback');
    // Example: await http.post(Uri.parse('your-backend-url/feedback'), body: {'message': feedback});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4A7C59),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Avatar Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF4A7C59),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Account ID: KM 2213 A',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Personal Details Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personal Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A7C59),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _cropController,
                        decoration: const InputDecoration(
                          labelText: 'Crop Details',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.agriculture_outlined),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your crop details';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A7C59),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Nearest Krishi Officer Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nearest Krishi Officer',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A7C59),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      _buildInfoRow(Icons.person, 'Officer Name', 'Krishitivan'),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.location_on, 'Krishibhavan', 'Thrissur Krishi Bhavan'),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.phone, 'Phone', '+91 487 1234567'),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.email, 'Email', 'anjali.menon@krishi.gov.in'),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Feedback Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Send Feedback',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A7C59),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      TextFormField(
                        controller: _feedbackController,
                        decoration: const InputDecoration(
                          labelText: 'Your Feedback',
                          hintText: 'Share your thoughts, suggestions, or report issues...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.feedback_outlined),
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your feedback';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSubmittingFeedback ? null : _sendFeedback,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A7C59),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isSubmittingFeedback
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Submitting...'),
                                  ],
                                )
                              : const Text(
                                  'Submit Feedback',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF4A7C59),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
