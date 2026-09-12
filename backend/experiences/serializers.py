from django.db import models
from rest_framework import serializers
from .models import Experience


class ExperienceSerializer(serializers.ModelSerializer):
    gps_lat = serializers.SerializerMethodField()
    gps_lng = serializers.SerializerMethodField()
    latitude = serializers.SerializerMethodField()
    longitude = serializers.SerializerMethodField()
    related_experiences = serializers.SerializerMethodField()

    class Meta:
        model = Experience
        fields = '__all__'

    def get_latitude(self, obj):
        return obj.location.y

    def get_longitude(self, obj):
        return obj.location.x

    def get_gps_lat(self, obj):
        return obj.location.y

    def get_gps_lng(self, obj):
        return obj.location.x

    def validate(self, attrs):
        if attrs.get('is_bookable', False) and not attrs.get('booking_url'):
            raise serializers.ValidationError({'booking_url': 'A booking URL is required for bookable experiences.'})
        return attrs

    def get_related_experiences(self, obj):
        related = Experience.objects.filter(is_published=True).exclude(pk=obj.pk).filter(
            models.Q(category=obj.category) | models.Q(region=obj.region)
        )[:3]
        return [{'title': item.title, 'slug': item.slug, 'image_url': item.image_url} for item in related]
