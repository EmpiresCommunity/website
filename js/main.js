!function ($) {
    $(function(){
        $('#myCarousel').carousel();
        
        var testimonials = [
            [ "|JPL| Kamber", "This game consistently delivers dynamic game play and heaps of fun. The only game I have played that I have not gotten bored of, even after 5 years." ],
            [ "Darg", "It's free, it's fun, it's the best Source engine mod out there. Give it a try!" ],
            [ "Empty", "This game is a must-have, it's one of the best Source mods I've ever played. If you haven't played Empires yet, download it and give it a shot. You won't regret it." ],
            [ "[VIPER] Vicki", "You tried the rest, now download the best. Empires has it all." ]
        ];
       
        var testimonialDelay = 8000;
       
        var currentTestimonial = 0;
       
        $("#testimonial").html('"' + testimonials[currentTestimonial][1] + '" - ' + testimonials[currentTestimonial][0]);
       
        function nextTestimonial() {
            if (currentTestimonial == testimonials.length - 1) currentTestimonial = 0;
            else currentTestimonial++;
            
            var name = testimonials[currentTestimonial][0];
            var text = testimonials[currentTestimonial][1];

            $("#testimonial").fadeOut(300, function() {
                $("#testimonial").html('"' + text + '" - ' + name);
                $("#testimonial").fadeIn(300);
            });

            setTimeout(nextTestimonial, testimonialDelay);
        }
       
        setTimeout(nextTestimonial, testimonialDelay);
    })
}(window.jQuery)