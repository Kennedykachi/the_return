from django.contrib.gis.db import models as gis_models
from django.db import migrations, models


class Migration(migrations.Migration):
    initial = True
    dependencies = []

    operations = [
        migrations.CreateModel(
            name='Experience',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=160)),
                ('slug', models.SlugField(unique=True)),
                ('category', models.CharField(choices=[('history', 'History'), ('nature', 'Nature'), ('culture', 'Culture'), ('rest', 'Rest')], max_length=20)),
                ('region', models.CharField(max_length=80)),
                ('image_url', models.URLField()),
                ('audio_url', models.URLField(blank=True)),
                ('location', gis_models.PointField(geography=True, srid=4326)),
                ('time_commitment', models.CharField(max_length=80)),
                ('physical_level', models.CharField(max_length=40)),
                ('entry_fee_foreigner', models.CharField(max_length=80)),
                ('description', models.TextField()),
                ('opening_hours', models.CharField(max_length=255)),
                ('best_time_to_visit', models.CharField(max_length=255)),
                ('what_to_bring', models.TextField()),
                ('getting_there', models.TextField()),
                ('bullet_points', models.JSONField(default=list)),
                ('is_published', models.BooleanField(default=False)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
            ],
            options={'ordering': ['title']},
        ),
        migrations.AddIndex(model_name='experience', index=models.Index(fields=['category', 'region'], name='experiences_category_region_idx')),
        migrations.AddIndex(model_name='experience', index=models.Index(fields=['is_published'], name='experiences_published_idx')),
    ]
