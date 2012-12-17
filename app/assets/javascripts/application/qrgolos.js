//= require application/Dialog
//= require application/Class

var QRGClass = Class.extend({
    initialize: function(options) {
        // Update the options object
        this.options = $.extend(true, {
            }, options || {});

        this.loginDialog = null;
        this.registerDialog = null;
    },
    
    showPromoVideo: function() {
        QRG.homeSlider.pauseSlideshow();
        new Dialog({
            'class':'promo',
            'onAfterClose': function() {
                QRG.homeSlider.playSlideshow();
            },
            'content':'<iframe width="853" height="480" src="http://www.youtube.com/embed/CSIJGNBHjXw?rel=0&amp;hd=1&amp;autoplay=1" frameborder="0" allowfullscreen></iframe>'
        });
    },
    
    login: function(options) {
        QRG.loggedIn = true;
        
        if(!options) {
            options = {};
        }
        else if(options && options.sessionToken) {
            QRG.sessionToken = options.sessionToken;
        }
        
        
        
        if (window.qrCodeGeneratorObject !== undefined){
            this.updateHeader(options);
            qrCodeGeneratorObject.checkDependencies();
            $('#customizeCodeUserToken').val(options.sessionToken);
        } else if(options.register){
            window.location = '/qr-code-generator/';
        } else {
            window.location = '/dashboard/';
        }
    },

    showMessageDialog: function(title, message) {
        this.messageDialog = new Dialog(
        {
            'class': 'formDialog',
            'modalOverlayClass': 'formModalOverlay',
            'header': '',
            ajax: {
                'url': '/api/web/getMessageDialog/outputType:raw/',
                'data': {
                    'title': title,
                    'message': message
                },
                'onSuccess': function() {
                        
                }
            }
        }
        );
    },
    
    updateHeader: function(options) {
        // Update the header
        $.ajax({
            'url': '/api/web/getHeader/',
            'data': {
                'outputType': 'string',
                'view': $('#header .active').text().toLowerCase()
            },
            success: function(html) {
                $('#header').replaceWith($(html));
                                
                if(options && options.onAfter && typeof(options.onAfter) === 'function') {
                    options.onAfter();
                }
            }
        });
    },

    showSubcribeDialog: function(message) {
        this.subscribeDialog = new Dialog(
        {
            'class': 'formDialog',
            'modalOverlayClass': 'formModalOverlay',
            'header': '',
            'content': message,
            'footer': '',
            'onAfterShow': function() {
            }
        }
        );
    },

    showLoginDialog: function(options) {
        this.loginDialog = new Dialog(
        {
            'class': 'formDialog',
            'modalOverlayClass': 'formModalOverlay',
            'header': '',
            ajax: {
                'url': '/login/login',
                'data': options,
                'onSuccess': function() {
                    $('#loginIdentifier').focus();
                }
            }
        }
        );
    },
    
    showResetPasswordDialog: function(options) {
        this.resetPasswordDialog = new Dialog(
        {
            'class': 'formDialog',
            'modalOverlayClass': 'formModalOverlay',
            'header': '',
            ajax: {
                'url': '/api/web/getResetPasswordDialog/outputType:raw/',
                'data': options,
                'onSuccess': function() {
                    $('#resetPasswordIdentifier').focus();
                }
            }
        }
        );
    },
    showUpdateAccountDialog: function(options, type) {
        this.updateAccountDialog = new Dialog(
        {
            'class': 'formDialog',
            'modalOverlayClass': 'formModalOverlay',
            'header': '',
            ajax: {
                'url': '/api/web/getUpdateAccountDialog/outputType:raw/',
                'data': options,
                'onSuccess': function() {
                    $('#username').focus();
                }
            }
        }
        );
    },
    showUpdatePasswordDialog: function(options) {
        this.updateAccountDialog = new Dialog(
        {
            'class': 'formDialog',
            'modalOverlayClass': 'formModalOverlay',
            'header': '',
            ajax: {
                'url': '/api/web/getUpdatePasswordDialog/outputType:raw/',
                'data': options,
                'onSuccess': function() {
                    $('#password').focus();
                }
            }
        }
        );
    },
    showUpdateEmailDialog: function(options) {
        this.updateAccountDialog = new Dialog(
        {
            'class': 'formDialog',
            'modalOverlayClass': 'formModalOverlay',
            'header': '',
            ajax: {
                'url': '/api/web/getUpdateEmailDialog/outputType:raw/',
                'data': options,
                'onSuccess': function() {
                    $('#password').focus();
                }
            }
        }
        );
    },
    showSubmitScreenshotDialog: function(options) {
        this.sumbitScreenshotDialog = new Dialog(
        {
            'class': 'formDialog',
            'modalOverlayClass': 'formModalOverlay',
            'header': '',
            ajax: {
                'url': '/api/web/getSubmitScreenshotDialog/outputType:raw/',
                'data': options,
                'onSuccess': function() {
                    //$('#password').focus();
                }
            }
        }
        );
    },
    
    showPasswordResetSentDialog: function(message) {
        if(this.resetPasswordDialog){
            this.resetPasswordDialog.destroy();
        }
        this.passwordResetSentDialog = new Dialog(
        {
            'class': 'formDialog',
            'modalOverlayClass': 'formModalOverlay',
            'header': '',
            'content': message,
            'footer': '',
            'onAfterShow': function() {
            }
        }
        );
    },
    

    showRegisterDialog: function(options) {
        this.registerDialog = new Dialog(
        {
            'class': 'formDialog',
            'modalOverlayClass': 'formModalOverlay',
            'header': '',
            ajax: {
                'url': '/login/registration',
                'data': options,
                'onSuccess': function() {
                    $('#registerEmail').focus();
                }
            }
        }
        );
    },
    
    setupHomeSlider: function(){
        var options = {
            navigation:{ 
                carousel:true, 
                pauseOnNavigate: true,
                arrows: false 
            }, 
            animation:{ 
                type: 'scroll', 
                duration : 1000
            }
        };
        this.homeSlider = new Slider($('#homeSlider'), options);
    },
    
    showRemoveLinkedAccountDialog: function(linkedAccountType) {
        var self = this;
        this.removeLinkedAccountDialog = new Dialog(
        {
            'redirectOnClose': false,
            'redirect': '/user/settings/',
            'class': 'formDialog',
            'modalOverlayClass': 'formModalOverlay',
            'header': '',
            ajax: {
                'url': '/api/web/getRemoveLinkedAccountDialog/outputType:raw/',
                'data': {
                    'linkedAccountType': linkedAccountType
                },
                'onSuccess': function() {
                }
            }
        }
        );
    },
    
    sendEmailVerification: function(){
        var url = '/api/web/sendVerificationEmail/';
        var self = this;
        $.getJSON(url, function(data){
            if(data.response.success){
                self.emailVerificationDialog = new Dialog({
                    'class': 'formDialog',
                    'modalOverlayClass': 'formModalOverlay',
                    'header': '',
                    'content': 'A verification email has been sent to your email',
                    'footer': '',
                    'onAfterShow': function() {
                    }
                });
            }
            
            
        });
        
    },
    
    showSettings: function(element){
        var label = '';
        var link = $(element);
        if(link.data('label') !== undefined){
            label = link.data('label');
        } else {
            link.data('label', link.text());            
        }
       
        
        var wrapper = $(element).closest('.settingsWrapper');
        var children = wrapper.find('p, ul');
        //console.log(children.is(':hidden'));
        if(children.is(':hidden')){
            link.text('close');
            children.slideDown('fast');
        } else {
            link.text(label);
            children.slideUp('fast');
        }
        
    }
    
});
var QRG = new QRGClass();
